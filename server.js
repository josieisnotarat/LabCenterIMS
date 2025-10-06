const path = require('path');
const express = require('express');
const sql = require('mssql');

const app = express();
app.use(express.json());

const dbConfig = {
  user: 'sa1',
  password: '',
  server: 'localhost',
  database: 'dbLabCenter',
  port: 1433,
  options: {
    encrypt: false,
    trustServerCertificate: true
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

let pool;
let cachedLabTechId = null;

async function getPool(){
  if(pool && pool.connected){
    return pool;
  }
  if(pool){
    try { await pool.close(); } catch { /* ignore */ }
  }
  pool = await new sql.ConnectionPool(dbConfig).connect();
  cachedLabTechId = null;
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
    id: row.BorrowerAliasID ?? null,
    alias: row.Alias || '',
    createdUtc: toIso(row.CreatedAt)
  };
}

function mapLoanRow(row){
  const traceNumber = row.ItemLoanID != null
    ? row.ItemLoanID.toString().padStart(6, '0')
    : null;
  return {
    id: row.ItemLoanID ?? null,
    traceNumber,
    itemId: row.ItemID ?? null,
    borrowerId: row.BorrowerID ?? null,
    itemName: row.SnapshotItemName || null,
    itemNumber: row.SnapshotItemNumber || null,
    borrowerName: formatName(row.SnapshotBorrowerFirstName, row.SnapshotBorrowerLastName),
    borrowerSchoolId: row.SnapshotSchoolIdNumber || null,
    room: row.SnapshotRoomNumber || null,
    checkoutUtc: toIso(row.CheckoutUtc),
    dueUtc: toIso(row.DueUtc),
    checkinUtc: toIso(row.CheckinUtc),
    status: row.LoanStatus || null
  };
}

function mapTicketRow(row){
  const assignedName = formatName(row.AssignedFirstName, row.AssignedLastName);
  return {
    id: row.ServiceTicketID ?? null,
    publicId: row.PublicTicketID || null,
    itemId: row.ItemID ?? null,
    borrowerId: row.BorrowerID ?? null,
    itemName: row.ItemName || row.ItemLabel || null,
    issue: row.Issue || null,
    loggedUtc: toIso(row.LoggedUtc),
    assignedName,
    borrowerName: formatName(row.BorrowerFirstName, row.BorrowerLastName),
    status: row.Status || null,
    loggedByName: assignedName
  };
}

function mapItemRow(row){
  return {
    id: row.intItemID ?? null,
    name: row.strItemName || null,
    itemNumber: row.strItemNumber || null,
    schoolOwned: row.blnIsSchoolOwned === false ? false : true,
    description: row.strDescription || null,
    duePolicy: (row.strDuePolicy || '').toUpperCase(),
    offsetDays: row.intDueDaysOffset ?? null,
    offsetHours: row.intDueHoursOffset ?? null,
    dueTime: formatSqlTime(row.tDueTime),
    fixedDue: toIso(row.dtmFixedDueLocal),
    isActive: row.blnIsActive === false ? false : true,
    department: row.strDepartmentName || null,
    createdUtc: toIso(row.dtmCreated)
  };
}

function mapUserRow(row){
  return {
    username: row.strUsername || row.username || null,
    display: row.strDisplayName || row.display || null,
    role: row.strRole || row.role || null,
    createdUtc: toIso(row.dtmCreated)
  };
}

app.get('/api/dashboard-stats', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const result = await pool.request().execute('dbo.spGetDashboardStats');
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
  const result = await request.execute('dbo.spGetRecentLoans');
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
  const result = await request.execute('dbo.spGetServiceTickets');
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
  const result = await primaryRequest.execute('dbo.spSearchBorrowers');
  const rows = result.recordset || [];

  const entries = [];
  const seen = new Set();

  const appendRow = (row, aliasMatch = null) => {
    const rawId = row.BorrowerID ?? row.id ?? row.borrowerId ?? row.BorrowerId;
    const parsedId = Number.parseInt(rawId, 10);
    if(!Number.isFinite(parsedId) || seen.has(parsedId)){
      return;
    }
    seen.add(parsedId);
    const first = row.FirstName || row.firstName;
    const last = row.LastName || row.lastName;
    const alias = aliasMatch || row.MatchedAlias || row.matchedAlias || row.Alias || row.alias || null;
    const displayName = formatName(first, last) || alias || `Customer #${parsedId}`;
    entries.push({
      id: parsedId,
      name: displayName,
      schoolId: row.SchoolIdNumber || row.schoolId || null,
      alias: alias || null
    });
  };

  rows.forEach(row => appendRow(row));

  const aliasRequest = pool.request();
  aliasRequest.input('Top', sql.Int, limit);
  aliasRequest.input('Search', sql.NVarChar(130), `%${query}%`);
  const aliasResult = await aliasRequest.query(`
    SELECT TOP (@Top)
           b.BorrowerID,
           b.FirstName,
           b.LastName,
           b.SchoolIdNumber,
           a.Alias,
           a.BorrowerAliasID
    FROM dbo.TBorrowers AS b
    INNER JOIN dbo.TBorrowerAliases AS a ON a.BorrowerID = b.BorrowerID
    WHERE a.Alias LIKE @Search
    ORDER BY a.BorrowerAliasID DESC;
  `);
  aliasResult.recordset?.forEach(row => appendRow(row, row.Alias));

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
      SELECT n.ItemLoanNoteID, n.NoteUtc, n.Note,
             lt.FirstName, lt.LastName
      FROM dbo.TItemLoanNotes AS n
      LEFT JOIN dbo.TLabTechs AS lt ON lt.LabTechID = n.LabTechID
      WHERE n.ItemLoanID = @LoanID
      ORDER BY n.NoteUtc DESC;
    `);

  const entries = result.recordset?.map(row => ({
    id: row.ItemLoanNoteID ?? null,
    note: row.Note || '',
    timestamp: toIso(row.NoteUtc),
    author: formatName(row.FirstName, row.LastName)
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
      SELECT n.ServiceTicketNoteID, n.NoteUtc, n.Note,
             lt.FirstName, lt.LastName
      FROM dbo.TServiceTicketNotes AS n
      LEFT JOIN dbo.TLabTechs AS lt ON lt.LabTechID = n.LabTechID
      WHERE n.ServiceTicketID = @TicketId
      ORDER BY n.NoteUtc DESC;
    `);

  const entries = result.recordset?.map(row => ({
    id: row.ServiceTicketNoteID ?? null,
    note: row.Note || '',
    timestamp: toIso(row.NoteUtc),
    author: formatName(row.FirstName, row.LastName)
  })) || [];

  res.json({ entries });
}));

app.get('/api/audit-log', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const top = Number.parseInt(req.query.top || '50', 10);
  const request = pool.request();
  request.input('Top', sql.Int, Number.isFinite(top) ? top : 50);
  const result = await request.execute('dbo.spGetAuditLog');
  const entries = result.recordset?.map(row => ({
    TraceID: row.TraceID,
    EventUtc: toIso(row.EventUtc),
    LabTechID: row.LabTechID ?? null,
    FirstName: row.FirstName || null,
    LastName: row.LastName || null,
    Action: row.Action || null,
    Entity: row.Entity || null,
    EntityPrimaryKey: row.EntityPrimaryKey ?? null,
    Details: row.Details || null
  })) || [];
  res.json({ entries });
}));

function normalizeString(value){
  if(typeof value !== 'string') return '';
  return value.trim();
}

function toIntOrNull(value){
  if(value == null || value === '') return null;
  const n = Number.parseInt(value, 10);
  return Number.isFinite(n) ? n : null;
}

function parseQueryBoolean(value){
  if(value == null) return null;
  if(typeof value === 'boolean') return value;
  if(typeof value === 'number'){
    return value !== 0;
  }
  if(typeof value === 'string'){
    const normalized = value.trim().toLowerCase();
    if(!normalized) return null;
    if(['1','true','yes','y'].includes(normalized)) return true;
    if(['0','false','no','n'].includes(normalized)) return false;
  }
  return null;
}

function toNullableBit(value){
  if(value == null) return null;
  if(typeof value === 'boolean') return value ? 1 : 0;
  if(typeof value === 'number') return value !== 0 ? 1 : 0;
  if(typeof value === 'string'){
    const normalized = value.trim().toLowerCase();
    if(['1','true','yes','y'].includes(normalized)) return 1;
    if(['0','false','no','n'].includes(normalized)) return 0;
  }
  return null;
}

function toTimeParts(value){
  if(!value) return null;
  if(typeof value === 'string'){
    const trimmed = value.trim();
    const match = trimmed.match(/^(\d{1,2})(?::(\d{1,2}))?(?::(\d{1,2}))?$/);
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
  if(typeof value === 'string'){
    return value.length >= 5 ? value.slice(0,5) : value;
  }
  const parts = toTimeParts(value);
  if(!parts) return null;
  return `${parts.hour.toString().padStart(2,'0')}:${parts.minute.toString().padStart(2,'0')}`;
}

async function getItemDueSettings(pool, itemId){
  const result = await pool.request()
    .input('ItemID', sql.Int, itemId)
    .query(`
      SELECT ItemID, ItemName, ItemNumber, DuePolicy,
             DueDaysOffset, DueHoursOffset, DueTime, FixedDueLocal
      FROM dbo.TItems
      WHERE ItemID = @ItemID;
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
  const policy = (row.DuePolicy || 'NEXT_DAY_6PM').toUpperCase();
  const now = new Date();
  let due = null;
  let description = '';

  if(policy === 'SEMESTER' || policy === 'FIXED'){
    if(row.FixedDueLocal){
      const fixed = new Date(row.FixedDueLocal);
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
    const days = Number.isInteger(row.DueDaysOffset) ? row.DueDaysOffset : (policy === 'NEXT_DAY_6PM' ? 1 : 0);
    const hours = Number.isInteger(row.DueHoursOffset) ? row.DueHoursOffset : 0;
    const timeParts = toTimeParts(row.DueTime);
    due = new Date(now.getTime());
    if(days) due.setDate(due.getDate() + days);
    if(timeParts){
      due.setHours(timeParts.hour, timeParts.minute, timeParts.second, 0);
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
    itemName: row.ItemName || null,
    itemNumber: row.ItemNumber || null
  };
}

async function resolveItemDue(pool, itemId){
  const settings = await getItemDueSettings(pool, itemId);
  if(!settings) return null;
  return computeDueFromPolicy(settings);
}

async function resolveServiceTicketId(pool, identifier){
  const numericId = Number.parseInt(identifier, 10);
  const request = pool.request();
  request.input('TicketId', sql.Int, Number.isFinite(numericId) ? numericId : null);
  request.input('PublicId', sql.VarChar(20), normalizeString(identifier) || null);
  const result = await request.query(`
    SELECT TOP (1) ServiceTicketID
    FROM dbo.TServiceTickets
    WHERE (@TicketId IS NOT NULL AND ServiceTicketID = @TicketId)
       OR (PublicTicketID = @PublicId)
    ORDER BY ServiceTicketID DESC;
  `);
  return result.recordset?.[0]?.ServiceTicketID ?? null;
}

async function ensureDepartment(pool, name){
  const deptName = normalizeString(name);
  if(!deptName) return null;

  const lookup = await pool.request()
    .input('Name', sql.VarChar(100), deptName)
    .query(`
      SELECT DepartmentID
      FROM dbo.TDepartments
      WHERE LOWER(DepartmentName) = LOWER(@Name);
    `);
  if(lookup.recordset?.length){
    return lookup.recordset[0].DepartmentID;
  }

  try {
    const insert = await pool.request()
      .input('Name', sql.VarChar(100), deptName)
      .query(`
        INSERT dbo.TDepartments(DepartmentName)
        VALUES (@Name);
        SELECT SCOPE_IDENTITY() AS DepartmentID;
      `);
    return insert.recordset?.[0]?.DepartmentID ?? null;
  } catch(err){
    if(err && (err.number === 2601 || err.number === 2627)){
      const retry = await pool.request()
        .input('Name', sql.VarChar(100), deptName)
        .query(`
          SELECT DepartmentID
          FROM dbo.TDepartments
          WHERE LOWER(DepartmentName) = LOWER(@Name);
        `);
      if(retry.recordset?.length){
        return retry.recordset[0].DepartmentID;
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
        BorrowerAliasID INT IDENTITY(1,1) PRIMARY KEY,
        BorrowerID      INT NOT NULL REFERENCES dbo.TBorrowers(BorrowerID) ON DELETE CASCADE,
        Alias           NVARCHAR(120) NOT NULL,
        CreatedAt       DATETIME2(0) NOT NULL CONSTRAINT DF_TBorrowerAliases_Created DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_TBorrowerAliases UNIQUE (BorrowerID, Alias)
      );
      CREATE INDEX IX_TBorrowerAliases_Alias ON dbo.TBorrowerAliases(Alias);
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
    SELECT BorrowerAliasID, BorrowerID, Alias, CreatedAt
    FROM dbo.TBorrowerAliases
    WHERE BorrowerID IN (${params.join(',')})
    ORDER BY Alias;
  `);

  const map = new Map();
  const rows = result.recordset || [];
  rows.forEach(row => {
    const list = map.get(row.BorrowerID) || [];
    list.push(mapAliasRow(row));
    map.set(row.BorrowerID, list);
  });

  return map;
}

async function getDefaultLabTechId(pool){
  if(cachedLabTechId != null){
    return cachedLabTechId;
  }
  const result = await pool.request().query(`
    SELECT TOP (1) LabTechID
    FROM dbo.TLabTechs
    WHERE IsActive = 1
    ORDER BY LabTechID;
  `);
  const id = result.recordset?.[0]?.LabTechID;
  if(!id){
    throw new Error('No active lab tech available for checkout.');
  }
  cachedLabTechId = id;
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
        .query('SELECT BorrowerID FROM dbo.TBorrowers WHERE BorrowerID = @BorrowerID;');
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
        SELECT TOP (1) BorrowerID
        FROM dbo.TBorrowers
        WHERE SchoolIdNumber = @SchoolID
        ORDER BY BorrowerID DESC;
      `);
    if(res.recordset?.length){
      return res.recordset[0].BorrowerID;
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
          SELECT TOP (1) BorrowerID
          FROM dbo.TBorrowers
          WHERE FirstName = @First AND LastName = @Last
          ORDER BY BorrowerID DESC;
        `);
      if(res.recordset?.length){
        return res.recordset[0].BorrowerID;
      }
    }

    const aliasText = normalizeString(nameSource);
    if(aliasText){
      await ensureBorrowerAliasTable(pool);
      const aliasExact = await pool.request()
        .input('Alias', sql.NVarChar(120), aliasText)
        .query(`
          SELECT TOP (1) BorrowerID
          FROM dbo.TBorrowerAliases
          WHERE Alias = @Alias
          ORDER BY BorrowerAliasID DESC;
        `);
      if(aliasExact.recordset?.length){
        return aliasExact.recordset[0].BorrowerID;
      }

      const aliasLike = await pool.request()
        .input('AliasLike', sql.NVarChar(130), `%${aliasText}%`)
        .query(`
          SELECT TOP (1) BorrowerID
          FROM dbo.TBorrowerAliases
          WHERE Alias LIKE @AliasLike
          ORDER BY BorrowerAliasID DESC;
        `);
      if(aliasLike.recordset?.length){
        return aliasLike.recordset[0].BorrowerID;
      }
    }

    const fuzzy = normalizeString(nameSource);
    if(fuzzy){
      const res = await pool.request()
        .input('Search', sql.NVarChar(120), fuzzy)
        .query(`
          SELECT TOP (1) BorrowerID
          FROM dbo.TBorrowers
          WHERE FirstName LIKE N'%' + @Search + N'%' OR LastName LIKE N'%' + @Search + N'%' OR ISNULL(SchoolIdNumber,'') LIKE N'%' + @Search + N'%'
          ORDER BY BorrowerID DESC;
        `);
      if(res.recordset?.length){
        return res.recordset[0].BorrowerID;
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
      .query('SELECT ItemID FROM dbo.TItems WHERE ItemID = @ItemID;');
    if(byId.recordset?.length){
      return byId.recordset[0].ItemID;
    }
  }

  const exact = await pool.request()
    .input('Match', sql.VarChar(120), value)
    .query(`
      SELECT TOP (1) ItemID
      FROM dbo.TItems
      WHERE ItemNumber = @Match OR ItemName = @Match
      ORDER BY CASE WHEN ItemNumber = @Match THEN 0 ELSE 1 END, ItemID DESC;
    `);
  if(exact.recordset?.length){
    return exact.recordset[0].ItemID;
  }

  const like = await pool.request()
    .input('Search', sql.NVarChar(120), `%${value}%`)
    .query(`
      SELECT TOP (1) ItemID
      FROM dbo.TItems
      WHERE ItemName LIKE @Search OR ISNULL(ItemNumber,'') LIKE @Search
      ORDER BY ItemID DESC;
    `);
  if(like.recordset?.length){
    return like.recordset[0].ItemID;
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
    IF OBJECT_ID('dbo.TAppUsers','U') IS NULL
    BEGIN
      CREATE TABLE dbo.TAppUsers
      (
        Username   VARCHAR(120) NOT NULL PRIMARY KEY,
        DisplayName VARCHAR(150) NOT NULL,
        Role        VARCHAR(50)  NOT NULL,
        CreatedAt   DATETIME2(0) NOT NULL CONSTRAINT DF_TAppUsers_Created DEFAULT (SYSUTCDATETIME())
      );
    END;
  `);
}

async function generatePublicTicketId(pool){
  const result = await pool.request().query(`
    SELECT TOP (1) PublicTicketID
    FROM dbo.TServiceTickets
    WHERE PublicTicketID LIKE 'S-%'
    ORDER BY TRY_CONVERT(INT, SUBSTRING(PublicTicketID,3,10)) DESC, ServiceTicketID DESC;
  `);
  const lastId = result.recordset?.[0]?.PublicTicketID;
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
             b.BorrowerID,
             b.FirstName,
             b.LastName,
             b.SchoolIdNumber,
             b.PhoneNumber,
             b.RoomNumber,
             b.Instructor,
             b.CreatedAt,
             d.DepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = b.DepartmentID
      WHERE b.FirstName LIKE @Search
         OR b.LastName LIKE @Search
         OR (b.FirstName + ' ' + b.LastName) LIKE @Search
         OR ISNULL(b.SchoolIdNumber,'') LIKE @Search
         OR ISNULL(b.PhoneNumber,'') LIKE @Search
         OR EXISTS (
             SELECT 1
             FROM dbo.TBorrowerAliases AS a
             WHERE a.BorrowerID = b.BorrowerID
               AND a.Alias LIKE @Search
         )
      ORDER BY b.LastName, b.FirstName, b.BorrowerID DESC;
    `;
  }else{
    queryText = `
      SELECT TOP (@Top)
             b.BorrowerID,
             b.FirstName,
             b.LastName,
             b.SchoolIdNumber,
             b.PhoneNumber,
             b.RoomNumber,
             b.Instructor,
             b.CreatedAt,
             d.DepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = b.DepartmentID
      ORDER BY b.CreatedAt DESC, b.BorrowerID DESC;
    `;
  }

  const result = await request.query(queryText);
  const rows = result.recordset || [];
  const aliasMap = await loadAliasesForBorrowers(pool, rows.map(r => r.BorrowerID));

  const entries = rows.map(row => ({
    id: row.BorrowerID ?? null,
    firstName: row.FirstName || null,
    lastName: row.LastName || null,
    name: formatName(row.FirstName, row.LastName),
    schoolId: row.SchoolIdNumber || null,
    phone: row.PhoneNumber || null,
    room: row.RoomNumber || null,
    instructor: row.Instructor || null,
    department: row.DepartmentName || null,
    createdUtc: toIso(row.CreatedAt),
    aliases: aliasMap.get(row.BorrowerID) || []
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
      SELECT b.BorrowerID,
             b.FirstName,
             b.LastName,
             b.SchoolIdNumber,
             b.PhoneNumber,
             b.RoomNumber,
             b.Instructor,
             b.CreatedAt,
             d.DepartmentName
      FROM dbo.TBorrowers AS b
      LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = b.DepartmentID
      WHERE b.BorrowerID = @BorrowerID;
    `);

  const row = detailResult.recordset?.[0] || null;
  if(!row){
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  const aliasResult = await pool.request()
    .input('BorrowerID', sql.Int, borrowerId)
    .query(`
      SELECT BorrowerAliasID, Alias, CreatedAt
      FROM dbo.TBorrowerAliases
      WHERE BorrowerID = @BorrowerID
      ORDER BY Alias;
    `);

  const aliases = aliasResult.recordset?.map(mapAliasRow) || [];

  res.json({
    id: row.BorrowerID ?? null,
    firstName: row.FirstName || null,
    lastName: row.LastName || null,
    name: formatName(row.FirstName, row.LastName),
    schoolId: row.SchoolIdNumber || null,
    phone: row.PhoneNumber || null,
    room: row.RoomNumber || null,
    instructor: row.Instructor || null,
    department: row.DepartmentName || null,
    createdUtc: toIso(row.CreatedAt),
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
      SELECT BorrowerID
      FROM dbo.TBorrowers
      WHERE BorrowerID = @BorrowerID;
    `);
  if(!borrowerCheck.recordset?.length){
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  try {
    const insert = await pool.request()
      .input('BorrowerID', sql.Int, borrowerId)
      .input('Alias', sql.NVarChar(120), aliasInput)
      .query(`
        INSERT dbo.TBorrowerAliases(BorrowerID, Alias)
        VALUES (@BorrowerID, @Alias);
        SELECT BorrowerAliasID, Alias, CreatedAt
        FROM dbo.TBorrowerAliases
        WHERE BorrowerAliasID = SCOPE_IDENTITY();
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
      WHERE BorrowerAliasID = @AliasId AND BorrowerID = @BorrowerID;
      SELECT @@ROWCOUNT AS deleted;
    `);

  const deleted = result.recordset?.[0]?.deleted ?? 0;
  if(!deleted){
    return res.status(404).json({ error: 'Alias not found.' });
  }

  res.json({ success: true });
}));

app.post('/api/customers', asyncHandler(async (req, res) => {
  const { first, last, schoolId, phone, room, instructor, dept } = req.body || {};
  const firstName = normalizeString(first);
  const lastName = normalizeString(last);
  if(!firstName || !lastName){
    return res.status(400).json({ error: 'First and last name are required.' });
  }

  const pool = await getPool();
  const departmentId = await ensureDepartment(pool, dept);

  try {
    const request = pool.request();
    request.input('FirstName', sql.NVarChar(50), firstName);
    request.input('LastName', sql.NVarChar(50), lastName);
    request.input('SchoolIdNumber', sql.NVarChar(50), normalizeString(schoolId) || null);
    request.input('PhoneNumber', sql.NVarChar(25), normalizeString(phone) || null);
    request.input('RoomNumber', sql.NVarChar(25), normalizeString(room) || null);
    request.input('Instructor', sql.NVarChar(100), normalizeString(instructor) || null);
    request.input('DepartmentID', sql.Int, departmentId ?? null);
    const result = await request.execute('dbo.spCreateBorrower');
    const borrowerId = result.recordset?.[0]?.BorrowerID ?? null;
    res.status(201).json({ id: borrowerId });
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'A borrower with that school ID already exists.' });
    }
    throw err;
  }
}));

app.put('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(borrowerId)){
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const { first, last, schoolId, phone, room, instructor } = req.body || {};
  const firstName = normalizeString(first);
  const lastName = normalizeString(last);
  if(!firstName || !lastName){
    return res.status(400).json({ error: 'First and last name are required.' });
  }

  const pool = await getPool();

  const request = pool.request();
  request.input('intBorrowerID', sql.Int, borrowerId);
  request.input('strFirstName', sql.VarChar(50), firstName);
  request.input('strLastName', sql.VarChar(50), lastName);
  request.input('strSchoolIDNumber', sql.VarChar(50), normalizeString(schoolId) || null);
  request.input('strPhoneNumber', sql.VarChar(25), normalizeString(phone) || null);
  request.input('strRoomNumber', sql.VarChar(25), normalizeString(room) || null);
  request.input('strInstructor', sql.VarChar(100), normalizeString(instructor) || null);
  request.input('intDepartmentID', sql.Int, null);

  try {
    const result = await request.execute('dbo.usp_UpdateBorrower');
    const updated = result?.rowsAffected?.[0] ?? 1;
    if(!updated){
      return res.status(404).json({ error: 'Borrower not found.' });
    }
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'A borrower with that school ID already exists.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

app.delete('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(borrowerId)){
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const pool = await getPool();
  try {
    const result = await pool.request()
      .input('BorrowerID', sql.Int, borrowerId)
      .query(`
        DELETE FROM dbo.TBorrowers WHERE intBorrowerID = @BorrowerID;
        SELECT @@ROWCOUNT AS deleted;
      `);
    const deleted = result.recordset?.[0]?.deleted ?? 0;
    if(!deleted){
      return res.status(404).json({ error: 'Borrower not found.' });
    }
  } catch(err){
    if(err && err.number === 547){
      return res.status(409).json({ error: 'Cannot delete borrower with linked records.' });
    }
    throw err;
  }

  res.json({ success: true });
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
    itemNumber: dueInfo.itemNumber || null,
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

  const labTechId = await getDefaultLabTechId(pool);

  const request = pool.request();
  request.input('ItemID', sql.Int, itemId);
  request.input('BorrowerID', sql.Int, borrowerId);
  request.input('CheckoutLabTechID', sql.Int, labTechId);
  request.input('DueUtc', sql.DateTime2, dueDate);
  request.input('CheckoutNotes', sql.NVarChar(400), normalizeString(notes) || null);

  const result = await request.execute('dbo.spCheckoutItem');
  const loanId = result.recordset?.[0]?.ItemLoanID ?? null;
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
  const labTechId = await getDefaultLabTechId(pool);

  const request = pool.request();
  request.input('PublicTicketID', sql.NVarChar(20), publicId);
  request.input('BorrowerID', sql.Int, borrowerId ?? null);
  request.input('ItemID', sql.Int, itemId ?? null);
  request.input('ItemLabel', sql.NVarChar(120), ticketLabel);
  request.input('Issue', sql.NVarChar(1000), issueText);
  request.input('AssignedLabTechID', sql.Int, labTechId);

  const result = await request.execute('dbo.spCreateServiceTicket');
  const ticketId = result.recordset?.[0]?.ServiceTicketID ?? null;
  res.status(201).json({ ticketId, publicId });
}));

app.get('/api/items', asyncHandler(async (req, res) => {
  const pool = await getPool();
  const top = Number.parseInt(req.query.top || '50', 10);
  const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 500) : 50;
  const search = normalizeString(req.query.search || req.query.q || req.query.term);
  const activeFilter = parseQueryBoolean(req.query.active);

  const request = pool.request();
  request.input('Top', sql.Int, limit);

  const conditions = [];
  if(search){
    request.input('Search', sql.NVarChar(140), `%${search}%`);
    conditions.push(`(i.strItemName LIKE @Search OR ISNULL(i.strItemNumber,'') LIKE @Search OR ISNULL(i.strDescription,'') LIKE @Search OR ISNULL(d.strDepartmentName,'') LIKE @Search)`);
  }
  if(activeFilter !== null){
    request.input('IsActive', sql.Bit, activeFilter ? 1 : 0);
    conditions.push('i.blnIsActive = @IsActive');
  }

  let queryText = `
    SELECT TOP (@Top)
           i.intItemID,
           i.strItemName,
           i.strItemNumber,
           i.blnIsSchoolOwned,
           i.strDescription,
           i.strDuePolicy,
           i.intDueDaysOffset,
           i.intDueHoursOffset,
           i.tDueTime,
           i.dtmFixedDueLocal,
           i.blnIsActive,
           i.dtmCreated,
           d.strDepartmentName
    FROM dbo.TItems AS i
    LEFT JOIN dbo.TDepartments AS d ON d.intDepartmentID = i.intDepartmentID
  `;

  if(conditions.length){
    queryText += ` WHERE ${conditions.join(' AND ')}`;
  }

  queryText += ' ORDER BY i.strItemName, i.intItemID DESC;';

  const result = await request.query(queryText);
  const entries = result.recordset?.map(mapItemRow) || [];
  res.json({ entries });
}));

app.post('/api/items', asyncHandler(async (req, res) => {
  const { name, number, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue } = req.body || {};
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
    request.input('ItemName', sql.NVarChar(120), itemName);
    request.input('ItemNumber', sql.NVarChar(60), normalizeString(number) || null);
    request.input('IsSchoolOwned', sql.Bit, schoolOwned === false ? 0 : 1);
    request.input('DepartmentID', sql.Int, departmentId ?? null);
    request.input('Description', sql.NVarChar(400), normalizeString(description) || null);
    request.input('DuePolicy', sql.NVarChar(30), policy);
    request.input('DueDaysOffset', sql.Int, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null);
    request.input('DueHoursOffset', sql.Int, policy === 'OFFSET' ? hours : null);
    request.input('DueTime', sql.Time, (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null);
    request.input('FixedDueLocal', sql.DateTime2, (policy === 'SEMESTER' || policy === 'FIXED') ? fixedDueDate : null);
    const result = await request.execute('dbo.spCreateItem');
    const itemId = result.recordset?.[0]?.ItemID ?? null;
    res.status(201).json({ itemId });
  } catch(err){
    if(err && (err.number === 2627 || err.number === 2601)){
      return res.status(409).json({ error: 'An item with that identifier already exists.' });
    }
    throw err;
  }
}));

app.put('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if(!Number.isFinite(itemId)){
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const { name, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue, isActive } = req.body || {};
  const itemName = normalizeString(name);
  if(!itemName){
    return res.status(400).json({ error: 'Item name is required.' });
  }

  let policy = (normalizeString(duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  if(!['NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER'].includes(policy)){
    policy = 'NEXT_DAY_6PM';
  }

  const pool = await getPool();
  const departmentId = await ensureDepartment(pool, department);

  let days = null;
  let hours = null;
  let timeSql = null;
  let fixedDueDate = null;

  if(policy === 'OFFSET'){
    const dayVal = toIntOrNull(offsetDays);
    const rawHour = (offsetHours === '' || offsetHours == null)
      ? 0
      : toIntOrNull(offsetHours);
    const timeVal = normalizeTimeForSql(dueTime);
    if(!Number.isInteger(dayVal) || dayVal < 0){
      return res.status(400).json({ error: 'Offset days must be zero or greater.' });
    }
    if(!Number.isInteger(rawHour) || rawHour < 0){
      return res.status(400).json({ error: 'Offset hours must be zero or greater.' });
    }
    if(!timeVal){
      return res.status(400).json({ error: 'Due time is required for offset policy.' });
    }
    days = dayVal;
    hours = rawHour;
    timeSql = timeVal;
  } else if(policy === 'NEXT_DAY_6PM'){
    days = 1;
    hours = 0;
    timeSql = '18:00:00';
  } else if(policy === 'SEMESTER' || policy === 'FIXED'){
    const fixedDate = parseLocalDateTime(fixedDue);
    if(!fixedDate){
      return res.status(400).json({ error: 'Fixed due date is required for this policy.' });
    }
    fixedDueDate = fixedDate;
  }

  const isActiveBit = toNullableBit(isActive);

  const request = pool.request();
  request.input('ItemID', sql.Int, itemId);
  request.input('Name', sql.VarChar(120), itemName);
  request.input('IsSchoolOwned', sql.Bit, schoolOwned === false ? 0 : 1);
  request.input('DepartmentID', sql.Int, departmentId ?? null);
  request.input('Description', sql.VarChar(400), normalizeString(description) || null);
  request.input('DuePolicy', sql.VarChar(30), policy);
  request.input('DueDays', sql.Int, days);
  request.input('DueHours', sql.Int, hours);
  request.input('DueTime', sql.Time, timeSql);
  request.input('FixedDue', sql.DateTime2, fixedDueDate);
  request.input('IsActive', sql.Bit, isActiveBit);

  const result = await request.query(`
    UPDATE dbo.TItems
    SET strItemName = @Name,
        blnIsSchoolOwned = @IsSchoolOwned,
        intDepartmentID = @DepartmentID,
        strDescription = @Description,
        strDuePolicy = @DuePolicy,
        intDueDaysOffset = @DueDays,
        intDueHoursOffset = @DueHours,
        tDueTime = @DueTime,
        dtmFixedDueLocal = @FixedDue,
        blnIsActive = CASE WHEN @IsActive IS NULL THEN blnIsActive ELSE @IsActive END
    WHERE intItemID = @ItemID;
    SELECT @@ROWCOUNT AS updated;
  `);

  const updated = result.recordset?.[0]?.updated ?? 0;
  if(!updated){
    return res.status(404).json({ error: 'Item not found.' });
  }

  res.json({ success: true });
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
      return res.status(409).json({ error: 'Cannot delete item with linked records.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

const LOAN_STATUS_SET = new Set(['On Time', 'Overdue', 'Returned']);
const TICKET_STATUS_SET = new Set(['Diagnosing', 'Awaiting Parts', 'Ready for Pickup', 'Quarantined', 'Returned', 'Cancelled']);

app.post('/api/status', asyncHandler(async (req, res) => {
  const { id, type, status, note } = req.body || {};
  const statusText = normalizeString(status);
  if(!id || !type || !statusText){
    return res.status(400).json({ error: 'id, type, and status are required.' });
  }

  const pool = await getPool();
  const labTechId = await getDefaultLabTechId(pool);
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
        SELECT ItemLoanID, DueUtc, CheckinUtc, CheckoutNotes
        FROM dbo.TItemLoans
        WHERE ItemLoanID = @LoanID;
      `);
    if(!loanResult.recordset?.length){
      return res.status(404).json({ error: 'Loan not found.' });
    }
    const loan = loanResult.recordset[0];

    if(statusText === 'Returned'){
      const checkinReq = pool.request();
      checkinReq.input('ItemLoanID', sql.Int, loanId);
      checkinReq.input('CheckinLabTechID', sql.Int, labTechId);
      checkinReq.input('CheckinNotes', sql.NVarChar(400), trimmedNote);
      await checkinReq.execute('dbo.spCheckinItem');
    } else {
      const now = new Date();
      let dueDate = loan.DueUtc ? new Date(loan.DueUtc) : null;
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
        updateReq.input('ItemLoanID', sql.Int, loanId);
        updateReq.input('DueUtc', sql.DateTime2, dueDate);
        updateReq.input('CheckoutNotes', sql.NVarChar(400), loan.CheckoutNotes || null);
        await updateReq.execute('dbo.spUpdateLoanDue');
      }
      if(trimmedNote){
        const noteReq = pool.request();
        noteReq.input('ItemLoanID', sql.Int, loanId);
        noteReq.input('LabTechID', sql.Int, labTechId);
        noteReq.input('Note', sql.NVarChar(1000), trimmedNote);
        await noteReq.execute('dbo.spAddLoanNote');
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
    statusReq.input('ServiceTicketID', sql.Int, ticketId);
    statusReq.input('Status', sql.NVarChar(30), statusText);
    statusReq.input('LabTechID', sql.Int, labTechId);
    await statusReq.execute('dbo.spSetServiceTicketStatus');

    if(trimmedNote){
      const noteReq = pool.request();
      noteReq.input('ServiceTicketID', sql.Int, ticketId);
      noteReq.input('LabTechID', sql.Int, labTechId);
      noteReq.input('Note', sql.NVarChar(1000), trimmedNote);
      await noteReq.execute('dbo.spAddServiceTicketNote');
    }

    return res.json({ success: true });
  }

  return res.status(400).json({ error: `Unknown status type: ${type}` });
}));

app.get('/api/users', asyncHandler(async (req, res) => {
  const pool = await getPool();
  await ensureUserTable(pool);

  const top = Number.parseInt(req.query.top || '200', 10);
  const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 500) : 200;
  const search = normalizeString(req.query.search || req.query.q || req.query.term);

  const request = pool.request();
  request.input('Top', sql.Int, limit);

  let queryText = `
    SELECT TOP (@Top)
           strUsername,
           strDisplayName,
           strRole,
           dtmCreated
    FROM dbo.TAppUsers
  `;

  if(search){
    request.input('Search', sql.VarChar(160), `%${search}%`);
    queryText += ` WHERE strUsername LIKE @Search OR strDisplayName LIKE @Search OR strRole LIKE @Search`;
  }

  queryText += ' ORDER BY strUsername;';

  const result = await request.query(queryText);
  const entries = result.recordset?.map(mapUserRow) || [];
  res.json({ entries });
}));

app.post('/api/users', asyncHandler(async (req, res) => {
  const { username, display, role } = req.body || {};
  const user = normalizeString(username).toLowerCase();
  const displayName = normalizeString(display);
  const roleName = normalizeString(role).toLowerCase();
  if(!user || !displayName || !roleName){
    return res.status(400).json({ error: 'Username, display, and role are required.' });
  }

  const pool = await getPool();
  await ensureUserTable(pool);

  try {
    await pool.request()
      .input('Username', sql.VarChar(120), user)
      .input('Display', sql.VarChar(150), displayName)
      .input('Role', sql.VarChar(50), roleName)
      .query(`
        INSERT INTO dbo.TAppUsers(Username,DisplayName,Role)
        VALUES (@Username,@Display,@Role);
      `);
  } catch(err){
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

  const displayName = normalizeString(req.body?.display);
  const roleName = normalizeString(req.body?.role);
  if(!displayName || !roleName){
    return res.status(400).json({ error: 'Display name and role are required.' });
  }

  const pool = await getPool();
  await ensureUserTable(pool);

  const result = await pool.request()
    .input('Username', sql.VarChar(120), username)
    .input('Display', sql.VarChar(150), displayName)
    .input('Role', sql.VarChar(50), roleName.toLowerCase())
    .query(`
      UPDATE dbo.TAppUsers
      SET strDisplayName = @Display,
          strRole = @Role
      WHERE strUsername = @Username;
      SELECT @@ROWCOUNT AS updated;
    `);

  const updated = result.recordset?.[0]?.updated ?? 0;
  if(!updated){
    return res.status(404).json({ error: 'User not found.' });
  }

  res.json({ success: true });
}));

app.delete('/api/users/:username', asyncHandler(async (req, res) => {
  const username = normalizeString(req.params.username).toLowerCase();
  if(!username){
    return res.status(400).json({ error: 'Username required.' });
  }

  await ensureUserTable(await getPool());
  const pool = await getPool();

  const result = await pool.request()
    .input('Username', sql.VarChar(120), username)
    .query(`
      DELETE FROM dbo.TAppUsers WHERE Username = @Username;
      SELECT @@ROWCOUNT AS deleted;
    `);
  const deleted = result.recordset?.[0]?.deleted ?? 0;
  if(!deleted){
    return res.status(404).json({ error: 'User not found.' });
  }

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
