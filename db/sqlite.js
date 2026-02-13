const Database = require('better-sqlite3');

const DEFAULT_DB_PATH = process.env.SQLITE_PATH || 'labcenter.db';

function openDatabase(path = DEFAULT_DB_PATH) {
  const db = new Database(path);
  db.pragma('foreign_keys = ON');
  return db;
}

function nowIso() {
  return new Date().toISOString();
}

function normalizeString(value) {
  if (typeof value !== 'string') return '';
  return value.trim();
}

function quoteIdentifier(value) {
  const normalized = normalizeString(value);
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(normalized)) {
    throw new Error('Invalid SQL identifier.');
  }
  return `"${normalized}"`;
}

function formatName(first, last) {
  return [first, last].filter(Boolean).join(' ').trim() || null;
}

function toIntOrNull(value) {
  if (value == null || value === '') return null;
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) ? parsed : null;
}

function toTimeParts(value) {
  if (!value) return null;
  if (typeof value === 'string') {
    const trimmed = value.trim();
    const match = trimmed.match(/^(\d{1,2})(?::(\d{1,2}))?(?::(\d{1,2})(?:\.\d{1,7})?)?$/);
    if (!match) return null;
    const [, h, m = '0', s = '0'] = match;
    const hour = Math.min(23, Math.max(0, Number.parseInt(h, 10) || 0));
    const minute = Math.min(59, Math.max(0, Number.parseInt(m, 10) || 0));
    const second = Math.min(59, Math.max(0, Number.parseInt(s, 10) || 0));
    return { hour, minute, second };
  }
  if (value instanceof Date) {
    return { hour: value.getHours(), minute: value.getMinutes(), second: value.getSeconds() };
  }
  if (typeof value === 'object' && value !== null) {
    const hour = toIntOrNull(value.hour);
    if (hour == null) return null;
    const minute = toIntOrNull(value.minute) ?? 0;
    const second = toIntOrNull(value.second) ?? 0;
    return { hour: Math.min(23, Math.max(0, hour)), minute: Math.min(59, Math.max(0, minute)), second: Math.min(59, Math.max(0, second)) };
  }
  return null;
}

function normalizeTimeForSql(value) {
  const parts = toTimeParts(value);
  if (!parts) return null;
  return `${parts.hour.toString().padStart(2, '0')}:${parts.minute.toString().padStart(2, '0')}:${parts.second.toString().padStart(2, '0')}`;
}

function computeDueFromPolicy(row) {
  if (!row) return null;
  const policy = (row.strDuePolicy || 'NEXT_DAY_6PM').toUpperCase();
  const now = new Date();
  let due = null;
  let description = '';

  if (policy === 'SEMESTER' || policy === 'FIXED') {
    if (row.dtmFixedDueLocal) {
      const fixed = new Date(row.dtmFixedDueLocal);
      if (!Number.isNaN(fixed.getTime())) {
        due = fixed;
        description = 'Semester due';
      } else {
        description = 'Semester due date not configured';
      }
    } else {
      description = 'Semester due date not configured';
    }
  } else {
    const days = Number.isInteger(row.intDueDaysOffset) ? row.intDueDaysOffset : (policy === 'NEXT_DAY_6PM' ? 1 : 0);
    const hours = Number.isInteger(row.intDueHoursOffset) ? row.intDueHoursOffset : 0;
    const timeParts = toTimeParts(row.tDueTime);
    const effectiveTime = timeParts || (policy === 'NEXT_DAY_6PM'
      ? { hour: 18, minute: 0, second: 0 }
      : null);
    due = new Date(now.getTime());
    if (days) due.setDate(due.getDate() + days);
    if (effectiveTime) {
      due.setHours(effectiveTime.hour, effectiveTime.minute, effectiveTime.second, 0);
    } else if (hours) {
      due.setHours(due.getHours() + hours);
    }
    if (policy === 'NEXT_DAY_6PM') {
      description = 'Next day at 6:00 PM';
    } else {
      description = 'Custom offset';
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

function addAuditLog(db, { labTechId = null, action, entity, entityPk = null, details = null }) {
  db.prepare(`
    INSERT INTO TAuditLog (dtmEventUTC, intLabTechID, strAction, strEntity, intEntityPK, strDetails)
    VALUES (?, ?, ?, ?, ?, ?)
  `).run(nowIso(), labTechId, action, entity, entityPk, details);
}

function mapUserRow(row) {
  if (!row) return null;
  return {
    id: row.intLabTechID ?? null,
    username: row.strUsername || null,
    displayName: row.strDisplayName || null,
    role: row.strRole || null,
    createdUtc: row.dtmCreated || null
  };
}

function findUserByCredentials(db, username, password) {
  const row = db.prepare(`
    SELECT intLabTechID, strUsername, strDisplayName, strRole, dtmCreated
    FROM TLabTechs
    WHERE blnIsActive = 1
      AND LOWER(strUsername) = ?
      AND strPassword = ?
    LIMIT 1;
  `).get(username.toLowerCase(), password);
  return mapUserRow(row);
}

function getUserByUsername(db, username) {
  const row = db.prepare(`
    SELECT intLabTechID, strUsername, strDisplayName, strRole, dtmCreated
    FROM TLabTechs
    WHERE LOWER(strUsername) = ?
    LIMIT 1;
  `).get(username.toLowerCase());
  return mapUserRow(row);
}

function getDashboardStats(db) {
  const startOfDay = new Date();
  startOfDay.setUTCHours(0, 0, 0, 0);
  const endOfDay = new Date(startOfDay.getTime());
  endOfDay.setUTCDate(endOfDay.getUTCDate() + 1);

  const result = db.prepare(`
    SELECT
      SUM(CASE WHEN dtmCheckinUTC IS NULL THEN 1 ELSE 0 END) AS outNow,
      SUM(CASE WHEN dtmCheckinUTC IS NULL AND dtmDueUTC >= ? AND dtmDueUTC < ? THEN 1 ELSE 0 END) AS dueToday,
      (SELECT COUNT(*) FROM TServiceTickets WHERE strStatus IN ('Diagnosing','Awaiting Parts','Ready for Pickup')) AS repairs,
      SUM(CASE WHEN dtmCheckinUTC IS NULL AND dtmDueUTC IS NOT NULL AND dtmDueUTC < ? THEN 1 ELSE 0 END) AS overdue
    FROM TItemLoans
  `).get(startOfDay.toISOString(), endOfDay.toISOString(), nowIso());

  return {
    outNow: result?.outNow ?? 0,
    dueToday: result?.dueToday ?? 0,
    repairs: result?.repairs ?? 0,
    overdue: result?.overdue ?? 0
  };
}

function getLoans(db, { status = null, search = null } = {}) {
  const searchTerm = normalizeString(search);
  const statusFilter = normalizeString(status);
  const like = searchTerm ? `%${searchTerm}%` : null;

  const rows = db.prepare(`
    WITH LoanCTE AS (
      SELECT
        intItemLoanID,
        intItemID,
        intBorrowerID,
        dtmCheckoutUTC,
        dtmDueUTC,
        dtmCheckinUTC,
        strCheckoutNotes,
        snapBorrowerFirstName,
        snapBorrowerLastName,
        snapSchoolIDNumber,
        snapRoomNumber,
        snapInstructor,
        snapItemName,
        snapDepartmentName,
        CASE
          WHEN dtmCheckinUTC IS NOT NULL THEN 'Returned'
          WHEN dtmDueUTC IS NOT NULL AND dtmDueUTC < ? THEN 'Overdue'
          ELSE 'On Time'
        END AS LoanStatus
      FROM TItemLoans
    )
    SELECT *
    FROM LoanCTE
    WHERE (
      ? IS NULL OR ? = '' OR
      LoanStatus = ? OR ? IN ('all', 'All')
    )
      AND (
        ? IS NULL OR ? = '' OR
        snapBorrowerFirstName LIKE ? OR
        snapBorrowerLastName LIKE ? OR
        snapSchoolIDNumber LIKE ? OR
        snapItemName LIKE ?
      )
    ORDER BY dtmCheckoutUTC DESC, intItemLoanID DESC;
  `).all(
    nowIso(),
    statusFilter || null,
    statusFilter || '',
    statusFilter || '',
    statusFilter || '',
    like,
    searchTerm || '',
    like,
    like,
    like,
    like
  );

  return rows.map((row) => ({
    id: row.intItemLoanID ?? null,
    traceNumber: row.intItemLoanID != null ? row.intItemLoanID.toString().padStart(6, '0') : null,
    itemId: row.intItemID ?? null,
    borrowerId: row.intBorrowerID ?? null,
    itemName: row.snapItemName || null,
    borrowerName: [row.snapBorrowerFirstName, row.snapBorrowerLastName].filter(Boolean).join(' ').trim() || null,
    borrowerSchoolId: row.snapSchoolIDNumber || null,
    room: row.snapRoomNumber || null,
    instructor: row.snapInstructor || null,
    department: row.snapDepartmentName || null,
    checkoutUtc: row.dtmCheckoutUTC || null,
    dueUtc: row.dtmDueUTC || null,
    checkinUtc: row.dtmCheckinUTC || null,
    status: row.LoanStatus || null
  }));
}

function getLoanNotes(db, loanId) {
  const rows = db.prepare(`
    SELECT n.intItemLoanNoteID, n.dtmNoteUTC, n.strNote,
           lt.strFirstName, lt.strLastName
    FROM TItemLoanNotes AS n
    LEFT JOIN TLabTechs AS lt ON lt.intLabTechID = n.intLabTechID
    WHERE n.intItemLoanID = ?
    ORDER BY n.dtmNoteUTC DESC;
  `).all(loanId);

  return rows.map((row) => ({
    id: row.intItemLoanNoteID ?? null,
    note: row.strNote || '',
    timestamp: row.dtmNoteUTC || null,
    author: [row.strFirstName, row.strLastName].filter(Boolean).join(' ').trim() || null
  }));
}

function getLoanById(db, loanId) {
  return db.prepare(`
    SELECT intItemLoanID, dtmDueUTC, dtmCheckinUTC, strCheckoutNotes,
           snapItemName, snapBorrowerFirstName, snapBorrowerLastName
    FROM TItemLoans
    WHERE intItemLoanID = ?;
  `).get(loanId);
}

function getServiceTickets(db, { status = null, search = null } = {}) {
  const searchTerm = normalizeString(search);
  const statusFilter = normalizeString(status);
  const like = searchTerm ? `%${searchTerm}%` : null;

  const rows = db.prepare(`
    WITH TicketCTE AS (
      SELECT
        st.intServiceTicketID,
        st.strPublicTicketID,
        st.intItemID,
        st.intBorrowerID,
        st.strItemLabel,
        st.strIssue,
        st.dtmLoggedUTC,
        st.intAssignedLabTechID,
        st.strStatus,
        st.snapRoomNumber,
        st.snapInstructor,
        st.snapDepartmentName,
        bt.strFirstName AS borrowerFirstName,
        bt.strLastName AS borrowerLastName,
        it.strItemName,
        lt.strFirstName AS assignedFirstName,
        lt.strLastName AS assignedLastName
      FROM TServiceTickets AS st
      LEFT JOIN TBorrowers AS bt ON bt.intBorrowerID = st.intBorrowerID
      LEFT JOIN TItems AS it ON it.intItemID = st.intItemID
      LEFT JOIN TLabTechs AS lt ON lt.intLabTechID = st.intAssignedLabTechID
    )
    SELECT *
    FROM TicketCTE
    WHERE (
      ? IS NULL OR ? = '' OR
      strStatus = ? OR ? IN ('all', 'All')
    )
      AND (
        ? IS NULL OR ? = '' OR
        strPublicTicketID LIKE ? OR
        COALESCE(strItemName, strItemLabel, '') LIKE ? OR
        COALESCE(borrowerFirstName, '') LIKE ? OR
        COALESCE(borrowerLastName, '') LIKE ? OR
        COALESCE(assignedFirstName, '') LIKE ? OR
        COALESCE(assignedLastName, '') LIKE ?
      )
    ORDER BY dtmLoggedUTC DESC, intServiceTicketID DESC;
  `).all(
    statusFilter || null,
    statusFilter || '',
    statusFilter || '',
    statusFilter || '',
    like,
    searchTerm || '',
    like,
    like,
    like,
    like,
    like,
    like
  );

  return rows.map((row) => ({
    id: row.intServiceTicketID ?? null,
    publicId: row.strPublicTicketID || null,
    itemId: row.intItemID ?? null,
    borrowerId: row.intBorrowerID ?? null,
    itemName: row.strItemName || row.strItemLabel || null,
    issue: row.strIssue || null,
    loggedUtc: row.dtmLoggedUTC || null,
    assignedName: [row.assignedFirstName, row.assignedLastName].filter(Boolean).join(' ').trim() || null,
    borrowerName: [row.borrowerFirstName, row.borrowerLastName].filter(Boolean).join(' ').trim() || null,
    room: row.snapRoomNumber || null,
    instructor: row.snapInstructor || null,
    department: row.snapDepartmentName || null,
    status: row.strStatus || null,
    loggedByName: [row.assignedFirstName, row.assignedLastName].filter(Boolean).join(' ').trim() || null
  }));
}

function getServiceTicketNotes(db, ticketId) {
  const rows = db.prepare(`
    SELECT n.intServiceTicketNoteID, n.dtmNoteUTC, n.strNote,
           lt.strFirstName, lt.strLastName
    FROM TServiceTicketNotes AS n
    LEFT JOIN TLabTechs AS lt ON lt.intLabTechID = n.intLabTechID
    WHERE n.intServiceTicketID = ?
    ORDER BY n.dtmNoteUTC DESC;
  `).all(ticketId);

  return rows.map((row) => ({
    id: row.intServiceTicketNoteID ?? null,
    note: row.strNote || '',
    timestamp: row.dtmNoteUTC || null,
    author: [row.strFirstName, row.strLastName].filter(Boolean).join(' ').trim() || null
  }));
}

function resolveServiceTicketId(db, identifier) {
  const numeric = Number.parseInt(identifier, 10);
  const row = db.prepare(`
    SELECT intServiceTicketID
    FROM TServiceTickets
    WHERE (intServiceTicketID = COALESCE(?, intServiceTicketID))
       OR (strPublicTicketID = ?)
    ORDER BY intServiceTicketID DESC
    LIMIT 1;
  `).get(Number.isFinite(numeric) ? numeric : null, normalizeString(identifier) || null);
  return row?.intServiceTicketID ?? null;
}

function findBorrowerId(db, payload) {
  if (!payload) return null;
  const rawId = payload.borrowerId ?? payload.intBorrowerID;
  if (rawId != null) {
    const borrowerId = Number.parseInt(rawId, 10);
    if (Number.isFinite(borrowerId)) {
      const exists = db.prepare(`SELECT intBorrowerID FROM TBorrowers WHERE intBorrowerID = ?`).get(borrowerId);
      if (exists) return borrowerId;
    }
  }

  const schoolId = normalizeString(payload.schoolId || payload.schoolID || payload.schoolIdNumber);
  if (schoolId) {
    const row = db.prepare(`
      SELECT intBorrowerID
      FROM TBorrowers
      WHERE strSchoolIDNumber = ?
      ORDER BY intBorrowerID DESC
      LIMIT 1;
    `).get(schoolId);
    if (row) return row.intBorrowerID;
  }

  const nameSource = payload.customerName || payload.name;
  if (nameSource) {
    const [first, ...rest] = normalizeString(nameSource).split(/\s+/);
    const last = rest.length ? rest.join(' ') : null;
    if (first && last) {
      const row = db.prepare(`
        SELECT intBorrowerID
        FROM TBorrowers
        WHERE strFirstName = ? AND strLastName = ?
        ORDER BY intBorrowerID DESC
        LIMIT 1;
      `).get(first, last);
      if (row) return row.intBorrowerID;
    }

    const aliasText = normalizeString(nameSource);
    if (aliasText) {
      const aliasExact = db.prepare(`
        SELECT intBorrowerID
        FROM TBorrowerAliases
        WHERE strAlias = ?
        ORDER BY intBorrowerAliasID DESC
        LIMIT 1;
      `).get(aliasText);
      if (aliasExact) return aliasExact.intBorrowerID;

      const aliasLike = db.prepare(`
        SELECT intBorrowerID
        FROM TBorrowerAliases
        WHERE strAlias LIKE ?
        ORDER BY intBorrowerAliasID DESC
        LIMIT 1;
      `).get(`%${aliasText}%`);
      if (aliasLike) return aliasLike.intBorrowerID;
    }

    const fuzzy = normalizeString(nameSource);
    if (fuzzy) {
      const row = db.prepare(`
        SELECT intBorrowerID
        FROM TBorrowers
        WHERE strFirstName LIKE ? OR strLastName LIKE ? OR COALESCE(strSchoolIDNumber,'') LIKE ?
        ORDER BY intBorrowerID DESC
        LIMIT 1;
      `).get(`%${fuzzy}%`, `%${fuzzy}%`, `%${fuzzy}%`);
      if (row) return row.intBorrowerID;
    }
  }

  return null;
}

function findItemId(db, raw) {
  const value = normalizeString(raw);
  if (!value) return null;
  const numeric = Number.parseInt(value, 10);
  if (Number.isFinite(numeric)) {
    const row = db.prepare(`SELECT intItemID FROM TItems WHERE intItemID = ?`).get(numeric);
    if (row) return row.intItemID;
  }

  const exact = db.prepare(`
    SELECT intItemID
    FROM TItems
    WHERE strItemName = ?
    ORDER BY intItemID DESC
    LIMIT 1;
  `).get(value);
  if (exact) return exact.intItemID;

  const like = db.prepare(`
    SELECT intItemID
    FROM TItems
    WHERE strItemName LIKE ?
    ORDER BY intItemID DESC
    LIMIT 1;
  `).get(`%${value}%`);
  if (like) return like.intItemID;

  return null;
}

function ensureDepartmentId(db, name) {
  const deptName = normalizeString(name);
  if (!deptName) return null;
  const existing = db.prepare(`
    SELECT intDepartmentID
    FROM TDepartments
    WHERE LOWER(strDepartmentName) = LOWER(?)
    LIMIT 1;
  `).get(deptName);
  if (existing) return existing.intDepartmentID;
  const info = db.prepare(`
    INSERT INTO TDepartments (strDepartmentName)
    VALUES (?);
  `).run(deptName);
  return info.lastInsertRowid;
}

function generatePublicTicketId(db) {
  const row = db.prepare(`
    SELECT strPublicTicketID
    FROM TServiceTickets
    WHERE strPublicTicketID LIKE 'S-%'
    ORDER BY CAST(SUBSTR(strPublicTicketID, 3) AS INTEGER) DESC, intServiceTicketID DESC
    LIMIT 1;
  `).get();
  const lastId = row?.strPublicTicketID;
  const lastNumber = lastId ? Number.parseInt(lastId.replace(/[^0-9]/g, ''), 10) : 0;
  const next = Number.isFinite(lastNumber) ? lastNumber + 1 : 1;
  return `S-${next.toString().padStart(4, '0')}`;
}

function searchBorrowers(db, { query, top = 8 }) {
  const term = normalizeString(query);
  if (!term || term.length < 2) return [];
  const like = `%${term}%`;

  const rows = db.prepare(`
    WITH Matches AS (
      SELECT
        b.intBorrowerID,
        b.strFirstName,
        b.strLastName,
        b.strSchoolIDNumber,
        NULL AS MatchedAlias,
        0 AS Priority,
        b.intBorrowerID AS SortId
      FROM TBorrowers AS b
      WHERE b.strFirstName LIKE ?
         OR b.strLastName LIKE ?
         OR (b.strFirstName || ' ' || b.strLastName) LIKE ?
         OR COALESCE(b.strSchoolIDNumber, '') LIKE ?

      UNION ALL

      SELECT
        b.intBorrowerID,
        b.strFirstName,
        b.strLastName,
        b.strSchoolIDNumber,
        a.strAlias AS MatchedAlias,
        1 AS Priority,
        a.intBorrowerAliasID AS SortId
      FROM TBorrowers AS b
      INNER JOIN TBorrowerAliases AS a ON a.intBorrowerID = b.intBorrowerID
      WHERE a.strAlias LIKE ?
    ), ranked AS (
      SELECT *,
             ROW_NUMBER() OVER (PARTITION BY intBorrowerID ORDER BY Priority, SortId DESC) AS rn
      FROM Matches
    )
    SELECT intBorrowerID, strFirstName, strLastName, strSchoolIDNumber, MatchedAlias
    FROM ranked
    WHERE rn = 1
    ORDER BY Priority, strLastName, strFirstName, intBorrowerID DESC
    LIMIT ?;
  `).all(like, like, like, like, like, top);

  return rows.map((row) => ({
    id: row.intBorrowerID ?? null,
    name: [row.strFirstName, row.strLastName].filter(Boolean).join(' ').trim() || null,
    schoolId: row.strSchoolIDNumber || null,
    alias: row.MatchedAlias || null
  }));
}

function listCustomers(db, { search = null } = {}) {
  const searchTerm = normalizeString(search);
  const like = searchTerm ? `%${searchTerm}%` : null;
  const rows = searchTerm
    ? db.prepare(`
        SELECT b.intBorrowerID,
               b.strFirstName,
               b.strLastName,
               b.strSchoolIDNumber,
               b.strPhoneNumber,
               b.dtmCreated
        FROM TBorrowers AS b
        WHERE b.strFirstName LIKE ?
           OR b.strLastName LIKE ?
           OR (b.strFirstName || ' ' || b.strLastName) LIKE ?
           OR COALESCE(b.strSchoolIDNumber,'') LIKE ?
           OR COALESCE(b.strPhoneNumber,'') LIKE ?
           OR EXISTS (
               SELECT 1
               FROM TBorrowerAliases AS a
               WHERE a.intBorrowerID = b.intBorrowerID
                 AND a.strAlias LIKE ?
           )
        ORDER BY b.strLastName, b.strFirstName, b.intBorrowerID DESC;
      `).all(like, like, like, like, like, like)
    : db.prepare(`
        SELECT b.intBorrowerID,
               b.strFirstName,
               b.strLastName,
               b.strSchoolIDNumber,
               b.strPhoneNumber,
               b.dtmCreated
        FROM TBorrowers AS b
        ORDER BY b.dtmCreated DESC, b.intBorrowerID DESC;
      `).all();

  const aliasRows = db.prepare(`
    SELECT intBorrowerAliasID, intBorrowerID, strAlias, dtmCreated
    FROM TBorrowerAliases
    WHERE intBorrowerID = ?
    ORDER BY strAlias;
  `);

  return rows.map((row) => ({
    id: row.intBorrowerID ?? null,
    firstName: row.strFirstName || null,
    lastName: row.strLastName || null,
    name: [row.strFirstName, row.strLastName].filter(Boolean).join(' ').trim() || null,
    schoolId: row.strSchoolIDNumber || null,
    phone: row.strPhoneNumber || null,
    createdUtc: row.dtmCreated || null,
    aliases: aliasRows.all(row.intBorrowerID).map((alias) => ({
      id: alias.intBorrowerAliasID ?? null,
      alias: alias.strAlias || '',
      createdUtc: alias.dtmCreated || null
    }))
  }));
}

function getCustomer(db, borrowerId) {
  const row = db.prepare(`
    SELECT b.intBorrowerID,
           b.strFirstName,
           b.strLastName,
           b.strSchoolIDNumber,
           b.strPhoneNumber,
           b.dtmCreated
    FROM TBorrowers AS b
    WHERE b.intBorrowerID = ?;
  `).get(borrowerId);

  if (!row) return null;

  const aliases = db.prepare(`
    SELECT intBorrowerAliasID, strAlias, dtmCreated
    FROM TBorrowerAliases
    WHERE intBorrowerID = ?
    ORDER BY strAlias;
  `).all(borrowerId);

  return {
    id: row.intBorrowerID ?? null,
    firstName: row.strFirstName || null,
    lastName: row.strLastName || null,
    name: [row.strFirstName, row.strLastName].filter(Boolean).join(' ').trim() || null,
    schoolId: row.strSchoolIDNumber || null,
    phone: row.strPhoneNumber || null,
    createdUtc: row.dtmCreated || null,
    aliases: aliases.map((alias) => ({
      id: alias.intBorrowerAliasID ?? null,
      alias: alias.strAlias || '',
      createdUtc: alias.dtmCreated || null
    }))
  };
}

function createBorrower(db, payload) {
  const info = db.prepare(`
    INSERT INTO TBorrowers (strFirstName, strLastName, strSchoolIDNumber, strPhoneNumber, dtmCreated)
    VALUES (?, ?, ?, ?, ?)
  `).run(
    payload.firstName,
    payload.lastName,
    payload.schoolId || null,
    payload.phone || null,
    nowIso()
  );

  addAuditLog(db, {
    action: 'BORROWER_CREATE',
    entity: 'TBorrowers',
    entityPk: info.lastInsertRowid,
    details: JSON.stringify({
      name: `${payload.firstName} ${payload.lastName}`.trim(),
      schoolId: payload.schoolId || ''
    })
  });

  return info.lastInsertRowid;
}

function createItem(db, payload) {
  const policy = (normalizeString(payload.duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  const days = toIntOrNull(payload.offsetDays);
  const hours = toIntOrNull(payload.offsetHours);
  const timeSql = normalizeTimeForSql(payload.dueTime);

  const info = db.prepare(`
    INSERT INTO TItems (
      strItemName,
      blnIsSchoolOwned,
      intDepartmentID,
      strDescription,
      strDuePolicy,
      intDueDaysOffset,
      intDueHoursOffset,
      tDueTime,
      dtmFixedDueLocal,
      blnIsActive,
      dtmCreated
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    payload.name,
    payload.schoolOwned === false ? 0 : 1,
    payload.departmentId || null,
    payload.description || null,
    policy,
    (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null,
    policy === 'OFFSET' ? hours : null,
    (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null,
    (policy === 'SEMESTER' || policy === 'FIXED') ? payload.fixedDue : null,
    1,
    nowIso()
  );

  addAuditLog(db, {
    action: 'ITEM_CREATE',
    entity: 'TItems',
    entityPk: info.lastInsertRowid,
    details: JSON.stringify({
      itemName: payload.name,
      schoolOwned: payload.schoolOwned !== false
    })
  });

  return info.lastInsertRowid;
}

function getItem(db, itemId) {
  return db.prepare(`
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
    FROM TItems AS i
    LEFT JOIN TDepartments AS d ON d.intDepartmentID = i.intDepartmentID
    WHERE i.intItemID = ?;
  `).get(itemId);
}

function resolveItemDue(db, itemId) {
  const item = getItem(db, itemId);
  if (!item) return null;
  return computeDueFromPolicy(item);
}

function listItems(db, { search = null } = {}) {
  const searchTerm = normalizeString(search);
  const like = searchTerm ? `%${searchTerm}%` : null;
  const rows = db.prepare(`
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
    FROM TItems AS i
    LEFT JOIN TDepartments AS d ON d.intDepartmentID = i.intDepartmentID
    ${searchTerm ? 'WHERE i.strItemName LIKE ? OR COALESCE(d.strDepartmentName,"") LIKE ?' : ''}
    ORDER BY i.strItemName ASC, i.intItemID ASC;
  `).all(...(searchTerm ? [like, like] : []));

  return rows.map((row) => ({
    id: row.intItemID ?? null,
    name: row.strItemName || null,
    department: row.strDepartmentName || null,
    schoolOwned: row.blnIsSchoolOwned ? true : false,
    description: row.strDescription || null,
    duePolicy: row.strDuePolicy || null,
    duePolicyDescription: computeDueFromPolicy(row)?.description || null,
    dueDaysOffset: Number.isInteger(row.intDueDaysOffset) ? row.intDueDaysOffset : null,
    dueHoursOffset: Number.isInteger(row.intDueHoursOffset) ? row.intDueHoursOffset : null,
    dueTime: row.tDueTime || null,
    fixedDueLocal: row.dtmFixedDueLocal || null,
    lastUpdatedUtc: row.dtmCreated || null
  }));
}

function updateItem(db, itemId, payload) {
  const policy = (normalizeString(payload.duePolicy) || 'NEXT_DAY_6PM').toUpperCase();
  const days = toIntOrNull(payload.offsetDays);
  const hours = toIntOrNull(payload.offsetHours);
  const timeSql = normalizeTimeForSql(payload.dueTime);

  const info = db.prepare(`
    UPDATE TItems
    SET strItemName = ?,
        blnIsSchoolOwned = ?,
        intDepartmentID = ?,
        strDescription = ?,
        strDuePolicy = ?,
        intDueDaysOffset = ?,
        intDueHoursOffset = ?,
        tDueTime = ?,
        dtmFixedDueLocal = ?
    WHERE intItemID = ?;
  `).run(
    payload.name,
    payload.schoolOwned === false ? 0 : 1,
    payload.departmentId || null,
    payload.description || null,
    policy,
    (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? days : null,
    policy === 'OFFSET' ? hours : null,
    (policy === 'OFFSET' || policy === 'NEXT_DAY_6PM') ? (timeSql || null) : null,
    (policy === 'SEMESTER' || policy === 'FIXED') ? payload.fixedDue : null,
    itemId
  );

  if (!info.changes) {
    throw new Error('Item not found.');
  }

  return getItem(db, itemId);
}

function deleteItem(db, itemId) {
  const info = db.prepare(`DELETE FROM TItems WHERE intItemID = ?`).run(itemId);
  if (!info.changes) {
    throw new Error('Item not found.');
  }
}

function createCustomerAlias(db, borrowerId, alias) {
  const info = db.prepare(`
    INSERT INTO TBorrowerAliases (intBorrowerID, strAlias, dtmCreated)
    VALUES (?, ?, ?)
  `).run(borrowerId, alias, nowIso());
  return {
    id: info.lastInsertRowid,
    alias,
    createdUtc: nowIso()
  };
}

function deleteCustomerAlias(db, borrowerId, aliasId) {
  const info = db.prepare(`
    DELETE FROM TBorrowerAliases
    WHERE intBorrowerAliasID = ? AND intBorrowerID = ?
  `).run(aliasId, borrowerId);
  if (!info.changes) {
    throw new Error('Alias not found.');
  }
}

function deleteCustomer(db, borrowerId) {
  const dependency = db.prepare(`
    SELECT
      (SELECT COUNT(*) FROM TItemLoans WHERE intBorrowerID = ?) AS LoanCount,
      (SELECT COUNT(*) FROM TServiceTickets WHERE intBorrowerID = ?) AS TicketCount;
  `).get(borrowerId, borrowerId);

  if ((dependency?.LoanCount ?? 0) > 0 || (dependency?.TicketCount ?? 0) > 0) {
    throw new Error('Cannot delete customer with existing loan or service history.');
  }

  const tx = db.transaction(() => {
    db.prepare(`DELETE FROM TBorrowerAliases WHERE intBorrowerID = ?`).run(borrowerId);
    const info = db.prepare(`DELETE FROM TBorrowers WHERE intBorrowerID = ?`).run(borrowerId);
    if (!info.changes) {
      throw new Error('Customer not found.');
    }
  });

  tx();
}

function checkoutItem(db, payload) {
  const item = db.prepare(`
    SELECT i.intItemID, i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName,
           i.strDuePolicy, i.intDueDaysOffset, i.intDueHoursOffset, i.tDueTime, i.dtmFixedDueLocal
    FROM TItems i
    LEFT JOIN TDepartments d ON d.intDepartmentID = i.intDepartmentID
    WHERE i.intItemID = ?;
  `).get(payload.itemId);

  if (!item) throw new Error('Item not found.');

  const borrower = db.prepare(`
    SELECT strFirstName, strLastName, strSchoolIDNumber, strPhoneNumber
    FROM TBorrowers
    WHERE intBorrowerID = ?;
  `).get(payload.borrowerId);

  if (!borrower) throw new Error('Borrower not found.');

  const isCheckedOut = db.prepare(`
    SELECT 1 FROM TItemLoans WHERE intItemID = ? AND dtmCheckinUTC IS NULL LIMIT 1;
  `).get(payload.itemId);

  if (isCheckedOut) throw new Error('Item is already checked out.');

  const dueInfo = computeDueFromPolicy(item);
  const dueUtc = payload.dueUtc || dueInfo?.dueUtc || null;

  const info = db.prepare(`
    INSERT INTO TItemLoans (
      intItemID,
      intBorrowerID,
      intCheckoutLabTechID,
      dtmCheckoutUTC,
      dtmDueUTC,
      strCheckoutNotes,
      snapBorrowerFirstName,
      snapBorrowerLastName,
      snapSchoolIDNumber,
      snapPhoneNumber,
      snapRoomNumber,
      snapInstructor,
      snapItemName,
      snapIsSchoolOwned,
      snapDepartmentName
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    payload.itemId,
    payload.borrowerId,
    payload.labTechId,
    nowIso(),
    dueUtc,
    payload.notes || null,
    borrower.strFirstName,
    borrower.strLastName,
    borrower.strSchoolIDNumber,
    borrower.strPhoneNumber,
    payload.room || null,
    payload.instructor || null,
    item.strItemName,
    item.blnIsSchoolOwned ? 1 : 0,
    payload.department || item.strDepartmentName || null
  );

  addAuditLog(db, {
    labTechId: payload.labTechId,
    action: 'CHECKOUT',
    entity: 'TItemLoans',
    entityPk: info.lastInsertRowid,
    details: JSON.stringify({
      item: item.strItemName,
      borrower: `${borrower.strFirstName} ${borrower.strLastName}`.trim(),
      checkoutUTC: nowIso(),
      dueUTC: dueUtc || ''
    })
  });

  return { loanId: info.lastInsertRowid, dueInfo };
}

function updateLoanDue(db, loanId, payload) {
  const info = db.prepare(`
    UPDATE TItemLoans
    SET dtmDueUTC = ?,
        strCheckoutNotes = ?
    WHERE intItemLoanID = ?;
  `).run(payload.dueUtc || null, payload.checkoutNotes || null, loanId);

  if (!info.changes) {
    throw new Error('Loan not found.');
  }
}

function checkinItem(db, loanId, payload) {
  const info = db.prepare(`
    UPDATE TItemLoans
    SET dtmCheckinUTC = ?,
        intCheckinLabTechID = ?,
        strCheckinNotes = ?
    WHERE intItemLoanID = ?
      AND dtmCheckinUTC IS NULL;
  `).run(nowIso(), payload.labTechId, payload.notes || null, loanId);

  if (!info.changes) {
    throw new Error('Loan not found or already checked in.');
  }

  const loan = db.prepare(`
    SELECT snapItemName, snapBorrowerFirstName, snapBorrowerLastName, dtmCheckinUTC
    FROM TItemLoans
    WHERE intItemLoanID = ?;
  `).get(loanId);

  addAuditLog(db, {
    labTechId: payload.labTechId,
    action: 'CHECKIN',
    entity: 'TItemLoans',
    entityPk: loanId,
    details: JSON.stringify({
      item: loan?.snapItemName || '',
      borrower: [loan?.snapBorrowerFirstName, loan?.snapBorrowerLastName].filter(Boolean).join(' ').trim(),
      checkinUTC: loan?.dtmCheckinUTC || ''
    })
  });
}

function addLoanNote(db, loanId, payload) {
  const info = db.prepare(`
    INSERT INTO TItemLoanNotes (intItemLoanID, intLabTechID, dtmNoteUTC, strNote)
    VALUES (?, ?, ?, ?)
  `).run(loanId, payload.labTechId || null, nowIso(), payload.note);

  addAuditLog(db, {
    labTechId: payload.labTechId,
    action: 'NOTE_ADD',
    entity: 'TItemLoans',
    entityPk: loanId,
    details: payload.note
  });

  return info.lastInsertRowid;
}

function createServiceTicket(db, payload) {
  const publicId = payload.publicId;
  const info = db.prepare(`
    INSERT INTO TServiceTickets (
      strPublicTicketID,
      intItemID,
      intBorrowerID,
      strItemLabel,
      strIssue,
      dtmLoggedUTC,
      intAssignedLabTechID,
      strStatus,
      snapRoomNumber,
      snapInstructor,
      snapDepartmentName
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    publicId,
    payload.itemId || null,
    payload.borrowerId || null,
    payload.itemLabel || null,
    payload.issue,
    nowIso(),
    payload.assignedLabTechId || null,
    payload.status || 'Diagnosing',
    payload.room || null,
    payload.instructor || null,
    payload.department || null
  );

  addAuditLog(db, {
    labTechId: payload.assignedLabTechId || null,
    action: 'TICKET_CREATE',
    entity: 'TServiceTickets',
    entityPk: info.lastInsertRowid,
    details: JSON.stringify({
      publicId,
      status: payload.status || 'Diagnosing'
    })
  });

  return { ticketId: info.lastInsertRowid, publicId };
}

function setServiceTicketStatus(db, ticketId, payload) {
  const info = db.prepare(`
    UPDATE TServiceTickets
    SET strStatus = ?
    WHERE intServiceTicketID = ?;
  `).run(payload.status, ticketId);

  if (!info.changes) {
    throw new Error('Service ticket not found.');
  }

  addAuditLog(db, {
    labTechId: payload.labTechId || null,
    action: 'TICKET_STATUS',
    entity: 'TServiceTickets',
    entityPk: ticketId,
    details: payload.status
  });
}

function addServiceTicketNote(db, ticketId, payload) {
  const info = db.prepare(`
    INSERT INTO TServiceTicketNotes (intServiceTicketID, intLabTechID, dtmNoteUTC, strNote)
    VALUES (?, ?, ?, ?)
  `).run(ticketId, payload.labTechId || null, nowIso(), payload.note);

  addAuditLog(db, {
    labTechId: payload.labTechId,
    action: 'NOTE_ADD',
    entity: 'TServiceTickets',
    entityPk: ticketId,
    details: payload.note
  });

  return info.lastInsertRowid;
}

function getAuditLog(db, { limit = 100 } = {}) {
  const rows = db.prepare(`
    SELECT a.intTraceID,
           a.dtmEventUTC,
           a.intLabTechID,
           lt.strFirstName,
           lt.strLastName,
           a.strAction,
           a.strEntity,
           a.intEntityPK,
           a.strDetails
    FROM TAuditLog AS a
    LEFT JOIN TLabTechs AS lt ON lt.intLabTechID = a.intLabTechID
    ORDER BY a.dtmEventUTC DESC
    LIMIT ?;
  `).all(limit);

  return rows.map((row) => ({
    intTraceID: row.intTraceID,
    dtmEventUTC: row.dtmEventUTC,
    intLabTechID: row.intLabTechID ?? null,
    strFirstName: row.strFirstName || null,
    strLastName: row.strLastName || null,
    strAction: row.strAction || null,
    strEntity: row.strEntity || null,
    intEntityPK: row.intEntityPK ?? null,
    strDetails: row.strDetails || null
  }));
}

function listUsers(db, { search = null } = {}) {
  const searchTerm = normalizeString(search);
  const like = searchTerm ? `%${searchTerm.toLowerCase()}%` : null;
  const rows = db.prepare(`
    SELECT intLabTechID, strUsername, strDisplayName, strRole, dtmCreated
    FROM TLabTechs
    ${searchTerm ? 'WHERE LOWER(strUsername) LIKE ? OR LOWER(strDisplayName) LIKE ? OR LOWER(strRole) LIKE ? OR LOWER(strFirstName) LIKE ? OR LOWER(strLastName) LIKE ?' : ''}
    ORDER BY strUsername ASC;
  `).all(...(searchTerm ? [like, like, like, like, like] : []));

  return rows.map((row) => ({
    id: row.intLabTechID ?? null,
    username: row.strUsername || null,
    displayName: row.strDisplayName || null,
    role: row.strRole || null,
    createdUtc: row.dtmCreated || null
  }));
}

function createUser(db, payload) {
  const info = db.prepare(`
    INSERT INTO TLabTechs (strUsername, strDisplayName, strFirstName, strLastName, strEmail, strPassword, strRole, blnIsActive, dtmCreated)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    payload.username,
    payload.displayName,
    payload.firstName,
    payload.lastName,
    payload.email || null,
    payload.password,
    payload.role,
    payload.isActive ? 1 : 0,
    nowIso()
  );

  return info.lastInsertRowid;
}

function updateUser(db, username, payload) {
  const info = db.prepare(`
    UPDATE TLabTechs
    SET strDisplayName = ?,
        strFirstName = ?,
        strLastName = ?,
        strRole = ?,
        strPassword = COALESCE(?, strPassword)
    WHERE strUsername = ?;
  `).run(
    payload.displayName,
    payload.firstName,
    payload.lastName,
    payload.role,
    payload.password || null,
    username
  );

  if (!info.changes) {
    throw new Error('User not found.');
  }
}

function deleteUser(db, userId) {
  const dependency = db.prepare(`
    SELECT
      (SELECT COUNT(*) FROM TItemLoans WHERE intCheckoutLabTechID = ? OR intCheckinLabTechID = ?) AS LoanCount,
      (SELECT COUNT(*) FROM TItemLoanNotes WHERE intLabTechID = ?) AS LoanNoteCount,
      (SELECT COUNT(*) FROM TServiceTickets WHERE intAssignedLabTechID = ?) AS TicketCount,
      (SELECT COUNT(*) FROM TServiceTicketNotes WHERE intLabTechID = ?) AS TicketNoteCount,
      (SELECT COUNT(*) FROM TAuditLog WHERE intLabTechID = ?) AS AuditCount;
  `).get(userId, userId, userId, userId, userId, userId);

  const total = (dependency?.LoanCount ?? 0) +
    (dependency?.LoanNoteCount ?? 0) +
    (dependency?.TicketCount ?? 0) +
    (dependency?.TicketNoteCount ?? 0) +
    (dependency?.AuditCount ?? 0);

  if (total > 0) {
    throw new Error('Cannot delete user with historical activity.');
  }

  const info = db.prepare(`DELETE FROM TLabTechs WHERE intLabTechID = ?`).run(userId);
  if (!info.changes) {
    throw new Error('User not found.');
  }
}

function clearAuditLog(db) {
  db.prepare(`DELETE FROM TAuditLog`).run();
}

function clearDatabase(db) {
  const tx = db.transaction(() => {
    const admin = db.prepare(`
      SELECT intLabTechID
      FROM TLabTechs
      WHERE strRole = 'admin'
      ORDER BY intLabTechID ASC
      LIMIT 1;
    `).get();
    const adminId = admin?.intLabTechID ?? null;

    db.prepare(`DELETE FROM TItemLoanNotes`).run();
    db.prepare(`DELETE FROM TItemLoans`).run();
    db.prepare(`DELETE FROM TServiceTicketNotes`).run();
    db.prepare(`DELETE FROM TServiceTickets`).run();
    db.prepare(`DELETE FROM TBorrowerAliases`).run();
    db.prepare(`DELETE FROM TBorrowers`).run();
    db.prepare(`DELETE FROM TItems`).run();
    if (adminId != null) {
      db.prepare(`DELETE FROM TLabTechs WHERE intLabTechID <> ?`).run(adminId);
    } else {
      db.prepare(`DELETE FROM TLabTechs`).run();
    }
    db.prepare(`DELETE FROM TAuditLog`).run();
    db.prepare(`DELETE FROM TDepartments`).run();
  });

  tx();
}

function listTableNames(db) {
  const rows = db.prepare(`
    SELECT name
    FROM sqlite_master
    WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
    ORDER BY name ASC;
  `).all();
  return rows.map((row) => row.name).filter(Boolean);
}

function getTableSchema(db, tableName) {
  const quoted = quoteIdentifier(tableName);
  const rows = db.prepare(`PRAGMA table_info(${quoted});`).all();
  return rows.map((row) => ({
    name: row.name,
    type: row.type || null,
    notNull: row.notnull === 1,
    defaultValue: row.dflt_value ?? null,
    primaryKeyOrdinal: row.pk || 0
  }));
}

function listTableRows(db, tableName, { limit = 200, offset = 0 } = {}) {
  const quoted = quoteIdentifier(tableName);
  const normalizedLimit = Number.isFinite(limit) ? Math.max(1, Math.min(500, Math.trunc(limit))) : 200;
  const normalizedOffset = Number.isFinite(offset) ? Math.max(0, Math.trunc(offset)) : 0;
  const schema = getTableSchema(db, tableName);
  const pkColumns = schema.filter((column) => column.primaryKeyOrdinal > 0)
    .sort((a, b) => a.primaryKeyOrdinal - b.primaryKeyOrdinal)
    .map((column) => column.name);
  const rows = db.prepare(`SELECT rowid AS __rowid__, * FROM ${quoted} LIMIT ? OFFSET ?;`).all(normalizedLimit, normalizedOffset);
  const entries = rows.map((row) => {
    const locator = {};
    if (row.__rowid__ != null) {
      locator.rowid = row.__rowid__;
    }
    pkColumns.forEach((name) => {
      locator[name] = row[name] ?? null;
    });
    return {
      values: row,
      locator
    };
  });
  return { schema, entries, limit: normalizedLimit, offset: normalizedOffset };
}

function buildLocatorWhereClause(locator) {
  const keys = Object.keys(locator || {});
  if (!keys.length) {
    throw new Error('Row locator is required.');
  }
  const whereParts = [];
  const params = [];
  keys.forEach((key) => {
    if (key === 'rowid') {
      const rowId = Number.parseInt(locator.rowid, 10);
      if (!Number.isFinite(rowId)) {
        throw new Error('Invalid row locator.');
      }
      whereParts.push('rowid = ?');
      params.push(rowId);
      return;
    }
    const quoted = quoteIdentifier(key);
    const value = locator[key];
    if (value == null) {
      whereParts.push(`${quoted} IS NULL`);
    } else {
      whereParts.push(`${quoted} = ?`);
      params.push(value);
    }
  });
  return { whereClause: whereParts.join(' AND '), params };
}

function updateTableRow(db, tableName, { locator, changes }) {
  const quotedTable = quoteIdentifier(tableName);
  const schema = getTableSchema(db, tableName);
  const columnNames = new Set(schema.map((column) => column.name));
  const changeKeys = Object.keys(changes || {}).filter((key) => columnNames.has(key));
  if (!changeKeys.length) {
    throw new Error('No valid columns were provided to update.');
  }
  const assignments = [];
  const params = [];
  changeKeys.forEach((key) => {
    assignments.push(`${quoteIdentifier(key)} = ?`);
    params.push(changes[key]);
  });
  const locatorInfo = buildLocatorWhereClause(locator || {});
  const statement = `UPDATE ${quotedTable} SET ${assignments.join(', ')} WHERE ${locatorInfo.whereClause};`;
  const result = db.prepare(statement).run(...params, ...locatorInfo.params);
  if (!result.changes) {
    throw new Error('Row not found.');
  }
}

module.exports = {
  openDatabase,
  addAuditLog,
  findUserByCredentials,
  getUserByUsername,
  getDashboardStats,
  getLoans,
  getLoanNotes,
  getLoanById,
  getServiceTickets,
  getServiceTicketNotes,
  resolveServiceTicketId,
  searchBorrowers,
  findBorrowerId,
  listCustomers,
  getCustomer,
  createBorrower,
  createCustomerAlias,
  deleteCustomerAlias,
  deleteCustomer,
  ensureDepartmentId,
  findItemId,
  generatePublicTicketId,
  listItems,
  getItem,
  resolveItemDue,
  createItem,
  updateItem,
  deleteItem,
  checkoutItem,
  updateLoanDue,
  checkinItem,
  addLoanNote,
  createServiceTicket,
  setServiceTicketStatus,
  addServiceTicketNote,
  getAuditLog,
  listUsers,
  createUser,
  updateUser,
  deleteUser,
  clearAuditLog,
  clearDatabase,
  listTableNames,
  listTableRows,
  updateTableRow
};
