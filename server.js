const path = require('path');
const express = require('express');
const sql = require('mssql');
require('dotenv').config();

const app = express();
app.use(express.json());

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER || 'localhost',
  database: process.env.DB_NAME || 'dbLabCenter',
  port: Number.parseInt(process.env.DB_PORT || '1433', 10),
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_CERT !== 'false'
  },
  pool: {
    max: Number.parseInt(process.env.DB_POOL_MAX || '10', 10),
    min: 0,
    idleTimeoutMillis: Number.parseInt(process.env.DB_POOL_IDLE || '30000', 10)
  }
};

if(!dbConfig.user || !dbConfig.password){
  console.warn('Warning: DB_USER or DB_PASSWORD environment variables are not set.');
}

let pool;

async function getPool(){
  if(pool && pool.connected){
    return pool;
  }
  if(pool){
    try { await pool.close(); } catch { /* ignore */ }
  }
  pool = await new sql.ConnectionPool(dbConfig).connect();
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

const notImplemented = (req, res) => {
  res.status(501).json({ error: 'Not implemented in this demo API.' });
};

app.post('/api/customers', notImplemented);
app.post('/api/loans/checkout', notImplemented);
app.post('/api/tickets', notImplemented);
app.post('/api/status', notImplemented);
app.post('/api/users', notImplemented);
app.delete('/api/users/:username', notImplemented);

const staticDir = path.join(__dirname);
app.use(express.static(staticDir));
app.get('/', (req, res) => {
  res.sendFile(path.join(staticDir, 'LabCenterIMS.html'));
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal Server Error', detail: err.message });
});

const PORT = Number.parseInt(process.env.PORT || '3000', 10);
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
