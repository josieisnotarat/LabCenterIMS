const crypto = require('crypto');
const sqlite = require('../db/sqlite');

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

const ITEM_DUE_POLICY_SET = new Set(['NEXT_DAY_6PM', 'OFFSET', 'SEMESTER', 'FIXED']);
const LOAN_STATUS_SET = new Set(['On Time', 'Overdue', 'Returned']);
const TICKET_STATUS_SET = new Set([
  'Diagnosing',
  'Awaiting Parts',
  'Ready for Pickup',
  'Completed',
  'Cancelled'
]);

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

function normalizeDuePolicy(value) {
  const normalized = normalizeString(value).toUpperCase();
  if (!normalized) return 'NEXT_DAY_6PM';
  return normalized;
}

function isAdminUser(user) {
  return normalizeUserRole(user?.role) === 'admin';
}

function readAuthToken(headers = {}) {
  const header = headers.authorization || headers.Authorization;
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

function ensureDefaultLabTechId(db) {
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

function resolveLabTechIdForLoans(db, user) {
  const candidateRaw = user?.id;
  const candidateId = Number.isFinite(candidateRaw) ? candidateRaw : Number.parseInt(candidateRaw, 10);
  if (Number.isFinite(candidateId)) {
    const exists = db.prepare(`SELECT intLabTechID FROM TLabTechs WHERE intLabTechID = ?`).get(candidateId);
    if (exists) return candidateId;
  }
  return ensureDefaultLabTechId(db);
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

function parseJsonBody(body, headers) {
  if (body == null) return null;
  if (typeof body === 'object') return body;
  const contentType = headers?.['content-type'] || headers?.['Content-Type'] || '';
  if (contentType.includes('application/json')) {
    try {
      return JSON.parse(body);
    } catch {
      return null;
    }
  }
  return body;
}

function jsonResponse(status, body) {
  return { status, body };
}

function createApiHandler(db) {
  return ({ method, path, headers = {}, body }) => {
    const token = readAuthToken(headers);
    const session = token ? getActiveSession(token) : null;
    const user = session?.user || null;

    if (!(method === 'POST' && path === '/api/login') && !(method === 'GET' && path === '/api/session')) {
      if (!user && path.startsWith('/api')) {
        return jsonResponse(401, { error: 'Authentication required.' });
      }
    }

    const payload = parseJsonBody(body, headers) || {};

    if (method === 'POST' && path === '/api/login') {
      const username = normalizeString(payload?.username).toLowerCase();
      const password = normalizeString(payload?.password);
      if (!username || !password) {
        return jsonResponse(400, { error: 'Username and password are required.' });
      }
      const found = sqlite.findUserByCredentials(db, username, password);
      if (!found) {
        return jsonResponse(401, { error: 'Invalid username or password.' });
      }
      const sessionInfo = createSession({
        ...found,
        roleLabel: getUserRoleLabel(found.role)
      });
      return jsonResponse(200, { token: sessionInfo.token, user: sessionInfo.user });
    }

    if (method === 'GET' && path === '/api/session') {
      if (!user) {
        return jsonResponse(401, { error: 'Not authenticated.' });
      }
      return jsonResponse(200, { user });
    }

    if (method === 'POST' && path === '/api/logout') {
      if (token) {
        destroySession(token);
      }
      return jsonResponse(200, { success: true });
    }

    if (method === 'GET' && path === '/api/dashboard-stats') {
      return jsonResponse(200, sqlite.getDashboardStats(db));
    }

    if (method === 'GET' && path.startsWith('/api/loans/') && path.endsWith('/notes')) {
      const loanId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(loanId)) {
        return jsonResponse(400, { error: 'Invalid loan id.' });
      }
      return jsonResponse(200, { entries: sqlite.getLoanNotes(db, loanId) });
    }

    if (method === 'GET' && path === '/api/loans') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const entries = sqlite.getLoans(db, {
        status: url.searchParams.get('status') || url.searchParams.get('statusFilter'),
        search: url.searchParams.get('search')
      });
      return jsonResponse(200, { entries });
    }

    if (method === 'GET' && path === '/api/service-tickets') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const entries = sqlite.getServiceTickets(db, {
        status: url.searchParams.get('status') || url.searchParams.get('statusFilter'),
        search: url.searchParams.get('search')
      });
      return jsonResponse(200, { entries });
    }

    if (method === 'GET' && path.startsWith('/api/service-tickets/') && path.endsWith('/notes')) {
      const ticketIdentifier = path.split('/')[3];
      const ticketId = sqlite.resolveServiceTicketId(db, ticketIdentifier);
      if (!ticketId) {
        return jsonResponse(404, { error: 'Service ticket not found.' });
      }
      return jsonResponse(200, { entries: sqlite.getServiceTicketNotes(db, ticketId) });
    }

    if (method === 'GET' && path === '/api/borrowers/search') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const query = normalizeString(url.searchParams.get('query') || url.searchParams.get('q') || url.searchParams.get('term'));
      if (!query || query.length < 2) {
        return jsonResponse(200, { entries: [] });
      }
      const top = Number.parseInt(url.searchParams.get('top') || '8', 10);
      const limit = Number.isFinite(top) && top > 0 ? Math.min(top, 50) : 8;
      const entries = sqlite.searchBorrowers(db, { query, top: limit });
      return jsonResponse(200, { entries: entries.slice(0, limit) });
    }

    if (method === 'GET' && path === '/api/audit-log') {
      return jsonResponse(200, { entries: sqlite.getAuditLog(db, { limit: 100 }) });
    }

    if (path.startsWith('/api/admin/') && !isAdminUser(user)) {
      return jsonResponse(403, { error: 'Admin access is required.' });
    }

    if (method === 'GET' && path === '/api/customers') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const search = normalizeString(url.searchParams.get('search') || url.searchParams.get('q') || url.searchParams.get('query'));
      return jsonResponse(200, { entries: sqlite.listCustomers(db, { search: search || null }) });
    }

    if (method === 'GET' && path.startsWith('/api/customers/')) {
      const borrowerId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(borrowerId)) {
        return jsonResponse(400, { error: 'Invalid borrower id.' });
      }
      const detail = sqlite.getCustomer(db, borrowerId);
      if (!detail) {
        return jsonResponse(404, { error: 'Borrower not found.' });
      }
      return jsonResponse(200, detail);
    }

    if (method === 'POST' && path === '/api/customers') {
      const { first, last, schoolId, phone, room, instructor, department } = payload || {};
      const firstName = normalizeString(first);
      const lastName = normalizeString(last);
      if (!firstName || !lastName) {
        return jsonResponse(400, { error: 'First and last name are required.' });
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
        return jsonResponse(201, { id: borrowerId });
      } catch (err) {
        if (err?.message?.includes('UNIQUE')) {
          return jsonResponse(409, { error: 'A borrower with that school ID already exists.' });
        }
        throw err;
      }
    }

    if (path.match(/^\/api\/customers\/\d+\/aliases$/) && method === 'POST') {
      const borrowerId = Number.parseInt(path.split('/')[3], 10);
      const aliasInput = normalizeString(payload?.alias || payload?.name);
      if (!Number.isFinite(borrowerId)) {
        return jsonResponse(400, { error: 'Invalid borrower id.' });
      }
      if (!aliasInput) {
        return jsonResponse(400, { error: 'Alias is required.' });
      }
      if (aliasInput.length > 120) {
        return jsonResponse(400, { error: 'Alias must be 120 characters or fewer.' });
      }
      const existing = sqlite.getCustomer(db, borrowerId);
      if (!existing) {
        return jsonResponse(404, { error: 'Borrower not found.' });
      }
      try {
        const alias = sqlite.createCustomerAlias(db, borrowerId, aliasInput);
        return jsonResponse(201, alias);
      } catch (err) {
        if (err?.message?.includes('UNIQUE')) {
          return jsonResponse(409, { error: 'Alias already exists for this customer.' });
        }
        throw err;
      }
    }

    if (path.match(/^\/api\/customers\/\d+\/aliases\/\d+$/) && method === 'DELETE') {
      const borrowerId = Number.parseInt(path.split('/')[3], 10);
      const aliasId = Number.parseInt(path.split('/')[5], 10);
      if (!Number.isFinite(borrowerId) || !Number.isFinite(aliasId)) {
        return jsonResponse(400, { error: 'Invalid identifier.' });
      }
      try {
        sqlite.deleteCustomerAlias(db, borrowerId, aliasId);
      } catch (err) {
        if (err?.message?.includes('Alias not found')) {
          return jsonResponse(404, { error: 'Alias not found.' });
        }
        throw err;
      }
      return jsonResponse(200, { success: true });
    }

    if (path.match(/^\/api\/customers\/\d+$/) && method === 'DELETE') {
      const borrowerId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(borrowerId)) {
        return jsonResponse(400, { error: 'Invalid customer id.' });
      }
      try {
        sqlite.deleteCustomer(db, borrowerId);
      } catch (err) {
        if (err?.message?.includes('existing loan or service history')) {
          return jsonResponse(409, { error: err.message });
        }
        if (err?.message?.includes('Customer not found')) {
          return jsonResponse(404, { error: 'Customer not found.' });
        }
        throw err;
      }
      return jsonResponse(200, { success: true });
    }

    if (method === 'GET' && path === '/api/items') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const search = normalizeString(url.searchParams.get('search') || url.searchParams.get('q') || url.searchParams.get('query'));
      return jsonResponse(200, { entries: sqlite.listItems(db, { search: search || null }) });
    }

    if (method === 'GET' && path === '/api/items/due-preview') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const raw = url.searchParams.get('item') || url.searchParams.get('q') || '';
      const itemQuery = normalizeString(raw);
      if (!itemQuery) {
        return jsonResponse(200, { message: 'Provide an item to preview.' });
      }
      const itemId = sqlite.findItemId(db, itemQuery);
      if (!itemId) {
        return jsonResponse(200, { message: 'Item not found.' });
      }
      const dueInfo = sqlite.resolveItemDue(db, itemId);
      if (!dueInfo) {
        return jsonResponse(200, { message: 'No due policy configured for this item.', itemId });
      }
      return jsonResponse(200, {
        itemId,
        itemName: dueInfo.itemName || null,
        dueUtc: dueInfo.dueUtc,
        policy: dueInfo.policy,
        policyDescription: dueInfo.description
      });
    }

    if (method === 'POST' && path === '/api/loans/checkout') {
      const { item, notes } = payload || {};
      if (!item) {
        return jsonResponse(400, { error: 'Item is required.' });
      }
      const borrowerId = sqlite.findBorrowerId(db, payload || {});
      if (!borrowerId) {
        return jsonResponse(404, { error: 'Borrower not found.' });
      }
      const itemId = sqlite.findItemId(db, item);
      if (!itemId) {
        return jsonResponse(404, { error: 'Item not found.' });
      }
      const dueInfo = sqlite.resolveItemDue(db, itemId);
      const userId = resolveLabTechIdForLoans(db, user);
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
        return jsonResponse(201, {
          loanId,
          traceNumber,
          dueUtc: dueInfo?.dueUtc ?? null,
          dueDescription: dueInfo?.description ?? null,
          duePolicy: dueInfo?.policy ?? null
        });
      } catch (err) {
        if (err?.message?.includes('already checked out')) {
          return jsonResponse(409, { error: 'Item is already checked out.' });
        }
        throw err;
      }
    }

    if (method === 'POST' && path === '/api/tickets') {
      const { item, issue } = payload || {};
      const issueText = normalizeString(issue);
      if (!item || !issueText) {
        return jsonResponse(400, { error: 'Item and issue are required.' });
      }
      const borrowerId = sqlite.findBorrowerId(db, payload || {});
      const itemId = sqlite.findItemId(db, item);
      const ticketLabel = itemId ? null : normalizeString(item);
      const publicId = sqlite.generatePublicTicketId(db);
      const userId = resolveLabTechIdForLoans(db, user);
      const result = sqlite.createServiceTicket(db, {
        publicId,
        borrowerId,
        itemId,
        itemLabel: ticketLabel,
        issue: issueText,
        assignedLabTechId: userId,
        status: 'Diagnosing'
      });
      return jsonResponse(201, result);
    }

    if (method === 'POST' && path === '/api/items') {
      const { name, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue } = payload || {};
      const itemName = normalizeString(name);
      if (!itemName) {
        return jsonResponse(400, { error: 'Item name is required.' });
      }
      const normalizedPolicy = normalizeDuePolicy(duePolicy);
      if (!ITEM_DUE_POLICY_SET.has(normalizedPolicy)) {
        return jsonResponse(400, { error: `Unsupported due policy: ${normalizedPolicy}` });
      }
      const departmentId = sqlite.ensureDepartmentId(db, department);
      try {
        const itemId = sqlite.createItem(db, {
          name: itemName,
          departmentId,
          schoolOwned: schoolOwned !== false,
          description: normalizeString(description) || null,
          duePolicy: normalizedPolicy,
          offsetDays,
          offsetHours,
          dueTime,
          fixedDue
        });
        return jsonResponse(201, { itemId });
      } catch (err) {
        if (err?.message?.includes('UNIQUE')) {
          return jsonResponse(409, { error: 'An item with that name already exists.' });
        }
        throw err;
      }
    }

    if (path.match(/^\/api\/items\/\d+$/) && method === 'GET') {
      const itemId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(itemId)) {
        return jsonResponse(400, { error: 'Invalid item id.' });
      }
      const row = sqlite.getItem(db, itemId);
      if (!row) {
        return jsonResponse(404, { error: 'Item not found.' });
      }
      const dueInfo = sqlite.resolveItemDue(db, itemId);
      return jsonResponse(200, mapItemRow(row, dueInfo));
    }

    if (path.match(/^\/api\/items\/\d+$/) && method === 'PUT') {
      const itemId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(itemId)) {
        return jsonResponse(400, { error: 'Invalid item id.' });
      }
      const { name, department, schoolOwned, description, duePolicy, offsetDays, offsetHours, dueTime, fixedDue } = payload || {};
      const itemName = normalizeString(name);
      if (!itemName) {
        return jsonResponse(400, { error: 'Item name is required.' });
      }
      const normalizedPolicy = normalizeDuePolicy(duePolicy);
      if (!ITEM_DUE_POLICY_SET.has(normalizedPolicy)) {
        return jsonResponse(400, { error: `Unsupported due policy: ${normalizedPolicy}` });
      }
      const existing = sqlite.getItem(db, itemId);
      if (!existing) {
        return jsonResponse(404, { error: 'Item not found.' });
      }
      const departmentId = sqlite.ensureDepartmentId(db, department);
      try {
        const updated = sqlite.updateItem(db, itemId, {
          name: itemName,
          departmentId,
          schoolOwned: schoolOwned !== false,
          description: normalizeString(description) || null,
          duePolicy: normalizedPolicy,
          offsetDays,
          offsetHours,
          dueTime,
          fixedDue
        });
        const dueInfo = sqlite.resolveItemDue(db, itemId);
        return jsonResponse(200, mapItemRow(updated, dueInfo));
      } catch (err) {
        if (err?.message?.includes('UNIQUE')) {
          return jsonResponse(409, { error: 'An item with that name already exists.' });
        }
        throw err;
      }
    }

    if (path.match(/^\/api\/items\/\d+$/) && method === 'DELETE') {
      const itemId = Number.parseInt(path.split('/')[3], 10);
      if (!Number.isFinite(itemId)) {
        return jsonResponse(400, { error: 'Invalid item id.' });
      }
      try {
        sqlite.deleteItem(db, itemId);
      } catch (err) {
        if (err?.message?.includes('foreign key') || err?.message?.includes('existing loan or service history')) {
          return jsonResponse(409, { error: 'Cannot delete item that is referenced by loans or tickets.' });
        }
        if (err?.message?.includes('Item not found')) {
          return jsonResponse(404, { error: 'Item not found.' });
        }
        throw err;
      }
      return jsonResponse(200, { success: true });
    }

    if (method === 'POST' && path === '/api/status') {
      const { id, type, status, note } = payload || {};
      const statusText = normalizeString(status);
      if (!id || !type || !statusText) {
        return jsonResponse(400, { error: 'id, type, and status are required.' });
      }
      const userId = resolveLabTechIdForLoans(db, user);
      const trimmedNote = normalizeString(note) || null;

      if (type === 'Loan') {
        if (!LOAN_STATUS_SET.has(statusText)) {
          return jsonResponse(400, { error: `Unsupported loan status: ${statusText}` });
        }
        const loanId = Number.parseInt(id, 10);
        if (!Number.isFinite(loanId)) {
          return jsonResponse(400, { error: 'Invalid loan id.' });
        }
        const loan = sqlite.getLoanById(db, loanId);
        if (!loan) {
          return jsonResponse(404, { error: 'Loan not found.' });
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
        return jsonResponse(200, { success: true });
      }

      if (type === 'Service Ticket') {
        if (!TICKET_STATUS_SET.has(statusText)) {
          return jsonResponse(400, { error: `Unsupported service ticket status: ${statusText}` });
        }
        const ticketId = sqlite.resolveServiceTicketId(db, id);
        if (!ticketId) {
          return jsonResponse(404, { error: 'Service ticket not found.' });
        }
        sqlite.setServiceTicketStatus(db, ticketId, { status: statusText, labTechId: userId });
        if (trimmedNote) {
          sqlite.addServiceTicketNote(db, ticketId, { labTechId: userId, note: trimmedNote });
        }
        return jsonResponse(200, { success: true });
      }

      return jsonResponse(400, { error: `Unknown status type: ${type}` });
    }

    if (method === 'GET' && path === '/api/users') {
      const url = new URL(`http://local${path}${headers['x-query'] || ''}`);
      const search = normalizeString(url.searchParams.get('search') || url.searchParams.get('q') || url.searchParams.get('query'));
      const entries = sqlite.listUsers(db, { search: search || null }).map((entry) => ({
        ...entry,
        roleLabel: getUserRoleLabel(entry.role)
      }));
      return jsonResponse(200, { entries });
    }

    if (method === 'POST' && path === '/api/users') {
      const { username, display, role, password } = payload || {};
      const userName = normalizeString(username).toLowerCase();
      const displayName = normalizeString(display);
      const roleName = normalizeUserRole(role);
      if (!userName || !displayName || !roleName) {
        return jsonResponse(400, { error: 'Username, display, and a valid role are required.' });
      }
      const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
      if (!normalizedPassword) {
        return jsonResponse(400, { error: 'Password is required.' });
      }
      if (normalizedPassword.length < 8) {
        return jsonResponse(400, { error: 'Password must be at least 8 characters.' });
      }
      if (normalizedPassword.length > 255) {
        return jsonResponse(400, { error: 'Password must be 255 characters or fewer.' });
      }
      const cappedDisplayName = displayName.substring(0, 150);
      const [first, ...rest] = cappedDisplayName.split(/\s+/);
      const last = rest.length ? rest.join(' ') : cappedDisplayName;
      const firstLimited = first.substring(0, 50);
      const lastLimited = last.substring(0, 50);
      try {
        sqlite.createUser(db, {
          username: userName,
          displayName: cappedDisplayName,
          firstName: firstLimited || cappedDisplayName,
          lastName: lastLimited || cappedDisplayName,
          password: normalizedPassword,
          role: roleName,
          isActive: true
        });
      } catch (err) {
        if (err?.message?.includes('UNIQUE')) {
          return jsonResponse(409, { error: 'Username already exists.' });
        }
        throw err;
      }
      return jsonResponse(201, { username: userName });
    }

    if (path.match(/^\/api\/users\/.+$/) && method === 'PUT') {
      const username = normalizeString(path.split('/')[3]).toLowerCase();
      if (!username) {
        return jsonResponse(400, { error: 'Username required.' });
      }
      const { display, role, password } = payload || {};
      const displayName = normalizeString(display);
      const roleName = normalizeUserRole(role);
      if (!displayName || !roleName) {
        return jsonResponse(400, { error: 'Display and a valid role are required.' });
      }
      const normalizedPassword = typeof password === 'string' ? normalizeString(password) : '';
      if (normalizedPassword && normalizedPassword.length < 8) {
        return jsonResponse(400, { error: 'Password must be at least 8 characters.' });
      }
      if (normalizedPassword && normalizedPassword.length > 255) {
        return jsonResponse(400, { error: 'Password must be 255 characters or fewer.' });
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
          return jsonResponse(404, { error: 'User not found.' });
        }
        throw err;
      }
      const detail = sqlite.getUserByUsername(db, username);
      const mapped = detail ? { ...detail, roleLabel: getUserRoleLabel(detail.role) } : null;
      if (mapped) {
        updateSessionsForUser(mapped);
      }
      return jsonResponse(200, mapped);
    }

    if (path.match(/^\/api\/users\/.+$/) && method === 'DELETE') {
      const username = normalizeString(path.split('/')[3]).toLowerCase();
      if (!username) {
        return jsonResponse(400, { error: 'Username required.' });
      }
      const existing = sqlite.getUserByUsername(db, username);
      if (!existing) {
        return jsonResponse(404, { error: 'User not found.' });
      }
      try {
        sqlite.deleteUser(db, existing.id);
      } catch (err) {
        if (err?.message?.includes('historical activity')) {
          return jsonResponse(409, { error: 'Cannot delete user with historical activity. Clear related records first.' });
        }
        throw err;
      }
      invalidateSessionsForUser(existing.id);
      return jsonResponse(200, { success: true });
    }

    if (method === 'DELETE' && path === '/api/admin/audit-log') {
      sqlite.clearAuditLog(db);
      return jsonResponse(200, { success: true });
    }

    if (method === 'GET' && path === '/api/admin/db/tables') {
      return jsonResponse(200, { entries: sqlite.listTableNames(db) });
    }

    if (method === 'GET' && path.startsWith('/api/admin/db/tables/')) {
      const tableName = decodeURIComponent(path.split('/')[5] || '');
      if (!tableName) {
        return jsonResponse(400, { error: 'Table name is required.' });
      }
      try {
        const rows = sqlite.listTableRows(db, tableName, { limit: 200, offset: 0 });
        return jsonResponse(200, rows);
      } catch (err) {
        return jsonResponse(400, { error: err?.message || 'Unable to load table.' });
      }
    }

    if (method === 'PUT' && path.startsWith('/api/admin/db/tables/') && path.endsWith('/rows')) {
      const tableName = decodeURIComponent(path.split('/')[5] || '');
      if (!tableName) {
        return jsonResponse(400, { error: 'Table name is required.' });
      }
      try {
        sqlite.updateTableRow(db, tableName, {
          locator: payload?.locator || {},
          changes: payload?.changes || {}
        });
        const refreshed = sqlite.listTableRows(db, tableName, { limit: 200, offset: 0 });
        return jsonResponse(200, refreshed);
      } catch (err) {
        return jsonResponse(400, { error: err?.message || 'Unable to update row.' });
      }
    }

    if (method === 'POST' && path === '/api/admin/clear-database') {
      sqlite.clearDatabase(db);
      return jsonResponse(200, { success: true });
    }

    return jsonResponse(404, { error: 'Not found.' });
  };
}

module.exports = { createApiHandler };
