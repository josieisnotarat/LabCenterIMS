const path = require('path');
const express = require('express');
const sql = require('mssql');

const app = express();
app.use(express.json());

const dbConfig = {
  user: 'sa',
  password: 'yourStrong(!)Password',
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
    itemNumber: row.snapItemNumber || null,
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

async function getDefaultLabTechId(pool){
  if(cachedLabTechId != null){
    return cachedLabTechId;
  }
  const result = await pool.request().query(`
    SELECT TOP (1) intLabTechID
    FROM dbo.TLabTechs
    WHERE blnIsActive = 1
    ORDER BY intLabTechID;
  `);
  const id = result.recordset?.[0]?.intLabTechID;
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
      WHERE strItemNumber = @Match OR strItemName = @Match
      ORDER BY CASE WHEN strItemNumber = @Match THEN 0 ELSE 1 END, intItemID DESC;
    `);
  if(exact.recordset?.length){
    return exact.recordset[0].intItemID;
  }

  const like = await pool.request()
    .input('Search', sql.NVarChar(120), `%${value}%`)
    .query(`
      SELECT TOP (1) intItemID
      FROM dbo.TItems
      WHERE strItemName LIKE @Search OR ISNULL(strItemNumber,'') LIKE @Search
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
    IF OBJECT_ID('dbo.TAppUsers','U') IS NULL
    BEGIN
      CREATE TABLE dbo.TAppUsers
      (
        strUsername    VARCHAR(120) NOT NULL PRIMARY KEY,
        strDisplayName VARCHAR(150) NOT NULL,
        strRole        VARCHAR(50)  NOT NULL,
        dtmCreated     DATETIME2(0) NOT NULL CONSTRAINT DF_TAppUsers_Created DEFAULT (SYSUTCDATETIME())
      );
    END;
  `);
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
    request.input('strFirstName', sql.VarChar(50), firstName);
    request.input('strLastName', sql.VarChar(50), lastName);
    request.input('strSchoolIDNumber', sql.VarChar(50), normalizeString(schoolId) || null);
    request.input('strPhoneNumber', sql.VarChar(25), normalizeString(phone) || null);
    request.input('strRoomNumber', sql.VarChar(25), normalizeString(room) || null);
    request.input('strInstructor', sql.VarChar(100), normalizeString(instructor) || null);
    request.input('intDepartmentID', sql.Int, departmentId ?? null);
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

app.post('/api/loans/checkout', asyncHandler(async (req, res) => {
  const { item, dueLocal, notes } = req.body || {};
  if(!item || !dueLocal){
    return res.status(400).json({ error: 'Item and due date are required.' });
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

  const dueDate = parseLocalDateTime(dueLocal);
  if(!dueDate){
    return res.status(400).json({ error: 'Invalid due date.' });
  }

  const labTechId = await getDefaultLabTechId(pool);

  const request = pool.request();
  request.input('intItemID', sql.Int, itemId);
  request.input('intBorrowerID', sql.Int, borrowerId);
  request.input('intCheckoutLabTechID', sql.Int, labTechId);
  request.input('dtmDueUTC', sql.DateTime2, dueDate);
  request.input('strCheckoutNotes', sql.VarChar(400), normalizeString(notes) || null);

  const result = await request.execute('dbo.usp_CheckoutItem');
  const loanId = result.recordset?.[0]?.intItemLoanID ?? null;
  const traceNumber = typeof loanId === 'number' ? loanId.toString().padStart(6, '0') : null;
  res.status(201).json({ loanId, traceNumber });
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
  request.input('strPublicTicketID', sql.VarChar(20), publicId);
  request.input('intBorrowerID', sql.Int, borrowerId ?? null);
  request.input('intItemID', sql.Int, itemId ?? null);
  request.input('strItemLabel', sql.VarChar(120), ticketLabel);
  request.input('strIssue', sql.VarChar(1000), issueText);
  request.input('intAssignedLabTechID', sql.Int, labTechId);

  const result = await request.execute('dbo.usp_ServiceTicketCreate');
  const ticketId = result.recordset?.[0]?.intServiceTicketID ?? null;
  res.status(201).json({ ticketId, publicId });
}));

const LOAN_STATUS_SET = new Set(['On Time', 'Overdue', 'Returned']);
const TICKET_STATUS_SET = new Set(['Diagnosing', 'Awaiting Parts', 'Ready for Pickup', 'Quarantined', 'Returned']);

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
      checkinReq.input('intCheckinLabTechID', sql.Int, labTechId);
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
        noteReq.input('intLabTechID', sql.Int, labTechId);
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
    const numericId = Number.parseInt(id, 10);
    const request = pool.request();
    request.input('TicketId', sql.Int, Number.isFinite(numericId) ? numericId : null);
    request.input('PublicId', sql.VarChar(20), normalizeString(id));
    const ticketResult = await request.query(`
      SELECT TOP (1) intServiceTicketID
      FROM dbo.TServiceTickets
      WHERE (@TicketId IS NOT NULL AND intServiceTicketID = @TicketId)
         OR (strPublicTicketID = @PublicId)
      ORDER BY intServiceTicketID DESC;
    `);
    if(!ticketResult.recordset?.length){
      return res.status(404).json({ error: 'Service ticket not found.' });
    }
    const ticketId = ticketResult.recordset[0].intServiceTicketID;

    const statusReq = pool.request();
    statusReq.input('intServiceTicketID', sql.Int, ticketId);
    statusReq.input('strStatus', sql.VarChar(30), statusText);
    statusReq.input('intLabTechID', sql.Int, labTechId);
    await statusReq.execute('dbo.usp_ServiceTicketSetStatus');

    if(trimmedNote){
      const noteReq = pool.request();
      noteReq.input('intServiceTicketID', sql.Int, ticketId);
      noteReq.input('intLabTechID', sql.Int, labTechId);
      noteReq.input('strNote', sql.VarChar(1000), trimmedNote);
      await noteReq.execute('dbo.usp_AddServiceTicketNote');
    }

    return res.json({ success: true });
  }

  return res.status(400).json({ error: `Unknown status type: ${type}` });
}));

app.post('/api/users', asyncHandler(async (req, res) => {
  const { username, display, role } = req.body || {};
  const user = normalizeString(username).toLowerCase();
  const displayName = normalizeString(display);
  const roleName = normalizeString(role).toLowerCase();
  if(!user || !displayName || !roleName){
    return res.status(400).json({ error: 'Username, display, and role are required.' });
  }

  await ensureUserTable(await getPool());
  const pool = await getPool();

  try {
    await pool.request()
      .input('Username', sql.VarChar(120), user)
      .input('Display', sql.VarChar(150), displayName)
      .input('Role', sql.VarChar(50), roleName)
      .query(`
        INSERT INTO dbo.TAppUsers(strUsername,strDisplayName,strRole)
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
      DELETE FROM dbo.TAppUsers WHERE strUsername = @Username;
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
