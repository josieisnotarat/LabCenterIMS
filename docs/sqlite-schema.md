# SQLite schema translation (draft)

This document translates the current SQL Server schema in `LabCenterDatabase.sql` into SQLite-compatible DDL and highlights SQL Server-only features (procedures, triggers, views) that must move into the app layer or be re-implemented with SQLite triggers.

> **SQLite assumptions**
> - Use `INTEGER PRIMARY KEY AUTOINCREMENT` for SQL Server `INT IDENTITY(1,1)`.
> - Use `TEXT` for `VARCHAR/NVARCHAR`.
> - Use `INTEGER` for booleans (`0/1`).
> - Use `DATETIME` (TEXT in ISO-8601) for `DATETIME2` values.
> - Enable foreign keys: `PRAGMA foreign_keys = ON;`

## Core tables (SQLite DDL)

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS TDepartments (
  intDepartmentID   INTEGER PRIMARY KEY AUTOINCREMENT,
  strDepartmentName TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS TLabTechs (
  intLabTechID    INTEGER PRIMARY KEY AUTOINCREMENT,
  strUsername     TEXT NOT NULL UNIQUE,
  strDisplayName  TEXT NOT NULL,
  strFirstName    TEXT NOT NULL,
  strLastName     TEXT NOT NULL,
  strEmail        TEXT,
  strPhoneNumber  TEXT,
  strPassword     TEXT NOT NULL,
  strRole         TEXT NOT NULL,
  blnIsActive     INTEGER NOT NULL DEFAULT 1,
  dtmCreated      DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  CHECK (strRole IN ('admin','co-op'))
);

CREATE TABLE IF NOT EXISTS TBorrowers (
  intBorrowerID     INTEGER PRIMARY KEY AUTOINCREMENT,
  strFirstName      TEXT NOT NULL,
  strLastName       TEXT NOT NULL,
  strSchoolIDNumber TEXT,
  strPhoneNumber    TEXT,
  strRoomNumber     TEXT,
  strInstructor     TEXT,
  intDepartmentID   INTEGER REFERENCES TDepartments(intDepartmentID),
  strBorrowerType   TEXT,
  dtmCreated        DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
CREATE INDEX IF NOT EXISTS IX_TBorrowers_Name ON TBorrowers(strLastName, strFirstName);
CREATE INDEX IF NOT EXISTS IX_TBorrowers_SchoolID ON TBorrowers(strSchoolIDNumber);
CREATE UNIQUE INDEX IF NOT EXISTS UQ_TBorrowers_SchoolID
  ON TBorrowers(strSchoolIDNumber)
  WHERE strSchoolIDNumber IS NOT NULL;

CREATE TABLE IF NOT EXISTS TBorrowerAliases (
  intBorrowerAliasID INTEGER PRIMARY KEY AUTOINCREMENT,
  intBorrowerID      INTEGER NOT NULL REFERENCES TBorrowers(intBorrowerID) ON DELETE CASCADE,
  strAlias           TEXT NOT NULL,
  dtmCreated         DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  UNIQUE (intBorrowerID, strAlias)
);
CREATE INDEX IF NOT EXISTS IX_TBorrowerAliases_Alias ON TBorrowerAliases(strAlias);

CREATE TABLE IF NOT EXISTS TItems (
  intItemID         INTEGER PRIMARY KEY AUTOINCREMENT,
  strItemName       TEXT NOT NULL,
  blnIsSchoolOwned  INTEGER NOT NULL,
  intDepartmentID   INTEGER REFERENCES TDepartments(intDepartmentID),
  strDescription    TEXT,
  strDuePolicy      TEXT NOT NULL DEFAULT 'NEXT_DAY_6PM',
  intDueDaysOffset  INTEGER,
  intDueHoursOffset INTEGER,
  tDueTime          TEXT,
  dtmFixedDueLocal  DATETIME,
  blnIsActive       INTEGER NOT NULL DEFAULT 1,
  dtmCreated        DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  CHECK (strDuePolicy IN ('NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER'))
);
CREATE INDEX IF NOT EXISTS IX_TItems_Name ON TItems(strItemName);

CREATE TABLE IF NOT EXISTS TItemLoans (
  intItemLoanID        INTEGER PRIMARY KEY AUTOINCREMENT,
  intItemID            INTEGER NOT NULL REFERENCES TItems(intItemID),
  intBorrowerID        INTEGER NOT NULL REFERENCES TBorrowers(intBorrowerID),
  intCheckoutLabTechID INTEGER NOT NULL REFERENCES TLabTechs(intLabTechID),
  dtmCheckoutUTC       DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  dtmDueUTC            DATETIME,
  strCheckoutNotes     TEXT,
  dtmCheckinUTC        DATETIME,
  intCheckinLabTechID  INTEGER REFERENCES TLabTechs(intLabTechID),
  strCheckinNotes      TEXT,
  snapBorrowerFirstName TEXT NOT NULL,
  snapBorrowerLastName  TEXT NOT NULL,
  snapSchoolIDNumber    TEXT,
  snapPhoneNumber       TEXT,
  snapRoomNumber        TEXT,
  snapInstructor        TEXT,
  snapItemName          TEXT NOT NULL,
  snapIsSchoolOwned     INTEGER NOT NULL,
  snapDepartmentName    TEXT,
  CHECK (dtmCheckinUTC IS NULL OR dtmCheckinUTC >= dtmCheckoutUTC)
);
CREATE INDEX IF NOT EXISTS IX_TItemLoans_Item ON TItemLoans(intItemID, dtmCheckinUTC);
CREATE INDEX IF NOT EXISTS IX_TItemLoans_Borrower ON TItemLoans(intBorrowerID, dtmCheckinUTC);
CREATE INDEX IF NOT EXISTS IX_TItemLoans_CheckoutTime ON TItemLoans(dtmCheckoutUTC);
CREATE INDEX IF NOT EXISTS IX_TItemLoans_DueTime ON TItemLoans(dtmDueUTC);
CREATE INDEX IF NOT EXISTS IX_TItemLoans_Status ON TItemLoans(dtmCheckinUTC, dtmDueUTC);

CREATE TABLE IF NOT EXISTS TItemLoanNotes (
  intItemLoanNoteID INTEGER PRIMARY KEY AUTOINCREMENT,
  intItemLoanID     INTEGER NOT NULL REFERENCES TItemLoans(intItemLoanID),
  intLabTechID      INTEGER REFERENCES TLabTechs(intLabTechID),
  dtmNoteUTC        DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  strNote           TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS IX_TItemLoanNotes_Loan ON TItemLoanNotes(intItemLoanID, dtmNoteUTC DESC);

CREATE TABLE IF NOT EXISTS TServiceTickets (
  intServiceTicketID  INTEGER PRIMARY KEY AUTOINCREMENT,
  strPublicTicketID   TEXT NOT NULL UNIQUE,
  intItemID           INTEGER REFERENCES TItems(intItemID),
  intBorrowerID       INTEGER REFERENCES TBorrowers(intBorrowerID),
  strItemLabel        TEXT,
  strIssue            TEXT NOT NULL,
  dtmLoggedUTC        DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  intAssignedLabTechID INTEGER REFERENCES TLabTechs(intLabTechID),
  strStatus           TEXT NOT NULL DEFAULT 'Diagnosing',
  CHECK (strStatus IN ('Diagnosing','Awaiting Parts','Ready for Pickup','Completed','Cancelled'))
);
CREATE INDEX IF NOT EXISTS IX_TServiceTickets_Status ON TServiceTickets(strStatus, dtmLoggedUTC DESC);
CREATE INDEX IF NOT EXISTS IX_TServiceTickets_Assigned ON TServiceTickets(intAssignedLabTechID, strStatus);

CREATE TABLE IF NOT EXISTS TServiceTicketNotes (
  intServiceTicketNoteID INTEGER PRIMARY KEY AUTOINCREMENT,
  intServiceTicketID     INTEGER NOT NULL REFERENCES TServiceTickets(intServiceTicketID),
  intLabTechID           INTEGER REFERENCES TLabTechs(intLabTechID),
  dtmNoteUTC             DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  strNote                TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS IX_TServiceTicketNotes_Ticket ON TServiceTicketNotes(intServiceTicketID, dtmNoteUTC DESC);

CREATE TABLE IF NOT EXISTS TAuditLog (
  intTraceID   INTEGER PRIMARY KEY AUTOINCREMENT,
  dtmEventUTC  DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  intLabTechID INTEGER REFERENCES TLabTechs(intLabTechID),
  strAction    TEXT NOT NULL,
  strEntity    TEXT NOT NULL,
  intEntityPK  INTEGER,
  strDetails   TEXT
);
CREATE INDEX IF NOT EXISTS IX_TAuditLog_EntityPK ON TAuditLog(strEntity, intEntityPK);
CREATE INDEX IF NOT EXISTS IX_TAuditLog_EventUTC ON TAuditLog(dtmEventUTC DESC);
```

## SQL Server-only features and migration decisions

| SQL Server feature | Location | Why it’s SQL Server-specific | Migration decision |
| --- | --- | --- | --- |
| Stored procedures | `LabCenterDatabase.sql` (all `usp_*`) | SQLite doesn’t support stored procedures | **Move to app layer** (Node/Electron data access functions). |
| Triggers writing audit log | `trg_TBorrowers_Insert`, `trg_TItems_Insert`, `trg_TItemLoans_Audit`, `trg_TServiceTickets_Audit` | SQLite supports triggers but T-SQL syntax differs | **Option A:** re-implement as SQLite triggers; **Option B (recommended):** emit audit entries in app layer when writing rows. |
| View `V_ItemCurrentStatus` | `LabCenterDatabase.sql` | SQLite supports views but syntax is slightly different; depends on `SYSUTCDATETIME()` | **Re-implement as SQLite view** or **replace with query** in app layer. |
| `SYSUTCDATETIME()` | used in defaults and queries | SQLite lacks this function | Use `strftime('%Y-%m-%dT%H:%M:%fZ','now')` (UTC ISO-8601). |
| `HASHBYTES` for credentials | present in user credential SPs (if used) | SQLite lacks HASHBYTES | Use bcrypt/scrypt/argon2 in app layer. |
| `SCOPE_IDENTITY()` | used in SPs | SQLite uses `last_insert_rowid()` | Replace with app-layer `lastInsertRowid`. |
| `TRY_CONVERT`, `ROW_NUMBER`, `CTE` | used in reporting SPs | SQLite supports CTEs + window functions (>=3.25), but syntax differs | **Re-implement in app layer** or verify SQLite version supports these constructs. |
| `CHECK` constraints on enums | table definitions | SQLite supports CHECK but is less strict by default | Keep CHECKs; also validate in app layer. |

## App-layer responsibilities (if not using SQLite triggers)

If triggers are not ported, the following should be logged in the application code:

- **Borrower create** → `TAuditLog` entry with `BORROWER_CREATE`.
- **Item create** → `TAuditLog` entry with `ITEM_CREATE`.
- **Checkout / Check-in** → `TAuditLog` entries with `CHECKOUT` / `CHECKIN`.
- **Service ticket create/status change** → `TAuditLog` entries with `TICKET_CREATE` / `TICKET_STATUS`.
- **Notes** → `TAuditLog` entries with `NOTE_ADD`.

## Optional: SQLite trigger equivalents (sketch)

If you want DB-level auditing parity, SQLite trigger equivalents can be created. Example sketch for borrower creation:

```sql
CREATE TRIGGER IF NOT EXISTS trg_TBorrowers_Insert
AFTER INSERT ON TBorrowers
BEGIN
  INSERT INTO TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  VALUES (
    NULL,
    'BORROWER_CREATE',
    'TBorrowers',
    NEW.intBorrowerID,
    json_object('name', NEW.strFirstName || ' ' || NEW.strLastName, 'schoolId', COALESCE(NEW.strSchoolIDNumber, ''))
  );
END;
```

> If using SQLite triggers, prefer `json_object` (SQLite JSON1 extension) or write a plain string if JSON1 is unavailable.
