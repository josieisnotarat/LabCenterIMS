const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const express = require('express');
const sqlite = require('./db/sqlite');
const { initializeDatabase } = require('./db/initialize');

function loadEnvFile(filePath) {
  try {
    const contents = fs.readFileSync(filePath, 'utf8');
    contents.split(/\r?\n/).forEach(line => {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) {
        return;
      }
      const idx = trimmed.indexOf('=');
      if (idx === -1) {
        return;
      }
      const key = trimmed.slice(0, idx).trim();
      if (!key || Object.prototype.hasOwnProperty.call(process.env, key)) {
        return;
      }
      let value = trimmed.slice(idx + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
        value = value.slice(1, -1);
      }
      process.env[key] = value;
    });
  } catch (err) {
    if (err.code !== 'ENOENT') {
      console.warn(`Unable to read env file ${filePath}:`, err.message);
    }
  }
}

loadEnvFile(path.join(__dirname, '.env'));
if (process.cwd() !== __dirname) {
  loadEnvFile(path.join(process.cwd(), '.env'));
}

const app = express();
app.use(express.json());

const dbPath = process.env.SQLITE_PATH || 'labcenter.db';
initializeDatabase(dbPath);
const db = sqlite.openDatabase(dbPath);

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

function asyncHandler(fn) {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

function normalizeString(value) {
  if (typeof value !== 'string') return '';
  return value.trim();
}

function normalizeUserRole(value) {
  if (value == null) return null;
  const text = value.toString().trim();
  if (!text) return null;
  const lower = text.toLowerCase();
  if (USER_ROLE_ALIASES.has(lower)) {
    return USER_ROLE_ALIASES.get(lower);
  }
  const collapsedSpaces = lower.replace(/[\s_]+/g, ' ');
  if (USER_ROLE_ALIASES.has(collapsedSpaces)) {
    return USER_ROLE_ALIASES.get(collapsedSpaces);
  }
  const collapsed = lower.replace(/[\s_-]+/g, '');
  if (USER_ROLE_ALIASES.has(collapsed)) {
    return USER_ROLE_ALIASES.get(collapsed);
  }
  return null;
}

function getUserRoleLabel(role) {
  const canonical = normalizeUserRole(role);
  if (canonical && USER_ROLE_LABELS[canonical]) {
    return USER_ROLE_LABELS[canonical];
  }
  const trimmed = normalizeString(role);
  return trimmed || null;
}

function formatName(first, last) {
  return [first, last].filter(Boolean).join(' ').trim() || null;
}

function readAuthToken(req) {
  const header = req.headers?.authorization;
  if (typeof header === 'string') {
    const match = header.match(/^Bearer\s+(.+)$/i);
    if (match) {
      const token = match[1]?.trim();
      if (token) {
        return token;
      }
    }
  }
  return null;
}

function getActiveSession(token) {
  if (!token) return null;
  const record = sessions.get(token);
  if (!record) return null;
  if (Date.now() - record.lastActive > SESSION_TIMEOUT_MS) {
    sessions.delete(token);
    return null;
  }
  record.lastActive = Date.now();
  return record;
}

function createSession(user) {
  if (!user || user.id == null) {
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

function destroySession(token) {
  if (!token) return;
  sessions.delete(token);
}

function invalidateSessionsForUser(userId) {
  if (userId == null) return;
  for (const [token, session] of sessions.entries()) {
    if (session.user?.id === userId) {
      sessions.delete(token);
    }
  }
}

function updateSessionsForUser(user) {
  if (!user || user.id == null) return;
  for (const [, session] of sessions.entries()) {
    if (session.user?.id === user.id) {
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

function isApiRequest(req) {
  return typeof req.path === 'string' && req.path.startsWith('/api');
}

function isPublicApiRoute(req) {
  if (req.method === 'POST' && req.path === '/api/login') return true;
  if (req.method === 'GET' && req.path === '/api/session') return true;
  return false;
}

app.use((req, res, next) => {
  if (!isApiRequest(req)) {
    return next();
  }

  const token = readAuthToken(req);
  if (token) {
    const session = getActiveSession(token);
    if (session) {
      req.user = session.user;
      req.sessionToken = token;
    }
  }

  if (isPublicApiRoute(req)) {
    return next();
  }

  if (!req.user) {
    return res.status(401).json({ error: 'Authentication required.' });
  }

  return next();
});

function ensureDefaultLabTechId() {
  const row = db.prepare(`
    SELECT intLabTechID
    FROM TLabTechs
    WHERE blnIsActive = 1
    ORDER BY intLabTechID ASC
    LIMIT 1;
  `).get();
  if (!row) {
    throw new Error('No active user available for checkout.');
  }
  return row.intLabTechID;
}

function resolveLabTechIdForLoans(user) {
  const candidateRaw = user?.id;
  const candidateId = Number.isFinite(candidateRaw) ? candidateRaw : Number.parseInt(candidateRaw, 10);
  if (Number.isFinite(candidateId)) {
    const exists = db.prepare(`SELECT intLabTechID FROM TLabTechs WHERE intLabTechID = ?`).get(candidateId);
    if (exists) return candidateId;
  }
  return ensureDefaultLabTechId();
}

function mapItemRow(row, dueInfo) {
  if (!row) return null;
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
    dueTime: row.tDueTime || null,
    fixedDueLocal: row.dtmFixedDueLocal || null,
    lastUpdatedUtc: row.dtmCreated || null
  };
}

app.post('/api/login', asyncHandler(async (req, res) => {
  const username = normalizeString(req.body?.username).toLowerCase();
  const password = normalizeString(req.body?.password);
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required.' });
  }

  const user = sqlite.findUserByCredentials(db, username, password);
  if (!user) {
    return res.status(401).json({ error: 'Invalid username or password.' });
  }

  const session = createSession({
    ...user,
    roleLabel: getUserRoleLabel(user.role)
  });
  res.json({ token: session.token, user: session.user });
}));

app.get('/api/session', asyncHandler(async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ error: 'Not authenticated.' });
  }
  res.json({ user: req.user });
}));

app.post('/api/logout', asyncHandler(async (req, res) => {
  if (req.sessionToken) {
    destroySession(req.sessionToken);
  }
  res.json({ success: true });
}));

app.get('/api/dashboard-stats', asyncHandler(async (req, res) => {
  const stats = sqlite.getDashboardStats(db);
  res.json(stats);
}));

app.get('/api/loans', asyncHandler(async (req, res) => {
  const entries = sqlite.getLoans(db, {
    status: req.query.status || req.query.statusFilter,
    search: req.query.search
  });
  res.json({ entries });
}));

app.get('/api/service-tickets', asyncHandler(async (req, res) => {
  const entries = sqlite.getServiceTickets(db, {
    status: req.query.status || req.query.statusFilter,
    search: req.query.search
  });
  res.json({ entries });
}));

app.get('/api/borrowers/search', asyncHandler(async (req, res) => {
  const query = normalizeString(req.query.query || req.query.q || req.query.term);
  if (!query || query.length < 2) {
    return res.json({ entries: [] });
  }

  const top = Number.parseInt(req.query.top || '8', 10);
  const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 50) : 8;
  const entries = sqlite.searchBorrowers(db, { query, top: limit });
  res.json({ entries: entries.slice(0, limit) });
}));

app.get('/api/loans/:id/notes', asyncHandler(async (req, res) => {
  const loanId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(loanId)) {
    return res.status(400).json({ error: 'Invalid loan id.' });
  }

  const entries = sqlite.getLoanNotes(db, loanId);
  res.json({ entries });
}));

app.get('/api/service-tickets/:id/notes', asyncHandler(async (req, res) => {
  const ticketId = sqlite.resolveServiceTicketId(db, req.params.id);
  if (!ticketId) {
    return res.status(404).json({ error: 'Service ticket not found.' });
  }

  const entries = sqlite.getServiceTicketNotes(db, ticketId);
  res.json({ entries });
}));

app.get('/api/audit-log', asyncHandler(async (req, res) => {
  const entries = sqlite.getAuditLog(db, { limit: 100 });
  res.json({ entries });
}));

app.get('/api/customers', asyncHandler(async (req, res) => {
  const search = normalizeString(req.query.search || req.query.q || req.query.query);
  const entries = sqlite.listCustomers(db, { search: search || null });
  res.json({ entries });
}));

app.get('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(borrowerId)) {
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const detail = sqlite.getCustomer(db, borrowerId);
  if (!detail) {
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  res.json(detail);
}));

app.post('/api/customers/:id/aliases', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(borrowerId)) {
    return res.status(400).json({ error: 'Invalid borrower id.' });
  }

  const aliasInput = normalizeString(req.body?.alias || req.body?.name);
  if (!aliasInput) {
    return res.status(400).json({ error: 'Alias is required.' });
  }
  if (aliasInput.length > 120) {
    return res.status(400).json({ error: 'Alias must be 120 characters or fewer.' });
  }

  const existing = sqlite.getCustomer(db, borrowerId);
  if (!existing) {
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  try {
    const alias = sqlite.createCustomerAlias(db, borrowerId, aliasInput);
    res.status(201).json(alias);
  } catch (err) {
    if (err?.message?.includes('UNIQUE')) {
      return res.status(409).json({ error: 'Alias already exists for this customer.' });
    }
    throw err;
  }
}));

app.delete('/api/customers/:id/aliases/:aliasId', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  const aliasId = Number.parseInt(req.params.aliasId, 10);
  if (!Number.isFinite(borrowerId) || !Number.isFinite(aliasId)) {
    return res.status(400).json({ error: 'Invalid identifier.' });
  }

  try {
    sqlite.deleteCustomerAlias(db, borrowerId, aliasId);
  } catch (err) {
    if (err?.message?.includes('Alias not found')) {
      return res.status(404).json({ error: 'Alias not found.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

app.delete('/api/customers/:id', asyncHandler(async (req, res) => {
  const borrowerId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(borrowerId)) {
    return res.status(400).json({ error: 'Invalid customer id.' });
  }

  try {
    sqlite.deleteCustomer(db, borrowerId);
  } catch (err) {
    if (err?.message?.includes('existing loan or service history')) {
      return res.status(409).json({ error: err.message });
    }
    if (err?.message?.includes('Customer not found')) {
      return res.status(404).json({ error: 'Customer not found.' });
    }
    throw err;
  }

  res.json({ success: true });
}));

app.post('/api/customers', asyncHandler(async (req, res) => {
  const { first, last, schoolId, phone, room, instructor, department } = req.body || {};
  const firstName = normalizeString(first);
  const lastName = normalizeString(last);
  if (!firstName || !lastName) {
    return res.status(400).json({ error: 'First and last name are required.' });
  }

  const departmentId = sqlite.ensureDepartmentId(db, department);

  try {
    const borrowerId = sqlite.createBorrower(db, {
      firstName,
      lastName,
      schoolId: normalizeString(schoolId) || null,
      phone: normalizeString(phone) || null,
      room: normalizeString(room) || null,
      instructor: normalizeString(instructor) || null,
      departmentId
    });
    res.status(201).json({ id: borrowerId });
  } catch (err) {
    if (err?.message?.includes('UNIQUE')) {
      return res.status(409).json({ error: 'A borrower with that school ID already exists.' });
    }
    throw err;
  }
}));

app.get('/api/items', asyncHandler(async (req, res) => {
  const search = normalizeString(req.query.search || req.query.q || req.query.query);
  const entries = sqlite.listItems(db, { search: search || null });
  res.json({ entries });
}));

app.get('/api/items/due-preview', asyncHandler(async (req, res) => {
  const raw = req.query.item || req.query.q || '';
  const itemQuery = normalizeString(raw);
  if (!itemQuery) {
    return res.json({ message: 'Provide an item to preview.' });
  }

  const itemId = sqlite.findItemId(db, itemQuery);
  if (!itemId) {
    return res.json({ message: 'Item not found.' });
  }

  const dueInfo = sqlite.resolveItemDue(db, itemId);
  if (!dueInfo) {
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
  if (!item) {
    return res.status(400).json({ error: 'Item is required.' });
  }

  const borrowerId = sqlite.findBorrowerId(db, req.body || {});
  if (!borrowerId) {
    return res.status(404).json({ error: 'Borrower not found.' });
  }

  const itemId = sqlite.findItemId(db, item);
  if (!itemId) {
    return res.status(404).json({ error: 'Item not found.' });
  }

  const dueInfo = sqlite.resolveItemDue(db, itemId);
  const userId = resolveLabTechIdForLoans(req.user);

  try {
    const result = sqlite.checkoutItem(db, {
      itemId,
      borrowerId,
      labTechId: userId,
      dueUtc: dueInfo?.dueUtc || null,
      notes: normalizeString(notes) || null
    });
    const loanId = result.loanId;
    const traceNumber = typeof loanId === 'number' ? loanId.toString().padStart(6, '0') : null;
    res.status(201).json({
      loanId,
      traceNumber,
      dueUtc: dueInfo?.dueUtc ?? null,
      dueDescription: dueInfo?.description ?? null,
      duePolicy: dueInfo?.policy ?? null
    });
  } catch (err) {
    if (err?.message?.includes('already checked out')) {
      return res.status(409).json({ error: 'Item is already checked out.' });
    }
    throw err;
  }
}));

app.post('/api/tickets', asyncHandler(async (req, res) => {
  const { item, issue } = req.body || {};
  const issueText = normalizeString(issue);
  if (!item || !issueText) {
    return res.status(400).json({ error: 'Item and issue are required.' });
  }

  const borrowerId = sqlite.findBorrowerId(db, req.body || {});
  const itemId = sqlite.findItemId(db, item);
  const ticketLabel = itemId ? null : normalizeString(item);

  const publicId = sqlite.generatePublicTicketId(db);
  const userId = resolveLabTechIdForLoans(req.user);

  const result = sqlite.createServiceTicket(db, {
    publicId,
    borrowerId,
    itemId,
    itemLabel: ticketLabel,
    issue: issueText,
    assignedLabTechId: userId,
    status: 'Diagnosing'
  });
  res.status(201).json(result);
}));

app.post('/api/items', asyncHandler(async (req, res) => {
  const { name, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue } = req.body || {};
  const itemName = normalizeString(name);
  if (!itemName) {
    return res.status(400).json({ error: 'Item name is required.' });
  }

  const departmentId = sqlite.ensureDepartmentId(db, department);

  try {
    const itemId = sqlite.createItem(db, {
      name: itemName,
      departmentId,
      schoolOwned: schoolOwned !== false,
      description: normalizeString(description) || null,
      duePolicy,
      offsetDays,
      offsetHours,
      dueTime,
      fixedDue
    });
    res.status(201).json({ itemId });
  } catch (err) {
    if (err?.message?.includes('UNIQUE')) {
      return res.status(409).json({ error: 'An item with that name already exists.' });
    }
    throw err;
  }
}));

app.get('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(itemId)) {
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  const row = sqlite.getItem(db, itemId);
  if (!row) {
    return res.status(404).json({ error: 'Item not found.' });
  }

  const dueInfo = sqlite.resolveItemDue(db, itemId);
  res.json(mapItemRow(row, dueInfo));
}));

app.put('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(itemId)) {
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
  if (!itemName) {
    return res.status(400).json({ error: 'Item name is required.' });
  }

  const existing = sqlite.getItem(db, itemId);
  if (!existing) {
    return res.status(404).json({ error: 'Item not found.' });
  }

  const departmentId = sqlite.ensureDepartmentId(db, department);

  try {
    const updated = sqlite.updateItem(db, itemId, {
      name: itemName,
      departmentId,
      schoolOwned: schoolOwned !== false,
      description: normalizeString(description) || null,
      duePolicy,
      offsetDays,
      offsetHours,
      dueTime,
      fixedDue
    });
    const dueInfo = sqlite.resolveItemDue(db, itemId);
    res.json(mapItemRow(updated, dueInfo));
  } catch (err) {
    if (err?.message?.includes('UNIQUE')) {
      return res.status(409).json({ error: 'An item with that name already exists.' });
    }
    throw err;
  }
}));

app.delete('/api/items/:id', asyncHandler(async (req, res) => {
  const itemId = Number.parseInt(req.params.id, 10);
  if (!Number.isFinite(itemId)) {
    return res.status(400).json({ error: 'Invalid item id.' });
  }

  try {
    sqlite.deleteItem(db, itemId);
  } catch (err) {
    if (err?.message?.includes('foreign key')) {
      return res.status(409).json({ error: 'Cannot delete item that is referenced by loans or tickets.' });
    }
    if (err?.message?.includes('Item not found')) {
      return res.status(404).json({ error: 'Item not found.' });
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
  if (!id || !type || !statusText) {
    return res.status(400).json({ error: 'id, type, and status are required.' });
  }

  const userId = resolveLabTechIdForLoans(req.user);
  const trimmedNote = normalizeString(note) || null;

  if (type === 'Loan') {
    if (!LOAN_STATUS_SET.has(statusText)) {
      return res.status(400).json({ error: `Unsupported loan status: ${statusText}` });
    }
    const loanId = Number.parseInt(id, 10);
    if (!Number.isFinite(loanId)) {
      return res.status(400).json({ error: 'Invalid loan id.' });
    }

    const loan = sqlite.getLoanById(db, loanId);
    if (!loan) {
      return res.status(404).json({ error: 'Loan not found.' });
    }

    if (statusText === 'Returned') {
      sqlite.checkinItem(db, loanId, { labTechId: userId, notes: trimmedNote });
    } else {
      const now = new Date();
      let dueDate = loan.dtmDueUTC ? new Date(loan.dtmDueUTC) : null;
      if (statusText === 'Overdue') {
        if (!dueDate || dueDate > now) {
          dueDate = new Date(now.getTime() - 60 * 60 * 1000);
        }
      } else if (statusText === 'On Time') {
        if (!dueDate || dueDate < now) {
          dueDate = new Date(now.getTime() + 24 * 60 * 60 * 1000);
        }
      }
      if (dueDate) {
        sqlite.updateLoanDue(db, loanId, {
          dueUtc: dueDate.toISOString(),
          checkoutNotes: loan.strCheckoutNotes || null
        });
      }
      if (trimmedNote) {
        sqlite.addLoanNote(db, loanId, { labTechId: userId, note: trimmedNote });
      }
    }

    return res.json({ success: true });
  }

  if (type === 'Service Ticket') {
    if (!TICKET_STATUS_SET.has(statusText)) {
      return res.status(400).json({ error: `Unsupported service ticket status: ${statusText}` });
    }
    const ticketId = sqlite.resolveServiceTicketId(db, id);
    if (!ticketId) {
      return res.status(404).json({ error: 'Service ticket not found.' });
    }

    sqlite.setServiceTicketStatus(db, ticketId, { status: statusText, labTechId: userId });
    if (trimmedNote) {
      sqlite.addServiceTicketNote(db, ticketId, { labTechId: userId, note: trimmedNote });
    }

    return res.json({ success: true });
  }

  return res.status(400).json({ error: `Unknown status type: ${type}` });
}));

app.get('/api/users', asyncHandler(async (req, res) => {
  const search = normalizeString(req.query.search || req.query.q || req.query.query);
  const entries = sqlite.listUsers(db, { search: search || null }).map((user) => ({
    ...user,
    roleLabel: getUserRoleLabel(user.role)
  }));
  res.json({ entries });
}));

app.post('/api/users', asyncHandler(async (req, res) => {
  const { username, display, role, password } = req.body || {};
  const user = normalizeString(username).toLowerCase();
  const displayName = normalizeString(display);
  const roleName = normalizeUserRole(role);
  if (!user || !displayName || !roleName) {
    return res.status(400).json({ error: 'Username, display, and a valid role are required.' });
  }

  const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
  if (!normalizedPassword) {
    return res.status(400).json({ error: 'Password is required.' });
  }
  if (normalizedPassword.length < 8) {
    return res.status(400).json({ error: 'Password must be at least 8 characters.' });
  }
  if (normalizedPassword.length > 255) {
    return res.status(400).json({ error: 'Password must be 255 characters or fewer.' });
  }

  const cappedDisplayName = displayName.substring(0, 150);
  const [first, ...rest] = cappedDisplayName.split(/\s+/);
  const last = rest.length ? rest.join(' ') : cappedDisplayName;
  const firstLimited = first.substring(0, 50);
  const lastLimited = last.substring(0, 50);

  try {
    sqlite.createUser(db, {
      username: user,
      displayName: cappedDisplayName,
      firstName: firstLimited || cappedDisplayName,
      lastName: lastLimited || cappedDisplayName,
      password: normalizedPassword,
      role: roleName,
      isActive: true
    });
  } catch (err) {
    if (err?.message?.includes('UNIQUE')) {
      return res.status(409).json({ error: 'Username already exists.' });
    }
    throw err;
  }

  res.status(201).json({ username: user });
}));

app.put('/api/users/:username', asyncHandler(async (req, res) => {
  const username = normalizeString(req.params.username).toLowerCase();
  if (!username) {
    return res.status(400).json({ error: 'Username required.' });
  }

  const { display, role, password } = req.body || {};
  const displayName = normalizeString(display);
  const roleName = normalizeUserRole(role);
  if (!displayName || !roleName) {
    return res.status(400).json({ error: 'Display and a valid role are required.' });
  }

  const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
  if (normalizedPassword && normalizedPassword.length < 8) {
    return res.status(400).json({ error: 'Password must be at least 8 characters.' });
  }

  if (normalizedPassword && normalizedPassword.length > 255) {
    return res.status(400).json({ error: 'Password must be 255 characters or fewer.' });
  }

  const cappedDisplayName = displayName.substring(0, 150);
  const [first, ...rest] = cappedDisplayName.split(/\s+/);
  const last = rest.length ? rest.join(' ') : cappedDisplayName;
  const firstLimited = first.substring(0, 50);
  const lastLimited = last.substring(0, 50);

  try {
    sqlite.updateUser(db, username, {
      displayName: cappedDisplayName,
      firstName: firstLimited || cappedDisplayName,
      lastName: lastLimited || cappedDisplayName,
      role: roleName,
      password: normalizedPassword || null
    });
  } catch (err) {
    if (err?.message?.includes('User not found')) {
      return res.status(404).json({ error: 'User not found.' });
    }
    throw err;
  }

  const detail = sqlite.getUserByUsername(db, username);
  const mapped = detail ? { ...detail, roleLabel: getUserRoleLabel(detail.role) } : null;
  if (mapped) {
    updateSessionsForUser(mapped);
  }
  res.json(mapped);
}));

app.delete('/api/users/:username', asyncHandler(async (req, res) => {
  const username = normalizeString(req.params.username).toLowerCase();
  if (!username) {
    return res.status(400).json({ error: 'Username required.' });
  }

  const user = sqlite.getUserByUsername(db, username);
  if (!user) {
    return res.status(404).json({ error: 'User not found.' });
  }

  try {
    sqlite.deleteUser(db, user.id);
  } catch (err) {
    if (err?.message?.includes('historical activity')) {
      return res.status(409).json({ error: 'Cannot delete user with historical activity. Clear related records first.' });
    }
    throw err;
  }

  invalidateSessionsForUser(user.id);
  res.json({ success: true });
}));

app.delete('/api/admin/audit-log', asyncHandler(async (req, res) => {
  sqlite.clearAuditLog(db);
  res.json({ success: true });
}));

app.post('/api/admin/clear-database', asyncHandler(async (req, res) => {
  sqlite.clearDatabase(db);
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

function shutdown() {
  try {
    db.close();
  } catch {
    /* ignore */
  }
  process.exit(0);
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
