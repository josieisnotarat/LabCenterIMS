const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const express = require('express');
const sql = require('mssql');

function loadEnvFile(filePath) {
  try {
    const contents = fs.readFileSync(filePath, 'utf8');
    contents.split(/\r?\n/).forEach(line => {
      const trimmed = line.trim();
      if(!trimmed || trimmed.startsWith('#')){
        return;
      }
      const idx = trimmed.indexOf('=');
      if(idx === -1){
        return;
      }
      const key = trimmed.slice(0, idx).trim();
      if(!key || Object.prototype.hasOwnProperty.call(process.env, key)){
        return;
      }
      let value = trimmed.slice(idx + 1).trim();
      if((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))){
        value = value.slice(1, -1);
      }
      process.env[key] = value;
    });
  } catch (err) {
    if(err.code !== 'ENOENT'){
      console.warn(`Unable to read env file ${filePath}:`, err.message);
    }
  }
}

loadEnvFile(path.join(__dirname, '.env'));
if(process.cwd() !== __dirname){
  loadEnvFile(path.join(process.cwd(), '.env'));
}

const app = express();
app.use(express.json());

const rawServerValue = (process.env.DB_SERVER || 'localhost').trim();
let normalizedServer = rawServerValue;
let instanceName;
let portFromServer;

if (/^tcp:/i.test(normalizedServer)) {
  normalizedServer = normalizedServer.replace(/^tcp:/i, '');
}

const backslashIndex = normalizedServer.indexOf('\\');
if (backslashIndex >= 0) {
  instanceName = normalizedServer.slice(backslashIndex + 1).trim() || undefined;
  normalizedServer = normalizedServer.slice(0, backslashIndex);
}

const commaIndex = normalizedServer.indexOf(',');
if (commaIndex >= 0) {
  portFromServer = normalizedServer.slice(commaIndex + 1).trim();
  normalizedServer = normalizedServer.slice(0, commaIndex);
}

normalizedServer = normalizedServer || 'localhost';

const envPort = Number.parseInt((process.env.DB_PORT || '').trim(), 10);
const parsedEnvPort = Number.isInteger(envPort) && envPort > 0 ? envPort : undefined;
const parsedServerPort = Number.parseInt((portFromServer || '').trim(), 10);
const finalPort = Number.isInteger(parsedServerPort) && parsedServerPort > 0 ? parsedServerPort : parsedEnvPort;

const dbOptions = {
  encrypt: /^true$/i.test(process.env.DB_ENCRYPT || 'false'),
  trustServerCertificate: !/^false$/i.test(process.env.DB_TRUST_SERVER_CERTIFICATE || 'true')
};

if (instanceName) {
  dbOptions.instanceName = instanceName;
}

const dbConfig = {
  user: process.env.DB_USER || 'labcenter_app',
  password: process.env.DB_PASSWORD || 'LabCenter!AppPass',
  server: normalizedServer,
  database: process.env.DB_NAME || 'dbLabCenter',
  options: dbOptions,
  pool: {
    max: Number.parseInt(process.env.DB_POOL_MAX || '10', 10),
    min: Number.parseInt(process.env.DB_POOL_MIN || '0', 10),
    idleTimeoutMillis: Number.parseInt(process.env.DB_POOL_IDLE_TIMEOUT || '30000', 10)
  }
};

if (finalPort) {
  dbConfig.port = finalPort;
}

let pool;
let cachedDefaultUserId = null;
let cachedLoanLabTechTable = null;
const tableColumnCache = new Map();

const SESSION_TIMEOUT_MS = 15 * 60 * 1000;
const sessions = new Map();

const USER_ROLE_LABELS = {
  admin: 'Admin',
  'co-op': 'Co-Op'
};

const USER_ROLE_ALIASES = new Map([
  ['admin', 'admin'],
  ['administrator', 'admin'],
  ['labtech', 'admin'],
  ['lab tech', 'admin'],
  ['lab_tech', 'admin'],
  ['lab-tech', 'admin'],
  ['labtechnician', 'admin'],
  ['lab technician', 'admin'],
  ['co-op', 'co-op'],
  ['coop', 'co-op'],
  ['co op', 'co-op'],
  ['co_op', 'co-op']
]);

async function getPool(){
  if(pool && pool.connected){
    return pool;
  }
  if(pool){
    try { await pool.close(); } catch { /* ignore */ }
  }
  pool = await new sql.ConnectionPool(dbConfig).connect();
  cachedDefaultUserId = null;
  return pool;
}

function asyncHandler(fn){
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

function toIso(value){
  if(!value) return null;
  if(value instanceof Date) return value.toISOString();
  const dt = new Date(value);
  return Number.isNaN(dt.getTime()) ? null : dt.toISOString();
}

function formatName(first, last){
  return [first, last].filter(Boolean).join(' ').trim() || null;
}

function mapAliasRow(row){
  return {
    id: row.intBorrowerAliasID ?? null,
    alias: row.strAlias || '',
    createdUtc: toIso(row.dtmCreated)
  };
}

function mapLoanRow(row){
  const traceNumber = row.intItemLoanID != null
    ? row.intItemLoanID.toString().padStart(6, '0')
    : null;
  return {
    id: row.intItemLoanID ?? null,
    traceNumber,
    itemId: row.intItemID ?? null,
    borrowerId: row.intBorrowerID ?? null,
    itemName: row.snapItemName || null,
    borrowerName: formatName(row.snapBorrowerFirstName, row.snapBorrowerLastName),
    borrowerSchoolId: row.snapSchoolIDNumber || null,
    room: row.snapRoomNumber || null,
    checkoutUtc: toIso(row.dtmCheckoutUTC),
    dueUtc: toIso(row.dtmDueUTC),
    checkinUtc: toIso(row.dtmCheckinUTC),
    status: row.LoanStatus || null
  };
}

function mapTicketRow(row){
  const assignedName = formatName(row.assignedFirstName, row.assignedLastName);
  return {
    id: row.intServiceTicketID ?? null,
    publicId: row.strPublicTicketID || null,
    itemId: row.intItemID ?? null,
    borrowerId: row.intBorrowerID ?? null,
    itemName: row.strItemName || row.strItemLabel || null,
    issue: row.strIssue || null,
    loggedUtc: toIso(row.dtmLoggedUTC),
    assignedName,
    borrowerName: formatName(row.borrowerFirstName, row.borrowerLastName),
    status: row.strStatus || null,
    loggedByName: assignedName
  };
}

function readAuthToken(req){
  const header = req.headers?.authorization;
  if(typeof header === 'string'){
    const match = header.match(/^Bearer\s+(.+)$/i);
    if(match){
      const token = match[1]?.trim();
      if(token){
        return token;
      }
    }
  }
  return null;
}

function getActiveSession(token){
  if(!token) return null;
  const record = sessions.get(token);
  if(!record) return null;
  if(Date.now() - record.lastActive > SESSION_TIMEOUT_MS){
    sessions.delete(token);
    return null;
  }
  record.lastActive = Date.now();
  return record;
}

function createSession(user){
  if(!user || user.id == null){
    throw new Error('Cannot create session without a user id.');
  }
  const token = crypto.randomBytes(32).toString('hex');
  const payload = {
    id: user.id,
    username: user.username || null,
    displayName: user.displayName || null,
    role: user.role || null,
    roleLabel: user.roleLabel || getUserRoleLabel(user.role),
    createdUtc: user.createdUtc || null
  };
  sessions.set(token, { user: payload, lastActive: Date.now() });
  return { token, user: payload };
}

function destroySession(token){
  if(!token) return;
  sessions.delete(token);
}

function invalidateSessionsForUser(userId){
  if(userId == null) return;
  for(const [token, session] of sessions.entries()){
    if(session.user?.id === userId){
      sessions.delete(token);
    }
  }
}

function updateSessionsForUser(user){
  if(!user || user.id == null) return;
  for(const [, session] of sessions.entries()){
    if(session.user?.id === user.id){
      session.user = {
        id: user.id,
        username: user.username || null,
        displayName: user.displayName || null,
        role: user.role || null,
        roleLabel: user.roleLabel || getUserRoleLabel(user.role),
        createdUtc: user.createdUtc || null
      };
      session.lastActive = Date.now();
    }
  }
}

function isApiRequest(req){
  return typeof req.path === 'string' && req.path.startsWith('/api');
}

function isPublicApiRoute(req){
  if(req.method === 'POST' && req.path === '/api/login') return true;
  if(req.method === 'GET' && req.path === '/api/session') return true;
  return false;
}

app.use((req, res, next) => {
  if(!isApiRequest(req)){
    return next();
  }

  const token = readAuthToken(req);
  if(token){
    const session = getActiveSession(token);
    if(session){
      req.user = session.user;
      req.sessionToken = token;
    }
  }

  if(isPublicApiRoute(req)){
    return next();
  }

  if(!req.user){
    return res.status(401).json({ error: 'Authentication required.' });
  }

  return next();
});

app.post('/api/login', asyncHandler(async (req, res) => {
  const username = normalizeString(req.body?.username).toLowerCase();
  const password = normalizeString(req.body?.password);
  if(!username || !password){
    return res.status(400).json({ error: 'Username and password are required.' });
  }

  const pool = await getPool();
  let user;
  try {
    user = await findUserByCredentials(pool, username, password);
  } catch(err){
    console.error('Unable to verify login credentials:', err);
    return res.status(500).json({ error: 'Unable to verify login credentials.' });
  }

  if(!user){
    return res.status(401).json({ error: 'Invalid username or password.' });
  }

  const session = createSession(user);
  res.json({ token: session.token, user: session.user });
}));

app.get('/api/session', asyncHandler(async (req, res) => {
  if(!req.user){
    return res.status(401).json({ error: 'Not authenticated.' });
  }
  res.json({ user: req.user });
}));

app.post('/api/logout', asyncHandler(async (req, res) => {
  if(req.sessionToken){
    destroySession(req.sessionToken);
  }
  res.json({ success: true });
}));

app.get('/api/dashboard-stats', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const result = await pool.request().execute('dbo.usp_GetDashboardStats');
  const stats = result.recordset?.[0] || {};
  res.json({
    outNow: stats.outNow ?? 0,
    dueToday: stats.dueToday ?? 0,
    repairs: stats.repairs ?? 0,
    overdue: stats.overdue ?? 0
  });
}));

app.get('/api/loans', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const top = Number.parseInt(req.query.top || '50', 10);
  const request = pool.request();
  request.input('Top', sql.Int, Number.isFinite(top) ? top : 50);
  request.input('StatusFilter', sql.VarChar(30), req.query.status || null);
  request.input('Search', sql.NVarChar(120), req.query.search || null);
  const result = await request.execute('dbo.usp_GetRecentLoans');
  const entries = result.recordset?.map(mapLoanRow) || [];
  res.json({ entries });
}));

app.get('/api/service-tickets', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const top = Number.parseInt(req.query.top || '50', 10);
  const request = pool.request();
  request.input('Top', sql.Int, Number.isFinite(top) ? top : 50);
  request.input('StatusFilter', sql.VarChar(30), req.query.status || null);
  request.input('Search', sql.NVarChar(120), req.query.search || null);
  const result = await request.execute('dbo.usp_GetServiceTickets');
  const entries = result.recordset?.map(mapTicketRow) || [];
  res.json({ entries });
}));

app.get('/api/borrowers/search', asyncHandler(async (req, res) => {
  const query = normalizeString(req.query.query || req.query.q || req.query.term);
  if(!query || query.length < 2){
    return res.json({ entries: [] });
  }

  const top = Number.parseInt(req.query.top || '8', 10);
  const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 50) : 8;
  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const primaryRequest = pool.request();
  primaryRequest.input('SearchTerm', sql.NVarChar(120), query);
  primaryRequest.input('Top', sql.Int, limit);
  const result = await primaryRequest.execute('dbo.usp_SearchBorrowers');
  const rows = result.recordset || [];

  const entries = [];
  const seen = new Set();

  const appendRow = (row, aliasMatch = null) => {
    const rawId = row.intBorrowerID ?? row.id ?? row.intBorrowerId ?? row.borrowerId;
    const parsedId = Number.parseInt(rawId, 10);
    if(!Number.isFinite(parsedId) || seen.has(parsedId)){
      return;
    }
    seen.add(parsedId);
    const first = row.strFirstName || row.firstName;
    const last = row.strLastName || row.lastName;
    const alias = aliasMatch || row.MatchedAlias || row.matchedAlias || row.strAlias || row.alias || null;
    const displayName = formatName(first, last) || alias || `Customer #${parsedId}`;
    entries.push({
      id: parsedId,
      name: displayName,
      schoolId: row.strSchoolIDNumber || row.schoolId || null,
      alias: alias || null
    });
  };

  rows.forEach(row => appendRow(row));

  const aliasRequest = pool.request();
  aliasRequest.input('Top', sql.Int, limit);
  aliasRequest.input('Search', sql.NVarChar(130), `%${query}%`);
  const aliasResult = await aliasRequest.query(`
    SELECT TOP (@Top)
           b.intBorrowerID,
           b.strFirstName,
           b.strLastName,
           b.strSchoolIDNumber,
           a.strAlias,
           a.intBorrowerAliasID
    FROM dbo.TBorrowers AS b
    INNER JOIN dbo.TBorrowerAliases AS a ON a.intBorrowerID = b.intBorrowerID
    WHERE a.strAlias LIKE @Search
    ORDER BY a.intBorrowerAliasID DESC;
  `);
  aliasResult.recordset?.forEach(row => appendRow(row, row.strAlias));

  res.json({ entries: entries.slice(0, limit) });
}));

app.get('/api/loans/:id/notes', asyncHandler(async (req, res) => {
  const loanId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(loanId)){
    return res.status(400).json({ error: 'Invalid loan id.' });
  }

  const pool = await getPool();
  const result = await pool.request()
    .input('LoanID', sql.Int, loanId)
    .query(`
      SELECT n.intItemLoanNoteID, n.dtmNoteUTC, n.strNote,
             lt.strFirstName, lt.strLastName
      FROM dbo.TItemLoanNotes AS n
      LEFT JOIN dbo.TLabTechs AS lt ON lt.intLabTechID = n.intLabTechID
      WHERE n.intItemLoanID = @LoanID
      ORDER BY n.dtmNoteUTC DESC;
    `);

  const entries = result.recordset?.map(row => ({
    id: row.intItemLoanNoteID ?? null,
    note: row.strNote || '',
    timestamp: toIso(row.dtmNoteUTC),
    author: formatName(row.strFirstName, row.strLastName)
  })) || [];

  res.json({ entries });
}));

app.get('/api/service-tickets/:id/notes', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const ticketId = await resolveServiceTicketId(pool, req.params.id);
  if(!ticketId){
    return res.status(404).json({ error: 'Service ticket not found.' });
  }

  const result = await pool.request()
    .input('TicketId', sql.Int, ticketId)
    .query(`
      SELECT n.intServiceTicketNoteID, n.dtmNoteUTC, n.strNote,
             lt.strFirstName, lt.strLastName
      FROM dbo.TServiceTicketNotes AS n
      LEFT JOIN dbo.TLabTechs AS lt ON lt.intLabTechID = n.intLabTechID
      WHERE n.intServiceTicketID = @TicketId
      ORDER BY n.dtmNoteUTC DESC;
    `);

  const entries = result.recordset?.map(row => ({
    id: row.intServiceTicketNoteID ?? null,
    note: row.strNote || '',
    timestamp: toIso(row.dtmNoteUTC),
    author: formatName(row.strFirstName, row.strLastName)
  })) || [];

  res.json({ entries });
}));

app.get('/api/audit-log', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const top = Number.parseInt(req.query.top || '50', 10);
  const request = pool.request();
  request.input('Top', sql.Int, Number.isFinite(top) ? top : 50);
  const result = await request.execute('dbo.usp_GetAuditLog');
  const entries = result.recordset?.map(row => ({
    intTraceID: row.intTraceID,
    dtmEventUTC: toIso(row.dtmEventUTC),
    intLabTechID: row.intLabTechID ?? null,
    strFirstName: row.strFirstName || null,
    strLastName: row.strLastName || null,
    strAction: row.strAction || null,
    strEntity: row.strEntity || null,
    intEntityPK: row.intEntityPK ?? null,
    strDetails: row.strDetails || null
  })) || [];
  res.json({ entries });
}));

function normalizeString(value){
  if(typeof value !== 'string') return '';
  return value.trim();
}

function normalizeUserRole(value){
  if(value == null) return null;
  const text = value.toString().trim();
  if(!text) return null;
  const lower = text.toLowerCase();
  if(USER_ROLE_ALIASES.has(lower)){
    return USER_ROLE_ALIASES.get(lower);
  }
  const collapsedSpaces = lower.replace(/[\s_]+/g, ' ');
  if(USER_ROLE_ALIASES.has(collapsedSpaces)){
    return USER_ROLE_ALIASES.get(collapsedSpaces);
  }
  const collapsed = lower.replace(/[\s_-]+/g, '');
  if(USER_ROLE_ALIASES.has(collapsed)){
    return USER_ROLE_ALIASES.get(collapsed);
  }
  return null;
}

function getUserRoleLabel(role){
  const canonical = normalizeUserRole(role);
  if(canonical && USER_ROLE_LABELS[canonical]){
    return USER_ROLE_LABELS[canonical];
  }
  const trimmed = normalizeString(role);
  return trimmed || null;
}

function toIntOrNull(value){
  if(value == null || value === '') return null;
  const n = Number.parseInt(value, 10);
  return Number.isFinite(n) ? n : null;
}

function toTimeParts(value){
  if(!value) return null;
  if(typeof value === 'string'){
    const trimmed = value.trim();
    const match = trimmed.match(/^(\d{1,2})(?::(\d{1,2}))?(?::(\d{1,2})(?:\.\d{1,7})?)?$/);
    if(!match) return null;
    const [, h, m = '0', s = '0'] = match;
    const hour = Math.min(23, Math.max(0, Number.parseInt(h, 10) || 0));
    const minute = Math.min(59, Math.max(0, Number.parseInt(m, 10) || 0));
    const second = Math.min(59, Math.max(0, Number.parseInt(s, 10) || 0));
    return { hour, minute, second };
  }
  if(value instanceof Date){
    return { hour: value.getHours(), minute: value.getMinutes(), second: value.getSeconds() };
  }
  if(typeof value === 'object' && value !== null){
    const hour = toIntOrNull(value.hour);
    if(hour == null) return null;
    const minute = toIntOrNull(value.minute) ?? 0;
    const second = toIntOrNull(value.second) ?? 0;
    return { hour: Math.min(23, Math.max(0, hour)), minute: Math.min(59, Math.max(0, minute)), second: Math.min(59, Math.max(0, second)) };
  }
  return null;
}

function normalizeTimeForSql(value){
  const parts = toTimeParts(value);
  if(!parts) return null;
  return `${parts.hour.toString().padStart(2, '0')}:${parts.minute.toString().padStart(2, '0')}:${parts.second.toString().padStart(2, '0')}`;
}

function formatSqlTime(value){
  if(!value) return null;
  const parts = toTimeParts(value);
  if(parts){
    const { hour, minute, second } = parts;
    return `${hour.toString().padStart(2, '0')}:${minute
      .toString()
      .padStart(2, '0')}:${second.toString().padStart(2, '0')}`;
  }
  if(typeof value === 'string'){
    const trimmed = value.trim();
    if(!trimmed) return null;
    const parsed = new Date(`1970-01-01T${trimmed}`);
    if(!Number.isNaN(parsed.getTime())){
      return parsed.toISOString().substring(11, 19);
    }
  }
  if(value instanceof Date){
    return value.toISOString().substring(11, 19);
  }
  return null;
}

async function getItemDueSettings(pool, itemId){
  const result = await pool.request()
    .input('ItemID', sql.Int, itemId)
    .query(`
      SELECT intItemID, strItemName, strDuePolicy,
             intDueDaysOffset, intDueHoursOffset, tDueTime, dtmFixedDueLocal
      FROM dbo.TItems
      WHERE intItemID = @ItemID;
    `);
  return result.recordset?.[0] || null;
}

function describeOffset(days, hours, timeParts){
  const parts = [];
  if(Number.isInteger(days)) parts.push(`${days} day${days === 1 ? '' : 's'}`);
  if(timeParts){
    parts.push(`at ${timeParts.hour.toString().padStart(2, '0')}:${timeParts.minute.toString().padStart(2, '0')}`);
  }else if(Number.isInteger(hours) && hours){
    parts.push(`+${hours} hour${hours === 1 ? '' : 's'}`);
  }
  return parts.join(' ');
}

function computeDueFromPolicy(row){
  if(!row) return null;
  const policy = (row.strDuePolicy || 'NEXT_DAY_6PM').toUpperCase();
  const now = new Date();
  let due = null;
  let description = '';

  if(policy === 'SEMESTER' || policy === 'FIXED'){
    if(row.dtmFixedDueLocal){
      const fixed = new Date(row.dtmFixedDueLocal);
      if(!Number.isNaN(fixed.getTime())){
        due = fixed;
        description = 'Semester due';
      }else{
        description = 'Semester due date not configured';
      }
    }else{
      description = 'Semester due date not configured';
    }
  }else{
    const days = Number.isInteger(row.intDueDaysOffset) ? row.intDueDaysOffset : (policy === 'NEXT_DAY_6PM' ? 1 : 0);
    const hours = Number.isInteger(row.intDueHoursOffset) ? row.intDueHoursOffset : 0;
    const timeParts = toTimeParts(row.tDueTime);
    const effectiveTime = timeParts || (policy === 'NEXT_DAY_6PM'
      ? { hour: 18, minute: 0, second: 0 }
      : null);
    due = new Date(now.getTime());
    if(days) due.setDate(due.getDate() + days);
    if(effectiveTime){
      due.setHours(effectiveTime.hour, effectiveTime.minute, effectiveTime.second, 0);
    }else if(hours){
      due.setHours(due.getHours() + hours);
    }
    if(policy === 'NEXT_DAY_6PM'){
      description = 'Next day at 6:00 PM';
    }else{
      const desc = describeOffset(days, hours, timeParts);
      description = desc ? `Offset ${desc}` : 'Custom offset';
    }
  }

  const dueUtc = due ? due.toISOString() : null;
  return {
    dueUtc,
    policy,
    description: description || policy,
    itemName: row.strItemName || null
  };
}

async function resolveItemDue(pool, itemId){
  const settings = await getItemDueSettings(pool, itemId);
  if(!settings) return null;
  return computeDueFromPolicy(settings);
}

function mapItemRow(row){
  if(!row) return null;
  const dueInfo = computeDueFromPolicy(row);
  return {
    id: row.intItemID ?? null,
    name: row.strItemName || null,
    department: row.strDepartmentName || null,
    schoolOwned: row.blnIsSchoolOwned ? true : false,
    description: row.strDescription || null,
    duePolicy: (row.strDuePolicy || null) && row.strDuePolicy.toUpperCase(),
    duePolicyDescription: dueInfo?.description || null,
    dueDaysOffset: Number.isInteger(row.intDueDaysOffset)
      ? row.intDueDaysOffset
      : null,
    dueHoursOffset: Number.isInteger(row.intDueHoursOffset)
      ? row.intDueHoursOffset
      : null,
    dueTime: formatSqlTime(row.tDueTime),
    fixedDueLocal: toIso(row.dtmFixedDueLocal),
    lastUpdatedUtc: toIso(row.dtmLastUpdated || row.dtmUpdated || row.dtmCreated || null)
  };
}

async function loadItemRow(pool, itemId){
  const result = await pool.request()
    .input('ItemID', sql.Int, itemId)
    .query(`
      SELECT i.intItemID,
             i.strItemName,
             i.blnIsSchoolOwned,
             i.intDepartmentID,
             i.strDescription,
             i.strDuePolicy,
             i.intDueDaysOffset,
             i.intDueHoursOffset,
             i.tDueTime,
             i.dtmFixedDueLocal,
             i.dtmCreated,
             d.strDepartmentName
      FROM dbo.TItems AS i
      LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = i.intDepartmentID
      WHERE i.intItemID = @ItemID;
    `);
  return result.recordset?.[0] || null;
}

async function resolveServiceTicketId(pool, identifier){
  const numericId = Number.parseInt(identifier, 10);
  const request = pool.request();
  request.input('TicketId', sql.Int, Number.isFinite(numericId) ? numericId : null);
  request.input('PublicId', sql.VarChar(20), normalizeString(identifier) || null);
  const result = await request.query(`
    SELECT TOP (1) intServiceTicketID
    FROM dbo.TServiceTickets
    WHERE (@TicketId IS NOT NULL AND intServiceTicketID = @TicketId)
       OR (strPublicTicketID = @PublicId)
    ORDER BY intServiceTicketID DESC;
  `);
  return result.recordset?.[0]?.intServiceTicketID ?? null;
}

async function ensureDepartment(pool, name){
  const deptName = normalizeString(name);
  if(!deptName) return null;

  const lookup = await pool.request()
    .input('Name', sql.VarChar(100), deptName)
    .query(`
      SELECT intDepartmentID
      FROM dbo.TDepartments
      WHERE LOWER(strDepartmentName) = LOWER(@Name);
    `);
  if(lookup.recordset?.length){
    return lookup.recordset[0].intDepartmentID;
  }

  try {
    const insert = await pool.request()
      .input('Name', sql.VarChar(100), deptName)
      .query(`
        INSERT dbo.TDepartments(strDepartmentName)
        VALUES (@Name);
        SELECT SCOPE_IDENTITY() AS intDepartmentID;
      `);
    return insert.recordset?.[0]?.intDepartmentID ?? null;
  } catch(err){
    if(err && (err.number === 2601 || err.number === 2627)){
      const retry = await pool.request()
        .input('Name', sql.VarChar(100), deptName)
        .query(`
          SELECT intDepartmentID
          FROM dbo.TDepartments
          WHERE LOWER(strDepartmentName) = LOWER(@Name);
        `);
      if(retry.recordset?.length){
        return retry.recordset[0].intDepartmentID;
      }
    }
    throw err;
  }
}

async function ensureBorrowerAliasTable(pool){
  await pool.request().query(`
    IF OBJECT_ID('dbo.TBorrowerAliases','U') IS NULL
    BEGIN
      CREATE TABLE dbo.TBorrowerAliases
      (
        intBorrowerAliasID INT IDENTITY(1,1) PRIMARY KEY,
        intBorrowerID      INT NOT NULL REFERENCES dbo.TBorrowers(intBorrowerID) ON DELETE CASCADE,
        strAlias           NVARCHAR(120) NOT NULL,
        dtmCreated         DATETIME2(0) NOT NULL CONSTRAINT DF_TBorrowerAliases_Created DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_TBorrowerAliases UNIQUE (intBorrowerID, strAlias)
      );
      CREATE INDEX IX_TBorrowerAliases_Alias ON dbo.TBorrowerAliases(strAlias);
    END;
  `);
}

async function loadAliasesForBorrowers(pool, borrowerIds){
  if(!Array.isArray(borrowerIds) || !borrowerIds.length){
    return new Map();
  }

  const uniqueIds = Array.from(new Set(
    borrowerIds
      .map(id => Number.parseInt(id, 10))
      .filter(id => Number.isInteger(id))
  ));
  if(!uniqueIds.length){
    return new Map();
  }

  const request = pool.request();
  const params = uniqueIds.map((id, idx) => {
    const paramName = `Borrower${idx}`;
    request.input(paramName, sql.Int, id);
    return `@${paramName}`;
  });

  const result = await request.query(`
    SELECT intBorrowerAliasID, intBorrowerID, strAlias, dtmCreated
    FROM dbo.TBorrowerAliases
    WHERE intBorrowerID IN (${params.join(',')})
    ORDER BY strAlias;
  `);

  const map = new Map();
  const rows = result.recordset || [];
  rows.forEach(row => {
    const list = map.get(row.intBorrowerID) || [];
    list.push(mapAliasRow(row));
    map.set(row.intBorrowerID, list);
  });

  return map;
}

function stripSchema(tableName){
  return tableName.replace(/^[^.]+\./, '');
}

async function getTableColumns(pool, tableName){
  const key = stripSchema(tableName);
  if(tableColumnCache.has(key)){
    return tableColumnCache.get(key);
  }
  const result = await pool.request()
    .input('TableName', sql.NVarChar(128), key)
    .query(`
      SELECT COLUMN_NAME
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = @TableName;
    `);
  const columns = new Set((result.recordset || []).map(row => row.COLUMN_NAME));
  tableColumnCache.set(key, columns);
  return columns;
}

function buildActiveFilter(columns, alias = ''){
  const prefix = alias ? `${alias}.` : '';
  if(columns.has('blnIsActive')) return `${prefix}blnIsActive = 1`;
  if(columns.has('blnActive')) return `${prefix}blnActive = 1`;
  if(columns.has('IsActive')) return `${prefix}IsActive = 1`;
  if(columns.has('Active')) return `${prefix}Active = 1`;
  return '';
}

async function getLoanLabTechTable(pool){
  if(cachedLoanLabTechTable){
    return cachedLoanLabTechTable;
  }
  const result = await pool.request().query(`
    SELECT
      CASE WHEN OBJECT_ID('dbo.TItemLoans','U') IS NOT NULL THEN 1 ELSE 0 END AS HasModernLoans,
      CASE WHEN OBJECT_ID('dbo.TLabTechs','U') IS NOT NULL THEN 1 ELSE 0 END AS HasModernTechs,
      CASE WHEN OBJECT_ID('dbo.tblLoan','U') IS NOT NULL THEN 1 ELSE 0 END AS HasLegacyLoans,
      CASE WHEN OBJECT_ID('dbo.tblLabTechs','U') IS NOT NULL THEN 1 ELSE 0 END AS HasLegacyTechs;
  `);
  const row = result.recordset?.[0] || {};
  if(row.HasModernLoans && row.HasModernTechs){
    cachedLoanLabTechTable = 'dbo.TLabTechs';
  } else if(row.HasLegacyLoans && row.HasLegacyTechs){
    cachedLoanLabTechTable = 'dbo.tblLabTechs';
  } else if(row.HasModernTechs){
    cachedLoanLabTechTable = 'dbo.TLabTechs';
  } else if(row.HasLegacyTechs){
    cachedLoanLabTechTable = 'dbo.tblLabTechs';
  } else {
    cachedLoanLabTechTable = 'dbo.TLabTechs';
  }
  return cachedLoanLabTechTable;
}

async function ensureLabTechIdInLoanTable(pool, candidateId, username){
  const table = await getLoanLabTechTable(pool);
  const columns = await getTableColumns(pool, table);
  if(!columns.size){
    return candidateId ?? null;
  }
  const idColumn = columns.has('intLabTechID') ? 'intLabTechID'
    : (columns.has('LabTechID') ? 'LabTechID' : null);
  if(!idColumn){
    return candidateId ?? null;
  }

  if(candidateId != null){
    const exists = await pool.request()
      .input('LabTechID', sql.Int, candidateId)
      .query(`
        SELECT 1 AS found
        FROM ${table}
        WHERE ${idColumn} = @LabTechID;
      `);
    if(exists.recordset?.length){
      return candidateId;
    }
  }

  const normalizedUsername = typeof username === 'string' ? username.trim().toLowerCase() : null;
  const usernameColumn = columns.has('strUsername') ? 'strUsername'
    : (columns.has('Username') ? 'Username' : null);
  if(normalizedUsername && usernameColumn){
    let usernameQuery = `
      SELECT TOP (1) ${idColumn} AS LabTechID
      FROM ${table}
      WHERE LOWER(${usernameColumn}) = @Username
    `;
    const activeFilter = buildActiveFilter(columns);
    if(activeFilter){
      usernameQuery += ` AND ${activeFilter}`;
    }
    usernameQuery += ` ORDER BY ${idColumn};`;
    const usernameResult = await pool.request()
      .input('Username', sql.VarChar(150), normalizedUsername)
      .query(usernameQuery);
    const resolvedByUsername = usernameResult.recordset?.[0]?.LabTechID;
    if(resolvedByUsername != null){
      return resolvedByUsername;
    }
  }

  let fallbackQuery = `
    SELECT TOP (1) ${idColumn} AS LabTechID
    FROM ${table}
  `;
  const activeFilter = buildActiveFilter(columns);
  if(activeFilter){
    fallbackQuery += ` WHERE ${activeFilter}`;
  }
  fallbackQuery += ` ORDER BY ${idColumn};`;
  const fallbackResult = await pool.request().query(fallbackQuery);
  const fallbackId = fallbackResult.recordset?.[0]?.LabTechID ?? null;
  if(candidateId != null && fallbackId != null && fallbackId !== candidateId){
    console.warn(`Lab tech id ${candidateId} not found in ${table}; using ${fallbackId} instead.`);
  }
  return fallbackId;
}

async function resolveLabTechIdForLoans(pool, user){
  const candidateRaw = user?.id;
  const candidateId = Number.isFinite(candidateRaw) ? candidateRaw : Number.parseInt(candidateRaw, 10);
  const username = typeof user?.username === 'string' ? user.username : null;
  const resolved = await ensureLabTechIdInLoanTable(pool, Number.isFinite(candidateId) ? candidateId : null, username);
  if(resolved != null){
    return resolved;
  }
  const fallback = await ensureLabTechIdInLoanTable(pool, null, null);
  if(fallback == null){
    throw new Error('No active user available for checkout.');
  }
  return fallback;
}

async function getDefaultUserId(pool){
  if(cachedDefaultUserId != null){
    return cachedDefaultUserId;
  }
  const id = await ensureLabTechIdInLoanTable(pool, null, null);
  if(id == null){
    throw new Error('No active user available for checkout.');
  }
  cachedDefaultUserId = id;
  return id;
}

function splitName(full){
  const trimmed = normalizeString(full);
  if(!trimmed) return { first:null, last:null };
  const parts = trimmed.split(/\s+/);
  if(parts.length === 1){
    return { first: parts[0], last: null };
  }
  const first = parts.shift();
  const last = parts.join(' ').trim() || null;
  return { first, last };
}

async function findBorrowerId(pool, payload){
  if(payload == null) return null;

  const rawBorrowerId = payload.borrowerId ?? payload.intBorrowerID;
  if(rawBorrowerId != null){
    const borrowerId = Number.parseInt(rawBorrowerId, 10);
    if(Number.isFinite(borrowerId)){
      const res = await pool.request()
        .input('BorrowerID', sql.Int, borrowerId)
        .query('SELECT intBorrowerID FROM dbo.TBorrowers WHERE intBorrowerID = @BorrowerID;');
      if(res.recordset?.length){
        return borrowerId;
      }
    }
  }

  const schoolId = normalizeString(payload.schoolId || payload.schoolID || payload.schoolIdNumber);
  if(schoolId){
    const res = await pool.request()
      .input('SchoolID', sql.VarChar(50), schoolId)
      .query(`
        SELECT TOP (1) intBorrowerID
        FROM dbo.TBorrowers
        WHERE strSchoolIDNumber = @SchoolID
        ORDER BY intBorrowerID DESC;
      `);
    if(res.recordset?.length){
      return res.recordset[0].intBorrowerID;
    }
  }

  const nameSource = payload.customerName || payload.name;
  if(nameSource){
    const { first, last } = splitName(nameSource);
    if(first && last){
      const res = await pool.request()
        .input('First', sql.VarChar(50), first)
        .input('Last', sql.VarChar(50), last)
        .query(`
          SELECT TOP (1) intBorrowerID
          FROM dbo.TBorrowers
          WHERE strFirstName = @First AND strLastName = @Last
          ORDER BY intBorrowerID DESC;
        `);
      if(res.recordset?.length){
        return res.recordset[0].intBorrowerID;
      }
    }

    const aliasText = normalizeString(nameSource);
    if(aliasText){
      await ensureBorrowerAliasTable(pool);
      const aliasExact = await pool.request()
        .input('Alias', sql.NVarChar(120), aliasText)
        .query(`
          SELECT TOP (1) intBorrowerID
          FROM dbo.TBorrowerAliases
          WHERE strAlias = @Alias
          ORDER BY intBorrowerAliasID DESC;
        `);
      if(aliasExact.recordset?.length){
        return aliasExact.recordset[0].intBorrowerID;
      }

      const aliasLike = await pool.request()
        .input('AliasLike', sql.NVarChar(130), `%${aliasText}%`)
        .query(`
          SELECT TOP (1) intBorrowerID
          FROM dbo.TBorrowerAliases
          WHERE strAlias LIKE @AliasLike
          ORDER BY intBorrowerAliasID DESC;
        `);
      if(aliasLike.recordset?.length){
        return aliasLike.recordset[0].intBorrowerID;
      }
    }

    const fuzzy = normalizeString(nameSource);
    if(fuzzy){
      const res = await pool.request()
        .input('Search', sql.NVarChar(120), fuzzy)
        .query(`
          SELECT TOP (1) intBorrowerID
          FROM dbo.TBorrowers
          WHERE strFirstName LIKE N'%' + @Search + N'%' OR strLastName LIKE N'%' + @Search + N'%' OR ISNULL(strSchoolIDNumber,'') LIKE N'%' + @Search + N'%'
          ORDER BY intBorrowerID DESC;
        `);
      if(res.recordset?.length){
        return res.recordset[0].intBorrowerID;
      }
    }
  }

  return null;
}

async function findItemId(pool, raw){
  const value = normalizeString(raw);
  if(!value) return null;

  const numeric = Number.parseInt(value, 10);
  if(Number.isFinite(numeric)){
    const byId = await pool.request()
      .input('ItemID', sql.Int, numeric)
      .query('SELECT intItemID FROM dbo.TItems WHERE intItemID = @ItemID;');
    if(byId.recordset?.length){
      return byId.recordset[0].intItemID;
    }
  }

  const exact = await pool.request()
    .input('Match', sql.VarChar(120), value)
    .query(`
      SELECT TOP (1) intItemID
      FROM dbo.TItems
      WHERE strItemName = @Match
      ORDER BY intItemID DESC;
    `);
  if(exact.recordset?.length){
    return exact.recordset[0].intItemID;
  }

  const like = await pool.request()
    .input('Search', sql.NVarChar(120), `%${value}%`)
    .query(`
      SELECT TOP (1) intItemID
      FROM dbo.TItems
      WHERE strItemName LIKE @Search
      ORDER BY intItemID DESC;
    `);
  if(like.recordset?.length){
    return like.recordset[0].intItemID;
  }

  return null;
}

function parseLocalDateTime(value){
  if(!value) return null;
  const dt = new Date(value);
  if(Number.isNaN(dt.getTime())) return null;
  return dt;
}

async function ensureUserTable(pool){
  await pool.request().query(`
    IF OBJECT_ID('dbo.TLabTechs','U') IS NULL
    BEGIN
      CREATE TABLE dbo.TLabTechs
      (
        intLabTechID   INT IDENTITY(1,1) PRIMARY KEY,
        strUsername    VARCHAR(120) NOT NULL UNIQUE,
        strDisplayName VARCHAR(150) NOT NULL,
        strFirstName   VARCHAR(50)  NOT NULL,
        strLastName    VARCHAR(50)  NOT NULL,
        strEmail       VARCHAR(120) NULL,
        strPhoneNumber VARCHAR(25)  NULL,
        strPassword    VARCHAR(255) NOT NULL CONSTRAINT DF_TLabTechs_Password DEFAULT ('password123'),
        strRole        VARCHAR(50)  NOT NULL,
        blnIsActive    BIT          NOT NULL CONSTRAINT DF_TLabTechs_IsActive DEFAULT (1),
        dtmCreated     DATETIME2(0) NOT NULL CONSTRAINT DF_TLabTechs_Created DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT CK_TLabTechs_Role CHECK (strRole IN ('admin','co-op'))
      );
    END;

    IF COL_LENGTH('dbo.TLabTechs','strPassword') IS NULL
    BEGIN
      ALTER TABLE dbo.TLabTechs
        ADD strPassword VARCHAR(255) NOT NULL CONSTRAINT DF_TLabTechs_Password DEFAULT ('password123') WITH VALUES;
    END;
  `);
}

async function ensureUserCredentialTable(pool){
  await pool.request().query(`
    IF OBJECT_ID('dbo.TLabTechCredentials','U') IS NULL
    BEGIN
      CREATE TABLE dbo.TLabTechCredentials
      (
        intLabTechID   INT NOT NULL PRIMARY KEY REFERENCES dbo.TLabTechs(intLabTechID) ON DELETE CASCADE,
        strPasswordHash VARBINARY(32) NOT NULL,
        dtmUpdated     DATETIME2(0) NOT NULL CONSTRAINT DF_TLabTechCredentials_Updated DEFAULT (SYSUTCDATETIME())
      );
    END;
  `);
}

async function ensureUserCredentials(pool){
  await ensureUserTable(pool);
  await ensureUserCredentialTable(pool);
  await pool.request()
    .input('DefaultPassword', sql.VarChar(255), DEFAULT_USER_PASSWORD)
    .query(`
      INSERT INTO dbo.TLabTechCredentials(intLabTechID, strPasswordHash)
      SELECT lt.intLabTechID, HASHBYTES('SHA2_256', @DefaultPassword)
      FROM dbo.TLabTechs AS lt
      LEFT JOIN dbo.TLabTechCredentials AS cred ON cred.intLabTechID = lt.intLabTechID
      WHERE cred.intLabTechID IS NULL;
    `);
}

function mapUserRow(row){
  if(!row) return null;
  const canonicalRole = normalizeUserRole(row.strRole);
  return {
    id: row.intLabTechID ?? null,
    username: row.strUsername || null,
    displayName: row.strDisplayName || null,
    role: canonicalRole || (row.strRole || null),
    roleLabel: getUserRoleLabel(row.strRole),
    createdUtc: toIso(row.dtmCreated)
  };
}

async function findUserByCredentials(pool, username, password){
  const result = await pool.request()
    .input('Username', sql.VarChar(120), username)
    .input('Password', sql.VarChar(255), password)
    .query(`
      SELECT TOP (1)
             intLabTechID,
             strUsername,
             strDisplayName,
             strRole,
             dtmCreated
      FROM dbo.TLabTechs
      WHERE blnIsActive = 1
        AND LOWER(strUsername) = @Username
        AND strPassword = @Password;
    `);
  return mapUserRow(result.recordset?.[0] || null);
}

async function generatePublicTicketId(pool){
  const result = await pool.request().query(`
    SELECT TOP (1) strPublicTicketID
    FROM dbo.TServiceTickets
    WHERE strPublicTicketID LIKE 'S-%'
    ORDER BY TRY_CONVERT(INT, SUBSTRING(strPublicTicketID,3,10)) DESC, intServiceTicketID DESC;
  `);
  const lastId = result.recordset?.[0]?.strPublicTicketID;
  const lastNumber = lastId ? Number.parseInt(lastId.replace(/[^0-9]/g, ''), 10) : 0;
  const next = Number.isFinite(lastNumber) ? lastNumber + 1 : 1;
  return `S-${next.toString().padStart(4, '0')}`;
}

app.get('/api/customers', asyncHandler(async (req, res) => {
  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const top = Number.parseInt(req.query.top || '25', 10);
  const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 200) : 25;
  const search = normalizeString(req.query.search || req.query.q || req.query.query);

  const request = pool.request();
  request.input('Top', sql.Int, limit);

  let queryText;
  if(search){
    request.input('Search', sql.NVarChar(130), `%${search}%`);
    queryText = `
      SELECT TOP (@Top)
             b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             b.strPhoneNumber,
             b.strRoomNumber,
             b.strInstructor,
             b.dtmCreated,
             d.strDepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = b.intDepartmentID
      WHERE b.strFirstName LIKE @Search
         OR b.strLastName LIKE @Search
         OR (b.strFirstName + ' ' + b.strLastName) LIKE @Search
         OR ISNULL(b.strSchoolIDNumber,'') LIKE @Search
         OR ISNULL(b.strPhoneNumber,'') LIKE @Search
         OR EXISTS (
             SELECT 1
             FROM dbo.TBorrowerAliases AS a
             WHERE a.intBorrowerID = b.intBorrowerID
               AND a.strAlias LIKE @Search
         )
      ORDER BY b.strLastName, b.strFirstName, b.intBorrowerID DESC;
    `;
  }else{
    queryText = `
      SELECT TOP (@Top)
             b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             b.strPhoneNumber,
             b.strRoomNumber,
             b.strInstructor,
             b.dtmCreated,
             d.strDepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = b.intDepartmentID
      ORDER BY b.dtmCreated DESC, b.intBorrowerID DESC;
    `;
  }

  const result = await request.query(queryText);
  const rows = result.recordset || [];
  const aliasMap = await loadAliasesForBorrowers(pool, rows.map(r => r.intBorrowerID));

  const entries = rows.map(row => ({
    id: row.intBorrowerID ?? null,
    firstName: row.strFirstName || null,
    lastName: row.strLastName || null,
    name: formatName(row.strFirstName, row.strLastName),
    schoolId: row.strSchoolIDNumber || null,
    phone: row.strPhoneNumber || null,
    room: row.strRoomNumber || null,
    instructor: row.strInstructor || null,
    department: row.strDepartmentName || null,
    createdUtc: toIso(row.dtmCreated),
    aliases: aliasMap.get(row.intBorrowerID) || []
  }));

  res.json({ entries });
}));

app.get('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(borrowerId)){
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const detailResult = await pool.request()
    .input('BorrowerID', sql.Int, borrowerId)
    .query(`
      SELECT b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             b.strPhoneNumber,
             b.strRoomNumber,
             b.strInstructor,
             b.dtmCreated,
             d.strDepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = b.intDepartmentID
      WHERE b.intBorrowerID = @BorrowerID;
    `);

  const row = detailResult.recordset?.[0] || null;
  if(!row){
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  const aliasResult = await pool.request()
    .input('BorrowerID', sql.Int, borrowerId)
    .query(`
      SELECT intBorrowerAliasID, strAlias, dtmCreated
      FROM dbo.TBorrowerAliases
      WHERE intBorrowerID = @BorrowerID
      ORDER BY strAlias;
    `);

  const aliases = aliasResult.recordset?.map(mapAliasRow) || [];

  res.json({
    id: row.intBorrowerID ?? null,
    firstName: row.strFirstName || null,
    lastName: row.strLastName || null,
    name: formatName(row.strFirstName, row.strLastName),
    schoolId: row.strSchoolIDNumber || null,
    phone: row.strPhoneNumber || null,
    room: row.strRoomNumber || null,
    instructor: row.strInstructor || null,
    department: row.strDepartmentName || null,
    createdUtc: toIso(row.dtmCreated),
    aliases
  });
}));

app.post('/api/customers/:id/aliases', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(borrowerId)){
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const aliasInput = normalizeString(req.body?.alias || req.body?.name);
  if(!aliasInput){
    return res.status(400).json({ error: 'Alias is required.' });
  }
  if(aliasInput.length > 120){
    return res.status(400).json({ error: 'Alias must be 120 characters or fewer.' });
  }

  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const borrowerCheck = await pool.request()
    .input('BorrowerID', sql.Int, borrowerId)
    .query(`
      SELECT intBorrowerID
      FROM dbo.TBorrowers
      WHERE intBorrowerID = @BorrowerID;
    `);
  if(!borrowerCheck.recordset?.length){
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  try {
    const insert = await pool.request()
      .input('BorrowerID', sql.Int, borrowerId)
      .input('Alias', sql.NVarChar(120), aliasInput)
      .query(`
        INSERT dbo.TBorrowerAliases(intBorrowerID, strAlias)
        VALUES (@BorrowerID, @Alias);
        SELECT intBorrowerAliasID, strAlias, dtmCreated
        FROM dbo.TBorrowerAliases
        WHERE intBorrowerAliasID = SCOPE_IDENTITY();
      `);
    const aliasRow = insert.recordset?.[0] || null;
    const payload = aliasRow ? mapAliasRow(aliasRow) : { id: null, alias: aliasInput, createdUtc: null };
    res.status(201).json(payload);
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'Alias already exists for this customer.' });
    }
    throw err;
  }
}));

app.delete('/api/customers/:id/aliases/:aliasId', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  const aliasId = Number.parseInt(req.params.aliasId, 10);
  if(!Number.isFinite(borrowerId) || !Number.isFinite(aliasId)){
    return res.status(400).json({ error: 'Invalid identifier.' });
  }

  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const result = await pool.request()
    .input('BorrowerID', sql.Int, borrowerId)
    .input('AliasId', sql.Int, aliasId)
    .query(`
      DELETE FROM dbo.TBorrowerAliases
      WHERE intBorrowerAliasID = @AliasId AND intBorrowerID = @BorrowerID;
      SELECT @@ROWCOUNT AS deleted;
    `);

  const deleted = result.recordset?.[0]?.deleted ?? 0;
  if(!deleted){
    return res.status(404).json({ error: 'Alias not found.' });
  }

  res.json({ success: true });
}));

app.delete('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(borrowerId)){
    return res.status(400).json({ error: 'Invalid customer id.' });
  }

  const pool = await getPool();
  await ensureBorrowerAliasTable(pool);

  const exists = await pool.request()
    .input('BorrowerId', sql.Int, borrowerId)
    .query(`
      SELECT intBorrowerID
      FROM dbo.TBorrowers
      WHERE intBorrowerID = @BorrowerId;
    `);

  if(!exists.recordset?.length){
    return res.status(404).json({ error: 'Customer not found.' });
  }

  const dependency = await pool.request()
    .input('BorrowerId', sql.Int, borrowerId)
    .query(`
      SELECT
        (SELECT COUNT(*) FROM dbo.TItemLoans WHERE intBorrowerID = @BorrowerId) AS LoanCount,
        (SELECT COUNT(*) FROM dbo.TServiceTickets WHERE intBorrowerID = @BorrowerId) AS TicketCount;
    `);

  const depRow = dependency.recordset?.[0] || {};
  const hasLoans = (depRow.LoanCount ?? 0) > 0;
  const hasTickets = (depRow.TicketCount ?? 0) > 0;
  if(hasLoans || hasTickets){
    return res.status(409).json({ error: 'Cannot delete customer with existing loan or service history.' });
  }

  const result = await pool.request()
    .input('BorrowerId', sql.Int, borrowerId)
    .query(`
      DELETE FROM dbo.TBorrowerAliases WHERE intBorrowerID = @BorrowerId;
      DELETE FROM dbo.TBorrowers WHERE intBorrowerID = @BorrowerId;
      SELECT @@ROWCOUNT AS deleted;
    `);

  const deleted = result.recordset?.[0]?.deleted ?? 0;
  if(!deleted){
    return res.status(404).json({ error: 'Customer not found.' });
  }

  res.json({ success: true });
}));

app.post('/api/customers', asyncHandler(async (req, res) => {
  const { first, last, schoolId, phone, room, instructor } = req.body || {};
  const firstName = normalizeString(first);
  const lastName = normalizeString(last);
  if(!firstName || !lastName){
    return res.status(400).json({ error: 'First and last name are required.' });
  }

  const pool = await getPool();

  try {
    const request = pool.request();
    request.input('strFirstName', sql.VarChar(50), firstName);
    request.input('strLastName', sql.VarChar(50), lastName);
    request.input('strSchoolIDNumber', sql.VarChar(50), normalizeString(schoolId) || null);
    request.input('strPhoneNumber', sql.VarChar(25), normalizeString(phone) || null);
    request.input('strRoomNumber', sql.VarChar(25), normalizeString(room) || null);
    request.input('strInstructor', sql.VarChar(100), normalizeString(instructor) || null);
    const result = await request.execute('dbo.usp_CreateBorrower');
    const borrowerId = result.recordset?.[0]?.intBorrowerID ?? null;
    res.status(201).json({ id: borrowerId });
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'A borrower with that school ID already exists.' });
    }
    throw err;
  }
}));

app.get('/api/items', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const request = pool.request();
  const search = normalizeString(req.query.search || req.query.q || req.query.query);
  if(search){
    request.input('Search', sql.NVarChar(130), `%${search}%`);
  }
  const result = await request.query(`
    SELECT i.intItemID,
           i.strItemName,
           i.blnIsSchoolOwned,
           i.strDescription,
           i.strDuePolicy,
           i.intDueDaysOffset,
           i.intDueHoursOffset,
           i.tDueTime,
           i.dtmFixedDueLocal,
           i.dtmCreated,
           d.strDepartmentName
    FROM dbo.TItems AS i
    LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = i.intDepartmentID
    ${search ? `WHERE i.strItemName LIKE @Search OR ISNULL(d.strDepartmentName,'') LIKE @Search` : ''}
    ORDER BY i.strItemName ASC, i.intItemID ASC;
  `);
  const rows = result.recordset || [];
  const entries = rows.map(mapItemRow).filter(Boolean);
  res.json({ entries });
}));

app.get('/api/items/due-preview', asyncHandler(async (req, res) => {
  const raw = req.query.item || req.query.q || '';
  const itemQuery = normalizeString(raw);
  if(!itemQuery){
    return res.json({ message: 'Provide an item to preview.' });
  }

  const pool = await getPool();
  const itemId = await findItemId(pool, itemQuery);
  if(!itemId){
    return res.json({ message: 'Item not found.' });
  }

  const dueInfo = await resolveItemDue(pool, itemId);
  if(!dueInfo){
    return res.json({ message: 'No due policy configured for this item.', itemId });
  }

  res.json({
    itemId,
    itemName: dueInfo.itemName || null,
    dueUtc: dueInfo.dueUtc,
    policy: dueInfo.policy,
    policyDescription: dueInfo.description
  });
}));

app.post('/api/loans/checkout', asyncHandler(async (req, res) => {
  const { item, notes } = req.body || {};
  if(!item){
    return res.status(400).json({ error: 'Item is required.' });
  }

  const pool = await getPool();
  const borrowerId = await findBorrowerId(pool, req.body || {});
  if(!borrowerId){
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  const itemId = await findItemId(pool, item);
  if(!itemId){
    return res.status(404).json({ error: 'Item not found.' });
  }

  const dueInfo = await resolveItemDue(pool, itemId);
  const dueDate = dueInfo?.dueUtc ? new Date(dueInfo.dueUtc) : null;

  const userId = await resolveLabTechIdForLoans(pool, req.user);

  const request = pool.request();
  request.input('intItemID', sql.Int, itemId);
  request.input('intBorrowerID', sql.Int, borrowerId);
  request.input('intCheckoutLabTechID', sql.Int, userId);
  request.input('dtmDueUTC', sql.DateTime2, dueDate);
  request.input('strCheckoutNotes', sql.VarChar(400), normalizeString(notes) || null);

  const result = await request.execute('dbo.usp_CheckoutItem');
  const loanId = result.recordset?.[0]?.intItemLoanID ?? null;
  const traceNumber = typeof loanId === 'number' ? loanId.toString().padStart(6, '0') : null;
  res.status(201).json({
    loanId,
    traceNumber,
    dueUtc: dueInfo?.dueUtc ?? null,
    dueDescription: dueInfo?.description ?? null,
    duePolicy: dueInfo?.policy ?? null
  });
}));

app.post('/api/tickets', asyncHandler(async (req, res) => {
  const { item, issue } = req.body || {};
  const issueText = normalizeString(issue);
  if(!item || !issueText){
    return res.status(400).json({ error: 'Item and issue are required.' });
  }

  const pool = await getPool();
  const borrowerId = await findBorrowerId(pool, req.body || {});
  const itemId = await findItemId(pool, item);
  const ticketLabel = itemId ? null : normalizeString(item);

  const publicId = await generatePublicTicketId(pool);
  const userId = await resolveLabTechIdForLoans(pool, req.user);

  const request = pool.request();
  request.input('strPublicTicketID', sql.VarChar(20), publicId);
  request.input('intBorrowerID', sql.Int, borrowerId ?? null);
  request.input('intItemID', sql.Int, itemId ?? null);
  request.input('strItemLabel', sql.VarChar(120), ticketLabel);
  request.input('strIssue', sql.VarChar(1000), issueText);
  request.input('intAssignedLabTechID', sql.Int, userId);

  const result = await request.execute('dbo.usp_ServiceTicketCreate');
  const ticketId = result.recordset?.[0]?.intServiceTicketID ?? null;
  res.status(201).json({ ticketId, publicId });
}));

app.post('/api/items', asyncHandler(async (req, res) => {
  const { name, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue } = req.body || {};
  const itemName = normalizeString(name);
  if(!itemName){
    return res.status(400).json({ error: 'Item name is required.' });
  }

  const policy = (normalizeString(duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  const pool = await getPool();
  const departmentId = await ensureDepartment(pool, department);

  const days = toIntOrNull(offsetDays);
  const hours = toIntOrNull(offsetHours);
  const timeSql = normalizeTimeForSql(dueTime);
  const fixedDueDate = parseLocalDateTime(fixedDue);

  try {
    const request = pool.request();
    request.input('strItemName', sql.VarChar(120), itemName);
    request.input('blnIsSchoolOwned', sql.Bit, schoolOwned === false ? 0 : 1);
    request.input('intDepartmentID', sql.Int, departmentId ?? null);
    request.input('strDescription', sql.VarChar(400), normalizeString(description) || null);
    request.input('strDuePolicy', sql.VarChar(30), policy);
    request.input('intDueDaysOffset', sql.Int, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null);
    request.input('intDueHoursOffset', sql.Int, policy === 'OFFSET' ? hours : null);
    request.input('tDueTime', sql.Time, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null);
    request.input('dtmFixedDueLocal', sql.DateTime2, (policy === 'SEMESTER' || policy === 'FIXED') ? fixedDueDate : null);
    const result = await request.execute('dbo.usp_CreateItem');
    const itemId = result.recordset?.[0]?.intItemID ?? null;
    res.status(201).json({ itemId });
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'An item with that name already exists.' });
    }
    throw err;
  }
}));

app.get('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const pool = await getPool();
  const row = await loadItemRow(pool, itemId);
  if(!row){
    return res.status(404).json({ error: 'Item not found.' });
  }

  res.json(mapItemRow(row));
}));

app.put('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const {
    name,
    department,
    schoolOwned,
    description,
    duePolicy,
    offsetDays,
    offsetHours,
    dueTime,
    fixedDue
  } = req.body || {};

  const itemName = normalizeString(name);
  if(!itemName){
    return res.status(400).json({ error: 'Item name is required.' });
  }

  const policy = (normalizeString(duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  const pool = await getPool();

  const existing = await loadItemRow(pool, itemId);
  if(!existing){
    return res.status(404).json({ error: 'Item not found.' });
  }

  const departmentId = await ensureDepartment(pool, department);
  const days = toIntOrNull(offsetDays);
  const hours = toIntOrNull(offsetHours);
  const timeSql = normalizeTimeForSql(dueTime);
  const fixedDueDate = parseLocalDateTime(fixedDue);

  try {
    const request = pool.request();
    request.input('ItemID', sql.Int, itemId);
    request.input('strItemName', sql.VarChar(120), itemName);
    request.input('blnIsSchoolOwned', sql.Bit, schoolOwned === false ? 0 : 1);
    request.input('intDepartmentID', sql.Int, departmentId ?? null);
    request.input('strDescription', sql.VarChar(400), normalizeString(description) || null);
    request.input('strDuePolicy', sql.VarChar(30), policy);
    request.input('intDueDaysOffset', sql.Int, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null);
    request.input('intDueHoursOffset', sql.Int, policy === 'OFFSET' ? hours : null);
    request.input('tDueTime', sql.Time, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null);
    request.input('dtmFixedDueLocal', sql.DateTime2, (policy === 'SEMESTER' || policy === 'FIXED') ? fixedDueDate : null);
    await request.query(`
      UPDATE dbo.TItems
      SET strItemName = @strItemName,
          blnIsSchoolOwned = @blnIsSchoolOwned,
          intDepartmentID = @intDepartmentID,
          strDescription = @strDescription,
          strDuePolicy = @strDuePolicy,
          intDueDaysOffset = @intDueDaysOffset,
          intDueHoursOffset = @intDueHoursOffset,
          tDueTime = @tDueTime,
          dtmFixedDueLocal = @dtmFixedDueLocal
      WHERE intItemID = @ItemID;
    `);
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'An item with that name already exists.' });
    }
    throw err;
  }

  const updated = await loadItemRow(pool, itemId);
  res.json(mapItemRow(updated));
}));

app.delete('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const pool = await getPool();

  try {
    const result = await pool.request()
      .input('ItemID', sql.Int, itemId)
      .query(`
        DELETE FROM dbo.TItems WHERE intItemID = @ItemID;
        SELECT @@ROWCOUNT AS deleted;
      `);
    const deleted = result.recordset?.[0]?.deleted ?? 0;
    if(!deleted){
      return res.status(404).json({ error: 'Item not found.' });
    }
  } catch(err){
    if(err && err.number === 547){
      return res.status(409).json({ error: 'Cannot delete item that is referenced by loans or tickets.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

app.get('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const pool = await getPool();
  const row = await loadItemRow(pool, itemId);
  if(!row){
    return res.status(404).json({ error: 'Item not found.' });
  }

  res.json(mapItemRow(row));
}));

app.put('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const {
    name,
    department,
    schoolOwned,
    description,
    duePolicy,
    offsetDays,
    offsetHours,
    dueTime,
    fixedDue
  } = req.body || {};

  const itemName = normalizeString(name);
  if(!itemName){
    return res.status(400).json({ error: 'Item name is required.' });
  }

  const policy = (normalizeString(duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  const pool = await getPool();

  const existing = await loadItemRow(pool, itemId);
  if(!existing){
    return res.status(404).json({ error: 'Item not found.' });
  }

  const departmentId = await ensureDepartment(pool, department);
  const days = toIntOrNull(offsetDays);
  const hours = toIntOrNull(offsetHours);
  const timeSql = normalizeTimeForSql(dueTime);
  const fixedDueDate = parseLocalDateTime(fixedDue);

  try {
    const request = pool.request();
    request.input('ItemID', sql.Int, itemId);
    request.input('strItemName', sql.VarChar(120), itemName);
    request.input('blnIsSchoolOwned', sql.Bit, schoolOwned === false ? 0 : 1);
    request.input('intDepartmentID', sql.Int, departmentId ?? null);
    request.input('strDescription', sql.VarChar(400), normalizeString(description) || null);
    request.input('strDuePolicy', sql.VarChar(30), policy);
    request.input('intDueDaysOffset', sql.Int, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null);
    request.input('intDueHoursOffset', sql.Int, policy === 'OFFSET' ? hours : null);
    request.input('tDueTime', sql.Time, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null);
    request.input('dtmFixedDueLocal', sql.DateTime2, (policy === 'SEMESTER' || policy === 'FIXED') ? fixedDueDate : null);
    await request.query(`
      UPDATE dbo.TItems
      SET strItemName = @strItemName,
          blnIsSchoolOwned = @blnIsSchoolOwned,
          intDepartmentID = @intDepartmentID,
          strDescription = @strDescription,
          strDuePolicy = @strDuePolicy,
          intDueDaysOffset = @intDueDaysOffset,
          intDueHoursOffset = @intDueHoursOffset,
          tDueTime = @tDueTime,
          dtmFixedDueLocal = @dtmFixedDueLocal,
          dtmUpdated = SYSUTCDATETIME()
      WHERE intItemID = @ItemID;
    `);
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'An item with that name already exists.' });
    }
    throw err;
  }

  const updated = await loadItemRow(pool, itemId);
  res.json(mapItemRow(updated));
}));

app.delete('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const pool = await getPool();

  try {
    const result = await pool.request()
      .input('ItemID', sql.Int, itemId)
      .query(`
        DELETE FROM dbo.TItems WHERE intItemID = @ItemID;
        SELECT @@ROWCOUNT AS deleted;
      `);
    const deleted = result.recordset?.[0]?.deleted ?? 0;
    if(!deleted){
      return res.status(404).json({ error: 'Item not found.' });
    }
  } catch(err){
    if(err && err.number === 547){
      return res.status(409).json({ error: 'Cannot delete item that is referenced by loans or tickets.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

const LOAN_STATUS_SET = new Set(['On Time', 'Overdue', 'Returned']);
const TICKET_STATUS_SET = new Set([
  'Diagnosing',
  'Awaiting Parts',
  'Ready for Pickup',
  'Quarantined',
  'Completed',
  'Cancelled'
]);

app.post('/api/status', asyncHandler(async (req, res) => {
  const { id, type, status, note } = req.body || {};
  const statusText = normalizeString(status);
  if(!id || !type || !statusText){
    return res.status(400).json({ error: 'id, type, and status are required.' });
  }

  const pool = await getPool();
  const userId = await resolveLabTechIdForLoans(pool, req.user);
  const trimmedNote = normalizeString(note) || null;

  if(type === 'Loan'){
    if(!LOAN_STATUS_SET.has(statusText)){
      return res.status(400).json({ error: `Unsupported loan status: ${statusText}` });
    }
    const loanId = Number.parseInt(id, 10);
    if(!Number.isFinite(loanId)){
      return res.status(400).json({ error: 'Invalid loan id.' });
    }

    const loanResult = await pool.request()
      .input('LoanID', sql.Int, loanId)
      .query(`
        SELECT intItemLoanID, dtmDueUTC, dtmCheckinUTC, strCheckoutNotes
        FROM dbo.TItemLoans
        WHERE intItemLoanID = @LoanID;
      `);
    if(!loanResult.recordset?.length){
      return res.status(404).json({ error: 'Loan not found.' });
    }
    const loan = loanResult.recordset[0];

    if(statusText === 'Returned'){
      const checkinReq = pool.request();
      checkinReq.input('intItemLoanID', sql.Int, loanId);
      checkinReq.input('intCheckinLabTechID', sql.Int, userId);
      checkinReq.input('strCheckinNotes', sql.VarChar(400), trimmedNote);
      await checkinReq.execute('dbo.usp_CheckinItem');
    } else {
      const now = new Date();
      let dueDate = loan.dtmDueUTC ? new Date(loan.dtmDueUTC) : null;
      if(statusText === 'Overdue'){
        if(!dueDate || dueDate > now){
          dueDate = new Date(now.getTime() - 60 * 60 * 1000);
        }
      } else if(statusText === 'On Time'){
        if(!dueDate || dueDate < now){
          dueDate = new Date(now.getTime() + 24 * 60 * 60 * 1000);
        }
      }
      if(dueDate){
        const updateReq = pool.request();
        updateReq.input('intItemLoanID', sql.Int, loanId);
        updateReq.input('dtmDueUTC', sql.DateTime2, dueDate);
        updateReq.input('strCheckoutNotes', sql.VarChar(400), loan.strCheckoutNotes || null);
        await updateReq.execute('dbo.usp_UpdateLoanDue');
      }
      if(trimmedNote){
        const noteReq = pool.request();
        noteReq.input('intItemLoanID', sql.Int, loanId);
        noteReq.input('intLabTechID', sql.Int, userId);
        noteReq.input('strNote', sql.VarChar(1000), trimmedNote);
        await noteReq.execute('dbo.usp_AddLoanNote');
      }
    }

    return res.json({ success: true });
  }

  if(type === 'Service Ticket'){
    if(!TICKET_STATUS_SET.has(statusText)){
      return res.status(400).json({ error: `Unsupported service ticket status: ${statusText}` });
    }
    const ticketId = await resolveServiceTicketId(pool, id);
    if(!ticketId){
      return res.status(404).json({ error: 'Service ticket not found.' });
    }

    const statusReq = pool.request();
    statusReq.input('intServiceTicketID', sql.Int, ticketId);
    statusReq.input('strStatus', sql.VarChar(30), statusText);
    statusReq.input('intLabTechID', sql.Int, userId);
    await statusReq.execute('dbo.usp_ServiceTicketSetStatus');

    if(trimmedNote){
      const noteReq = pool.request();
      noteReq.input('intServiceTicketID', sql.Int, ticketId);
      noteReq.input('intLabTechID', sql.Int, userId);
      noteReq.input('strNote', sql.VarChar(1000), trimmedNote);
      await noteReq.execute('dbo.usp_AddServiceTicketNote');
    }

    return res.json({ success: true });
  }

  return res.status(400).json({ error: `Unknown status type: ${type}` });
}));

app.get('/api/users', asyncHandler(async (req, res) => {
  const pool = await getPool();
  await ensureUserTable(pool);

  const search = normalizeString(req.query.search || req.query.q || req.query.query);
  const request = pool.request();
  if(search){
    request.input('Search', sql.VarChar(160), `%${search.toLowerCase()}%`);
  }

  const result = await request.query(`
    SELECT intLabTechID, strUsername, strDisplayName, strRole, dtmCreated
    FROM dbo.TLabTechs
    ${search ? `WHERE LOWER(strUsername) LIKE @Search OR LOWER(strDisplayName) LIKE @Search OR LOWER(strRole) LIKE @Search OR LOWER(strFirstName) LIKE @Search OR LOWER(strLastName) LIKE @Search` : ''}
    ORDER BY strUsername ASC;
  `);

  const entries = (result.recordset || []).map(mapUserRow).filter(Boolean);
  res.json({ entries });
}));

app.post('/api/users', asyncHandler(async (req, res) => {
  const { username, display, role, password } = req.body || {};
  const user = normalizeString(username).toLowerCase();
  const displayName = normalizeString(display);
  const roleName = normalizeUserRole(role);
  if(!user || !displayName || !roleName){
    return res.status(400).json({ error: 'Username, display, and a valid role are required.' });
  }

  const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
  if(!normalizedPassword){
    return res.status(400).json({ error: 'Password is required.' });
  }
  if(normalizedPassword.length < 8){
    return res.status(400).json({ error: 'Password must be at least 8 characters.' });
  }
  if(normalizedPassword.length > 255){
    return res.status(400).json({ error: 'Password must be 255 characters or fewer.' });
  }

  const cappedDisplayName = displayName.substring(0, 150);
  const parsedName = splitName(cappedDisplayName);
  const firstName = normalizeString(parsedName.first) || cappedDisplayName;
  const lastName = normalizeString(parsedName.last) || cappedDisplayName;
  const firstLimited = firstName.substring(0, 50);
  const lastLimited = lastName.substring(0, 50);

  const pool = await getPool();
  await ensureUserTable(pool);
  await ensureUserCredentialTable(pool);

  const transaction = new sql.Transaction(pool);
  await transaction.begin();

  try {
    const insertRequest = new sql.Request(transaction);
    insertRequest.input('Username', sql.VarChar(120), user);
    insertRequest.input('Display', sql.VarChar(150), cappedDisplayName);
    insertRequest.input('First', sql.VarChar(50), firstLimited);
    insertRequest.input('Last', sql.VarChar(50), lastLimited);
    insertRequest.input('Role', sql.VarChar(50), roleName);
    insertRequest.input('Password', sql.VarChar(255), normalizedPassword);
    const result = await insertRequest.query(`
      INSERT INTO dbo.TLabTechs(strUsername,strDisplayName,strFirstName,strLastName,strRole,strPassword)
      VALUES (@Username,@Display,@First,@Last,@Role,@Password);
      SELECT SCOPE_IDENTITY() AS newId;
    `);

    const newId = result.recordset?.[0]?.newId ?? null;
    if(!newId){
      throw new Error('Failed to determine created user id.');
    }

    const credentialRequest = new sql.Request(transaction);
    credentialRequest.input('UserId', sql.Int, newId);
    credentialRequest.input('Password', sql.VarChar(255), normalizedPassword);
    await credentialRequest.query(`
      INSERT INTO dbo.TLabTechCredentials(intLabTechID, strPasswordHash)
      VALUES (@UserId, HASHBYTES('SHA2_256', @Password));
    `);

    await transaction.commit();
  } catch(err){
    try {
      await transaction.rollback();
    } catch { /* ignore */ }
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'Username already exists.' });
    }
    throw err;
  }

  res.status(201).json({ username: user });
}));

app.put('/api/users/:username', asyncHandler(async (req, res) => {
  const username = normalizeString(req.params.username).toLowerCase();
  if(!username){
    return res.status(400).json({ error: 'Username required.' });
  }

  const { display, role, password } = req.body || {};
  const displayName = normalizeString(display);
  const roleName = normalizeUserRole(role);
  if(!displayName || !roleName){
    return res.status(400).json({ error: 'Display and a valid role are required.' });
  }

  const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
  if(normalizedPassword && normalizedPassword.length < 8){
    return res.status(400).json({ error: 'Password must be at least 8 characters.' });
  }

  if(normalizedPassword && normalizedPassword.length > 255){
    return res.status(400).json({ error: 'Password must be 255 characters or fewer.' });
  }

  const cappedDisplayName = displayName.substring(0, 150);
  const parsedName = splitName(cappedDisplayName);
  const firstName = normalizeString(parsedName.first) || cappedDisplayName;
  const lastName = normalizeString(parsedName.last) || cappedDisplayName;
  const firstLimited = firstName.substring(0, 50);
  const lastLimited = lastName.substring(0, 50);

  const pool = await getPool();
  await ensureUserTable(pool);

  if(normalizedPassword){
    await ensureUserCredentialTable(pool);
  }

  const transaction = new sql.Transaction(pool);
  await transaction.begin();

  try {
    const updateRequest = new sql.Request(transaction);
    updateRequest.input('Username', sql.VarChar(120), username);
    updateRequest.input('Display', sql.VarChar(150), cappedDisplayName);
    updateRequest.input('First', sql.VarChar(50), firstLimited);
    updateRequest.input('Last', sql.VarChar(50), lastLimited);
    updateRequest.input('Role', sql.VarChar(50), roleName);
    if(normalizedPassword){
      updateRequest.input('Password', sql.VarChar(255), normalizedPassword);
    }

    const passwordClause = normalizedPassword ? ",\n          strPassword = @Password" : '';

    const updateSql = `
      UPDATE dbo.TLabTechs
      SET strDisplayName = @Display,
          strFirstName = @First,
          strLastName = @Last,
          strRole = @Role${passwordClause}
      WHERE strUsername = @Username;
      SELECT @@ROWCOUNT AS updated;
    `;

    const result = await updateRequest.query(updateSql);
    const updated = result.recordset?.[0]?.updated ?? 0;
    if(!updated){
      await transaction.rollback();
      return res.status(404).json({ error: 'User not found.' });
    }

    if(normalizedPassword){
      const credentialRequest = new sql.Request(transaction);
      credentialRequest.input('Username', sql.VarChar(120), username);
      credentialRequest.input('Password', sql.VarChar(255), normalizedPassword);
      await credentialRequest.query(`
        DECLARE @UserId INT;
        SELECT @UserId = intLabTechID
        FROM dbo.TLabTechs
        WHERE strUsername = @Username;

        IF @UserId IS NOT NULL
        BEGIN
          MERGE dbo.TLabTechCredentials AS target
          USING (SELECT @UserId AS intLabTechID) AS src
          ON target.intLabTechID = src.intLabTechID
          WHEN MATCHED THEN
            UPDATE SET strPasswordHash = HASHBYTES('SHA2_256', @Password), dtmUpdated = SYSUTCDATETIME()
          WHEN NOT MATCHED THEN
            INSERT (intLabTechID, strPasswordHash)
            VALUES (src.intLabTechID, HASHBYTES('SHA2_256', @Password));
        END;
      `);
    }

    await transaction.commit();
  } catch(err){
    try {
      await transaction.rollback();
    } catch { /* ignore */ }
    throw err;
  }

  const detail = await pool.request()
    .input('Username', sql.VarChar(120), username)
    .query(`
      SELECT intLabTechID, strUsername, strDisplayName, strRole, dtmCreated
      FROM dbo.TLabTechs
      WHERE strUsername = @Username;
    `);

  const mapped = mapUserRow(detail.recordset?.[0] || null);
  if(mapped){
    updateSessionsForUser(mapped);
  }
  res.json(mapped);
}));

app.delete('/api/users/:username', asyncHandler(async (req, res) => {
  const username = normalizeString(req.params.username).toLowerCase();
  if(!username){
    return res.status(400).json({ error: 'Username required.' });
  }

  const pool = await getPool();
  await ensureUserTable(pool);

  const lookup = await pool.request()
    .input('Username', sql.VarChar(120), username)
    .query(`
      SELECT intLabTechID
      FROM dbo.TLabTechs
      WHERE strUsername = @Username;
    `);

  const userId = lookup.recordset?.[0]?.intLabTechID ?? null;
  if(!userId){
    return res.status(404).json({ error: 'User not found.' });
  }

  const dependency = await pool.request()
    .input('UserId', sql.Int, userId)
    .query(`
      SELECT
        (SELECT COUNT(*) FROM dbo.TItemLoans WHERE intCheckoutLabTechID = @UserId OR intCheckinLabTechID = @UserId) AS LoanCount,
        (SELECT COUNT(*) FROM dbo.TItemLoanNotes WHERE intLabTechID = @UserId) AS LoanNoteCount,
        (SELECT COUNT(*) FROM dbo.TServiceTickets WHERE intAssignedLabTechID = @UserId) AS TicketCount,
        (SELECT COUNT(*) FROM dbo.TServiceTicketNotes WHERE intLabTechID = @UserId) AS TicketNoteCount,
        (SELECT COUNT(*) FROM dbo.TAuditLog WHERE intLabTechID = @UserId) AS AuditCount;
    `);

  const row = dependency.recordset?.[0] || {};
  const totalReferences =
    (row.LoanCount ?? 0) +
    (row.LoanNoteCount ?? 0) +
    (row.TicketCount ?? 0) +
    (row.TicketNoteCount ?? 0) +
    (row.AuditCount ?? 0);

  if(totalReferences > 0){
    return res.status(409).json({ error: 'Cannot delete user with historical activity. Clear related records first.' });
  }

  const result = await pool.request()
    .input('UserId', sql.Int, userId)
    .query(`
      DELETE FROM dbo.TLabTechs WHERE intLabTechID = @UserId;
      SELECT @@ROWCOUNT AS deleted;
    `);

  const deleted = result.recordset?.[0]?.deleted ?? 0;
  if(!deleted){
    return res.status(404).json({ error: 'User not found.' });
  }

  invalidateSessionsForUser(userId);

  res.json({ success: true });
}));

app.delete('/api/admin/audit-log', asyncHandler(async (req, res) => {
  const pool = await getPool();
  await pool.request().query(`
    IF OBJECT_ID('dbo.TAuditLog','U') IS NOT NULL
      DELETE FROM dbo.TAuditLog;
  `);
  res.json({ success: true });
}));

app.post('/api/admin/clear-database', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const transaction = new sql.Transaction(pool);
  await transaction.begin();
  try {
    const adminLookup = new sql.Request(transaction);
    const adminResult = await adminLookup.query(`
      IF OBJECT_ID('dbo.TLabTechs','U') IS NOT NULL
        SELECT TOP (1) intLabTechID
        FROM dbo.TLabTechs
        WHERE strRole = 'admin'
        ORDER BY intLabTechID;
      ELSE
        SELECT CAST(NULL AS INT) AS intLabTechID;
    `);
    const adminId = adminResult.recordset?.[0]?.intLabTechID ?? null;

    const request = new sql.Request(transaction);
    if(adminId != null){
      request.input('AdminId', sql.Int, adminId);
    }

    const statements = [
      "IF OBJECT_ID('dbo.TItemLoanNotes','U') IS NOT NULL DELETE FROM dbo.TItemLoanNotes;",
      "IF OBJECT_ID('dbo.TItemLoans','U') IS NOT NULL DELETE FROM dbo.TItemLoans;",
      "IF OBJECT_ID('dbo.TServiceTicketNotes','U') IS NOT NULL DELETE FROM dbo.TServiceTicketNotes;",
      "IF OBJECT_ID('dbo.TServiceTickets','U') IS NOT NULL DELETE FROM dbo.TServiceTickets;",
      "IF OBJECT_ID('dbo.TBorrowerAliases','U') IS NOT NULL DELETE FROM dbo.TBorrowerAliases;",
      "IF OBJECT_ID('dbo.TBorrowers','U') IS NOT NULL DELETE FROM dbo.TBorrowers;",
      "IF OBJECT_ID('dbo.TItems','U') IS NOT NULL DELETE FROM dbo.TItems;",
      adminId != null
        ? "IF OBJECT_ID('dbo.TLabTechs','U') IS NOT NULL DELETE FROM dbo.TLabTechs WHERE intLabTechID <> @AdminId;"
        : "IF OBJECT_ID('dbo.TLabTechs','U') IS NOT NULL DELETE FROM dbo.TLabTechs;",
      "IF OBJECT_ID('dbo.TAuditLog','U') IS NOT NULL DELETE FROM dbo.TAuditLog;",
      "IF OBJECT_ID('dbo.TDepartments','U') IS NOT NULL DELETE FROM dbo.TDepartments;"
    ].join('\n');

    await request.batch(statements);
    await transaction.commit();
  } catch(err){
    await transaction.rollback().catch(() => {});
    throw err;
  }

  cachedDefaultUserId = null;
  res.json({ success: true });
}));

const staticDir = path.join(__dirname);
app.use(express.static(staticDir));
app.get('/', (req, res) => {
  res.sendFile(path.join(staticDir, 'LabCenterIMS.html'));
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal Server Error', detail: err.message });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Lab Center IMS API listening on http://localhost:${PORT}`);
});

async function shutdown(){
  if(pool){
    try { await pool.close(); } catch { /* ignore */ }
  }
  process.exit(0);
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
