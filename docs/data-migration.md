# Data migration path (SQL Server → SQLite)

This guide provides a repeatable export/import flow to move data from SQL Server into SQLite for initial migration and testing. It includes **two options**:

- **Option A (recommended):** `bcp`/`sqlcmd` → CSV → SQLite `.import`
- **Option B:** Node.js script using `mssql` + `better-sqlite3`

Use whichever fits your tooling and environment.

---

## Option A — CSV export (bcp/sqlcmd) → SQLite import

### 1) Export SQL Server tables to CSV

> **Prereqs:** SQL Server `bcp` (and `sqlcmd` if needed) on your PATH.

Set a target export directory (example: `./exports`). Then run `bcp` for each table in dependency order.

```bash
# From PowerShell or bash (with bcp available)
mkdir -p exports

# Departments
bcp "SELECT * FROM dbLabCenter.dbo.TDepartments ORDER BY intDepartmentID" queryout exports/TDepartments.csv -c -t, -r\n -S localhost -T

# Lab techs
bcp "SELECT * FROM dbLabCenter.dbo.TLabTechs ORDER BY intLabTechID" queryout exports/TLabTechs.csv -c -t, -r\n -S localhost -T

# Borrowers
bcp "SELECT * FROM dbLabCenter.dbo.TBorrowers ORDER BY intBorrowerID" queryout exports/TBorrowers.csv -c -t, -r\n -S localhost -T

# Borrower aliases
bcp "SELECT * FROM dbLabCenter.dbo.TBorrowerAliases ORDER BY intBorrowerAliasID" queryout exports/TBorrowerAliases.csv -c -t, -r\n -S localhost -T

# Items
bcp "SELECT * FROM dbLabCenter.dbo.TItems ORDER BY intItemID" queryout exports/TItems.csv -c -t, -r\n -S localhost -T

# Item loans
bcp "SELECT * FROM dbLabCenter.dbo.TItemLoans ORDER BY intItemLoanID" queryout exports/TItemLoans.csv -c -t, -r\n -S localhost -T

# Item loan notes
bcp "SELECT * FROM dbLabCenter.dbo.TItemLoanNotes ORDER BY intItemLoanNoteID" queryout exports/TItemLoanNotes.csv -c -t, -r\n -S localhost -T

# Service tickets
bcp "SELECT * FROM dbLabCenter.dbo.TServiceTickets ORDER BY intServiceTicketID" queryout exports/TServiceTickets.csv -c -t, -r\n -S localhost -T

# Service ticket notes
bcp "SELECT * FROM dbLabCenter.dbo.TServiceTicketNotes ORDER BY intServiceTicketNoteID" queryout exports/TServiceTicketNotes.csv -c -t, -r\n -S localhost -T

# Audit log
bcp "SELECT * FROM dbLabCenter.dbo.TAuditLog ORDER BY intTraceID" queryout exports/TAuditLog.csv -c -t, -r\n -S localhost -T
```

> **Note:**
> - `-T` uses Windows Integrated Auth. Use `-U` and `-P` for SQL auth.
> - If commas appear in text fields, consider `-t"\t"` (tab) and adjust import settings.

### 2) Create SQLite schema

Use the DDL in `docs/sqlite-schema.md` to initialize a new SQLite database.

```bash
sqlite3 labcenter.db < docs/sqlite-schema.sql
```

> If you keep the DDL only in markdown, extract the SQL block into a `.sql` file before running the command.

### 3) Import CSV into SQLite

Import in FK-safe order (parents before children):

```bash
sqlite3 labcenter.db <<'SQL'
.mode csv
.separator ,

.import exports/TDepartments.csv TDepartments
.import exports/TLabTechs.csv TLabTechs
.import exports/TBorrowers.csv TBorrowers
.import exports/TBorrowerAliases.csv TBorrowerAliases
.import exports/TItems.csv TItems
.import exports/TItemLoans.csv TItemLoans
.import exports/TItemLoanNotes.csv TItemLoanNotes
.import exports/TServiceTickets.csv TServiceTickets
.import exports/TServiceTicketNotes.csv TServiceTicketNotes
.import exports/TAuditLog.csv TAuditLog
SQL
```

### 4) Verify counts

```bash
sqlite3 labcenter.db <<'SQL'
SELECT 'TDepartments', COUNT(*) FROM TDepartments;
SELECT 'TLabTechs', COUNT(*) FROM TLabTechs;
SELECT 'TBorrowers', COUNT(*) FROM TBorrowers;
SELECT 'TBorrowerAliases', COUNT(*) FROM TBorrowerAliases;
SELECT 'TItems', COUNT(*) FROM TItems;
SELECT 'TItemLoans', COUNT(*) FROM TItemLoans;
SELECT 'TItemLoanNotes', COUNT(*) FROM TItemLoanNotes;
SELECT 'TServiceTickets', COUNT(*) FROM TServiceTickets;
SELECT 'TServiceTicketNotes', COUNT(*) FROM TServiceTicketNotes;
SELECT 'TAuditLog', COUNT(*) FROM TAuditLog;
SQL
```

---

## Option B — Node.js migration script

If you prefer a scriptable flow inside the repo, use a Node.js script to pull from SQL Server and insert into SQLite.

### 1) Dependencies

```bash
npm install mssql better-sqlite3
```

### 2) Script outline (pseudo-code)

```js
// migrate.js (outline)
const sql = require('mssql');
const Database = require('better-sqlite3');

const sqlConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER || 'localhost',
  database: process.env.DB_NAME || 'dbLabCenter',
  options: { trustServerCertificate: true },
};

const sqlite = new Database('labcenter.db');

async function exportTable(tableName, orderBy) {
  const pool = await sql.connect(sqlConfig);
  const result = await pool.request().query(`SELECT * FROM dbo.${tableName} ORDER BY ${orderBy}`);
  return result.recordset;
}

function importTable(tableName, rows) {
  if (!rows.length) return;
  const columns = Object.keys(rows[0]);
  const placeholders = columns.map(() => '?').join(',');
  const stmt = sqlite.prepare(`INSERT INTO ${tableName} (${columns.join(',')}) VALUES (${placeholders})`);
  const insertMany = sqlite.transaction((batch) => {
    for (const row of batch) stmt.run(columns.map((c) => row[c]));
  });
  insertMany(rows);
}

(async () => {
  // follow FK order
  const tables = [
    ['TDepartments', 'intDepartmentID'],
    ['TLabTechs', 'intLabTechID'],
    ['TBorrowers', 'intBorrowerID'],
    ['TBorrowerAliases', 'intBorrowerAliasID'],
    ['TItems', 'intItemID'],
    ['TItemLoans', 'intItemLoanID'],
    ['TItemLoanNotes', 'intItemLoanNoteID'],
    ['TServiceTickets', 'intServiceTicketID'],
    ['TServiceTicketNotes', 'intServiceTicketNoteID'],
    ['TAuditLog', 'intTraceID'],
  ];

  for (const [table, orderBy] of tables) {
    const rows = await exportTable(table, orderBy);
    importTable(table, rows);
  }

  console.log('Migration complete');
  process.exit(0);
})();
```

### 3) Run the script

```bash
node migrate.js
```

---

## Data considerations

- **Identity values:** Preserve original IDs to keep foreign keys consistent.
- **Datetime formats:** Store all UTC timestamps as ISO-8601 strings.
- **Booleans:** Normalize to `0/1` in SQLite.
- **Constraints:** Load parent tables first to satisfy FKs.
- **Password hashing:** If you adopt app-layer hashing, you may need to re-hash passwords during import.

---

## Recommended order summary

1) Export (SQL Server) → CSV
2) Create SQLite schema
3) Import CSV into SQLite
4) Verify row counts + spot check critical tables
