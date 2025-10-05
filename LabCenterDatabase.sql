/* ============================================================================
   Cincinnati State Lab Center — Inventory & Check-In/Out Database
   RDBMS: Microsoft SQL Server (T-SQL)
   Notes:
     - Tables prefixed with T*
     - Adds dtmDueUTC to loans, proper service tickets, and note tables.
     - Provides stored procedures to create borrowers, checkout/checkin,
       create/update service tickets, and append notes.
   ============================================================================ */

IF DB_ID('dbLabCenter') IS NULL
BEGIN
    CREATE DATABASE dbLabCenter;
END
GO
USE dbLabCenter;
GO

/* =========================
   Drop if re-running (dev)
   ========================= */
IF OBJECT_ID('dbo.TServiceTicketNotes','U') IS NOT NULL DROP TABLE dbo.TServiceTicketNotes;
IF OBJECT_ID('dbo.TItemLoanNotes','U')     IS NOT NULL DROP TABLE dbo.TItemLoanNotes;
IF OBJECT_ID('dbo.TServiceTickets','U')    IS NOT NULL DROP TABLE dbo.TServiceTickets;
IF OBJECT_ID('dbo.TAuditLog','U')          IS NOT NULL DROP TABLE dbo.TAuditLog;
IF OBJECT_ID('dbo.TItemLoans','U')         IS NOT NULL DROP TABLE dbo.TItemLoans;
IF OBJECT_ID('dbo.TItems','U')             IS NOT NULL DROP TABLE dbo.TItems;
IF OBJECT_ID('dbo.TBorrowers','U')         IS NOT NULL DROP TABLE dbo.TBorrowers;
IF OBJECT_ID('dbo.TLabTechs','U')          IS NOT NULL DROP TABLE dbo.TLabTechs;
IF OBJECT_ID('dbo.TDepartments','U')       IS NOT NULL DROP TABLE dbo.TDepartments;
GO

/* ============================================================================ */
CREATE TABLE dbo.TDepartments
(
    intDepartmentID     INT IDENTITY(1,1) PRIMARY KEY,
    strDepartmentName   VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.TLabTechs
(
    intLabTechID        INT IDENTITY(1,1) PRIMARY KEY,
    strFirstName        VARCHAR(50)  NOT NULL,
    strLastName         VARCHAR(50)  NOT NULL,
    strEmail            VARCHAR(120) NULL,
    strPhoneNumber      VARCHAR(25)  NULL,
    blnIsActive         BIT          NOT NULL CONSTRAINT DF_TLabTechs_IsActive DEFAULT (1),
    dtmCreated          DATETIME2(0) NOT NULL CONSTRAINT DF_TLabTechs_Created  DEFAULT (SYSUTCDATETIME())
);

CREATE TABLE dbo.TBorrowers
(
    intBorrowerID           INT IDENTITY(1,1) PRIMARY KEY,
    strFirstName            VARCHAR(50)  NOT NULL,
    strLastName             VARCHAR(50)  NOT NULL,
    strSchoolIDNumber       VARCHAR(50)  NULL,
    strPhoneNumber          VARCHAR(25)  NULL,
    strRoomNumber           VARCHAR(25)  NULL,
    strInstructor           VARCHAR(100) NULL,
    intDepartmentID         INT          NULL  REFERENCES dbo.TDepartments(intDepartmentID),
    strBorrowerType         VARCHAR(30)  NULL,
    dtmCreated              DATETIME2(0) NOT NULL CONSTRAINT DF_TBorrowers_Created DEFAULT (SYSUTCDATETIME())
);
CREATE INDEX IX_TBorrowers_Name ON dbo.TBorrowers(strLastName, strFirstName);
CREATE INDEX IX_TBorrowers_SchoolID ON dbo.TBorrowers(strSchoolIDNumber);

CREATE TABLE dbo.TItems
(
    intItemID               INT IDENTITY(1,1) PRIMARY KEY,
    strItemName             VARCHAR(120) NOT NULL,
    strItemNumber           VARCHAR(60)  NULL,
    blnIsSchoolOwned        BIT          NOT NULL,
    intDepartmentID         INT          NULL REFERENCES dbo.TDepartments(intDepartmentID),
    strDescription          VARCHAR(400) NULL,
    blnIsActive             BIT          NOT NULL CONSTRAINT DF_TItems_IsActive DEFAULT (1),
    dtmCreated              DATETIME2(0) NOT NULL CONSTRAINT DF_TItems_Created  DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT UQ_TItems_ItemNumber UNIQUE (strItemNumber)
);
CREATE INDEX IX_TItems_Name ON dbo.TItems(strItemName);

CREATE TABLE dbo.TItemLoans
(
    intItemLoanID           INT IDENTITY(1,1) PRIMARY KEY,

    intItemID               INT NOT NULL REFERENCES dbo.TItems(intItemID),
    intBorrowerID           INT NOT NULL REFERENCES dbo.TBorrowers(intBorrowerID),
    intCheckoutLabTechID    INT NOT NULL REFERENCES dbo.TLabTechs(intLabTechID),

    dtmCheckoutUTC          DATETIME2(0) NOT NULL CONSTRAINT DF_TItemLoans_Checkout DEFAULT (SYSUTCDATETIME()),
    dtmDueUTC               DATETIME2(0) NULL,  -- NEW: due date/time (UTC)
    strCheckoutNotes        VARCHAR(400) NULL,

    dtmCheckinUTC           DATETIME2(0) NULL,
    intCheckinLabTechID     INT          NULL REFERENCES dbo.TLabTechs(intLabTechID),
    strCheckinNotes         VARCHAR(400) NULL,

    -- Snapshots
    snapBorrowerFirstName   VARCHAR(50)  NOT NULL,
    snapBorrowerLastName    VARCHAR(50)  NOT NULL,
    snapSchoolIDNumber      VARCHAR(50)  NULL,
    snapPhoneNumber         VARCHAR(25)  NULL,
    snapRoomNumber          VARCHAR(25)  NULL,
    snapInstructor          VARCHAR(100) NULL,

    snapItemName            VARCHAR(120) NOT NULL,
    snapItemNumber          VARCHAR(60)  NULL,
    snapIsSchoolOwned       BIT          NOT NULL,
    snapDepartmentName      VARCHAR(100) NULL,

    CONSTRAINT CK_TItemLoans_CheckinAfterCheckout
        CHECK (dtmCheckinUTC IS NULL OR dtmCheckinUTC >= dtmCheckoutUTC)
);
CREATE INDEX IX_TItemLoans_Item ON dbo.TItemLoans(intItemID, dtmCheckinUTC);
CREATE INDEX IX_TItemLoans_Borrower ON dbo.TItemLoans(intBorrowerID, dtmCheckinUTC);
CREATE INDEX IX_TItemLoans_CheckoutTime ON dbo.TItemLoans(dtmCheckoutUTC);
CREATE INDEX IX_TItemLoans_DueTime ON dbo.TItemLoans(dtmDueUTC);

-- Per-loan notes (for “add note” in detail modal)
CREATE TABLE dbo.TItemLoanNotes
(
    intItemLoanNoteID   INT IDENTITY(1,1) PRIMARY KEY,
    intItemLoanID       INT NOT NULL REFERENCES dbo.TItemLoans(intItemLoanID),
    intLabTechID        INT NULL REFERENCES dbo.TLabTechs(intLabTechID),
    dtmNoteUTC          DATETIME2(0) NOT NULL CONSTRAINT DF_TItemLoanNotes_NoteUTC DEFAULT (SYSUTCDATETIME()),
    strNote             VARCHAR(1000) NOT NULL
);
CREATE INDEX IX_TItemLoanNotes_Loan ON dbo.TItemLoanNotes(intItemLoanID, dtmNoteUTC DESC);

-- Service tickets (separate from loans)
CREATE TABLE dbo.TServiceTickets
(
    intServiceTicketID  INT IDENTITY(1,1) PRIMARY KEY,
    strPublicTicketID   VARCHAR(20) NOT NULL UNIQUE,         -- e.g., "S-0192"
    intItemID           INT NULL REFERENCES dbo.TItems(intItemID),
    intBorrowerID       INT NULL REFERENCES dbo.TBorrowers(intBorrowerID),
    strItemLabel        VARCHAR(120) NULL,  -- if item not in inventory
    strIssue            VARCHAR(1000) NOT NULL,

    dtmLoggedUTC        DATETIME2(0) NOT NULL CONSTRAINT DF_TServiceTickets_Logged DEFAULT (SYSUTCDATETIME()),
    intAssignedLabTechID INT NULL REFERENCES dbo.TLabTechs(intLabTechID),

    strStatus           VARCHAR(30) NOT NULL CONSTRAINT DF_TServiceTickets_Status DEFAULT ('Diagnosing')
       CHECK (strStatus IN ('Diagnosing','Awaiting Parts','Ready for Pickup','Quarantined','Completed','Cancelled'))
);
CREATE INDEX IX_TServiceTickets_Status ON dbo.TServiceTickets(strStatus, dtmLoggedUTC DESC);

-- Per-ticket notes
CREATE TABLE dbo.TServiceTicketNotes
(
    intServiceTicketNoteID INT IDENTITY(1,1) PRIMARY KEY,
    intServiceTicketID     INT NOT NULL REFERENCES dbo.TServiceTickets(intServiceTicketID),
    intLabTechID           INT NULL REFERENCES dbo.TLabTechs(intLabTechID),
    dtmNoteUTC             DATETIME2(0) NOT NULL CONSTRAINT DF_TServiceTicketNotes_NoteUTC DEFAULT (SYSUTCDATETIME()),
    strNote                VARCHAR(1000) NOT NULL
);
CREATE INDEX IX_TServiceTicketNotes_Ticket ON dbo.TServiceTicketNotes(intServiceTicketID, dtmNoteUTC DESC);

-- Audit log
CREATE TABLE dbo.TAuditLog
(
    intTraceID              BIGINT IDENTITY(1,1) PRIMARY KEY,
    dtmEventUTC             DATETIME2(0) NOT NULL CONSTRAINT DF_TAuditLog_EventUTC DEFAULT (SYSUTCDATETIME()),
    intLabTechID            INT          NULL REFERENCES dbo.TLabTechs(intLabTechID),
    strAction               VARCHAR(50)  NOT NULL,     -- 'BORROWER_CREATE','ITEM_CREATE','CHECKOUT','CHECKIN','TICKET_CREATE','TICKET_STATUS','NOTE_ADD'
    strEntity               VARCHAR(50)  NOT NULL,     -- 'TBorrowers','TItems','TItemLoans','TServiceTickets'
    intEntityPK             BIGINT       NULL,
    strDetails              VARCHAR(1000) NULL
);
CREATE INDEX IX_TAuditLog_EntityPK ON dbo.TAuditLog(strEntity, intEntityPK);
CREATE INDEX IX_TAuditLog_EventUTC ON dbo.TAuditLog(dtmEventUTC DESC);

-- Basic seed (optional)
INSERT dbo.TDepartments(strDepartmentName) VALUES ('Electrical Engineering Tech'),('IT / Software'),('Media');
INSERT dbo.TLabTechs(strFirstName,strLastName,strEmail) VALUES ('Josie','Wooldridge','j.wooldridge@example.edu'),('Alex','Smith','a.smith@example.edu'),('Kris','Jones','k.jones@example.edu');



/* =========================
   Helper VIEW for dashboards
   ========================= */
IF OBJECT_ID('dbo.V_ItemCurrentStatus','V') IS NOT NULL DROP VIEW dbo.V_ItemCurrentStatus;
GO
CREATE VIEW dbo.V_ItemCurrentStatus
AS
SELECT
    it.intItemID,
    it.strItemName,
    it.strItemNumber,
    it.blnIsSchoolOwned,
    d.strDepartmentName,
    il.intItemLoanID,
    il.dtmCheckoutUTC,
    il.dtmDueUTC,
    il.dtmCheckinUTC,
    CASE WHEN il.dtmCheckinUTC IS NULL THEN 1 ELSE 0 END AS blnIsCheckedOut,
    il.snapBorrowerFirstName AS curBorrowerFirstName,
    il.snapBorrowerLastName  AS curBorrowerLastName
FROM dbo.TItems it
LEFT JOIN (
    SELECT il1.*
    FROM dbo.TItemLoans il1
    JOIN (
        SELECT intItemID, MAX(dtmCheckoutUTC) AS MaxOut
        FROM dbo.TItemLoans
        GROUP BY intItemID
    ) lastOut
      ON il1.intItemID = lastOut.intItemID AND il1.dtmCheckoutUTC = lastOut.MaxOut
) il ON il.intItemID = it.intItemID
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = it.intDepartmentID;
GO


/* =========================
   Triggers: write to audit
   ========================= */
IF OBJECT_ID('dbo.trg_TBorrowers_Insert','TR') IS NOT NULL DROP TRIGGER dbo.trg_TBorrowers_Insert;
GO
CREATE TRIGGER dbo.trg_TBorrowers_Insert
ON dbo.TBorrowers
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT NULL, 'BORROWER_CREATE', 'TBorrowers', i.intBorrowerID,
         CONCAT('{"name":"', i.strFirstName, ' ', i.strLastName, '","schoolId":"', ISNULL(i.strSchoolIDNumber,''), '"}')
  FROM inserted i;
END
GO

IF OBJECT_ID('dbo.trg_TItems_Insert','TR') IS NOT NULL DROP TRIGGER dbo.trg_TItems_Insert;
GO
CREATE TRIGGER dbo.trg_TItems_Insert
ON dbo.TItems
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT NULL, 'ITEM_CREATE', 'TItems', i.intItemID,
         CONCAT('{"itemName":"', i.strItemName, '","itemNumber":"', ISNULL(i.strItemNumber,''), '","schoolOwned":', IIF(i.blnIsSchoolOwned=1,'true','false'), '}')
  FROM inserted i;
END
GO

IF OBJECT_ID('dbo.trg_TItemLoans_Audit','TR') IS NOT NULL DROP TRIGGER dbo.trg_TItemLoans_Audit;
GO
CREATE TRIGGER dbo.trg_TItemLoans_Audit
ON dbo.TItemLoans
AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  -- Checkouts
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT il.intCheckoutLabTechID, 'CHECKOUT', 'TItemLoans', il.intItemLoanID,
         CONCAT('{"item":"', il.snapItemName, '","itemNumber":"', ISNULL(il.snapItemNumber,''), '","borrower":"', il.snapBorrowerFirstName, ' ', il.snapBorrowerLastName,
                '","checkoutUTC":"', CONVERT(varchar(19), il.dtmCheckoutUTC, 126), '","dueUTC":"', ISNULL(CONVERT(varchar(19), il.dtmDueUTC, 126), ''), '"}')
  FROM inserted il
  LEFT JOIN deleted d ON d.intItemLoanID = il.intItemLoanID
  WHERE d.intItemLoanID IS NULL;

  -- Checkins
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT il.intCheckinLabTechID, 'CHECKIN', 'TItemLoans', il.intItemLoanID,
         CONCAT('{"item":"', il.snapItemName, '","itemNumber":"', ISNULL(il.snapItemNumber,''), '","borrower":"', il.snapBorrowerFirstName, ' ', il.snapBorrowerLastName,
                '","checkinUTC":"', CONVERT(varchar(19), il.dtmCheckinUTC, 126), '"}')
  FROM inserted il
  JOIN deleted  d ON d.intItemLoanID = il.intItemLoanID
  WHERE d.dtmCheckinUTC IS NULL AND il.dtmCheckinUTC IS NOT NULL;
END
GO

IF OBJECT_ID('dbo.trg_TServiceTickets_Audit','TR') IS NOT NULL DROP TRIGGER dbo.trg_TServiceTickets_Audit;
GO
CREATE TRIGGER dbo.trg_TServiceTickets_Audit
ON dbo.TServiceTickets
AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  -- Create
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT t.intAssignedLabTechID, 'TICKET_CREATE', 'TServiceTickets', t.intServiceTicketID,
         CONCAT('{"publicId":"', t.strPublicTicketID, '","status":"', t.strStatus, '"}')
  FROM inserted t
  LEFT JOIN deleted d ON d.intServiceTicketID = t.intServiceTicketID
  WHERE d.intServiceTicketID IS NULL;

  -- Status changes
  INSERT dbo.TAuditLog (intLabTechID, strAction, strEntity, intEntityPK, strDetails)
  SELECT t.intAssignedLabTechID, 'TICKET_STATUS', 'TServiceTickets', t.intServiceTicketID,
         CONCAT('{"publicId":"', t.strPublicTicketID, '","status":"', t.strStatus, '"}')
  FROM inserted t
  JOIN deleted  d ON d.intServiceTicketID = t.intServiceTicketID
  WHERE ISNULL(d.strStatus,'') <> ISNULL(t.strStatus,'');
END
GO


/* =========================
   Stored Procedures (core)
   ========================= */

-- New borrower (used by "New Customer" modal)
IF OBJECT_ID('dbo.usp_CreateBorrower','P') IS NOT NULL DROP PROCEDURE dbo.usp_CreateBorrower;
GO
CREATE PROCEDURE dbo.usp_CreateBorrower
  @strFirstName VARCHAR(50),
  @strLastName  VARCHAR(50),
  @strSchoolIDNumber VARCHAR(50) = NULL,
  @strPhoneNumber VARCHAR(25) = NULL,
  @strRoomNumber VARCHAR(25) = NULL,
  @strInstructor VARCHAR(100) = NULL,
  @intDepartmentID INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TBorrowers (strFirstName,strLastName,strSchoolIDNumber,strPhoneNumber,strRoomNumber,strInstructor,intDepartmentID)
  VALUES (@strFirstName,@strLastName,@strSchoolIDNumber,@strPhoneNumber,@strRoomNumber,@strInstructor,@intDepartmentID);

  SELECT SCOPE_IDENTITY() AS intBorrowerID;
END
GO

-- Checkout
IF OBJECT_ID('dbo.usp_CheckoutItem','P') IS NOT NULL DROP PROCEDURE dbo.usp_CheckoutItem;
GO
CREATE PROCEDURE dbo.usp_CheckoutItem
  @intItemID             INT,
  @intBorrowerID         INT,
  @intCheckoutLabTechID  INT,
  @dtmDueUTC             DATETIME2(0) = NULL,
  @strCheckoutNotes      VARCHAR(400) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @snapItemName VARCHAR(120),
          @snapItemNumber VARCHAR(60),
          @snapIsSchoolOwned BIT,
          @snapDepartmentName VARCHAR(100);

  SELECT @snapItemName = strItemName,
         @snapItemNumber = strItemNumber,
         @snapIsSchoolOwned = blnIsSchoolOwned,
         @snapDepartmentName = d.strDepartmentName
  FROM dbo.TItems i
  LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
  WHERE i.intItemID = @intItemID;

  DECLARE @snapBorrowerFirstName VARCHAR(50),
          @snapBorrowerLastName  VARCHAR(50),
          @snapSchoolIDNumber    VARCHAR(50),
          @snapPhoneNumber       VARCHAR(25),
          @snapRoomNumber        VARCHAR(25),
          @snapInstructor        VARCHAR(100);

  SELECT @snapBorrowerFirstName = b.strFirstName,
         @snapBorrowerLastName  = b.strLastName,
         @snapSchoolIDNumber    = b.strSchoolIDNumber,
         @snapPhoneNumber       = b.strPhoneNumber,
         @snapRoomNumber        = b.strRoomNumber,
         @snapInstructor        = b.strInstructor
  FROM dbo.TBorrowers b
  WHERE b.intBorrowerID = @intBorrowerID;

  IF EXISTS (SELECT 1 FROM dbo.TItemLoans WHERE intItemID=@intItemID AND dtmCheckinUTC IS NULL)
  BEGIN
      RAISERROR('Item is already checked out.', 16, 1); RETURN;
  END

  INSERT dbo.TItemLoans
  (
    intItemID,intBorrowerID,intCheckoutLabTechID,dtmDueUTC,strCheckoutNotes,
    snapBorrowerFirstName,snapBorrowerLastName,snapSchoolIDNumber,snapPhoneNumber,snapRoomNumber,snapInstructor,
    snapItemName,snapItemNumber,snapIsSchoolOwned,snapDepartmentName
  )
  VALUES
  (
    @intItemID,@intBorrowerID,@intCheckoutLabTechID,@dtmDueUTC,@strCheckoutNotes,
    @snapBorrowerFirstName,@snapBorrowerLastName,@snapSchoolIDNumber,@snapPhoneNumber,@snapRoomNumber,@snapInstructor,
    @snapItemName,@snapItemNumber,@snapIsSchoolOwned,@snapDepartmentName
  );

  SELECT SCOPE_IDENTITY() AS intItemLoanID;
END
GO

-- Checkin
IF OBJECT_ID('dbo.usp_CheckinItem','P') IS NOT NULL DROP PROCEDURE dbo.usp_CheckinItem;
GO
CREATE PROCEDURE dbo.usp_CheckinItem
  @intItemLoanID     INT,
  @intCheckinLabTechID INT,
  @strCheckinNotes   VARCHAR(400) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.TItemLoans
  SET dtmCheckinUTC = SYSUTCDATETIME(),
      intCheckinLabTechID = @intCheckinLabTechID,
      strCheckinNotes = @strCheckinNotes
  WHERE intItemLoanID = @intItemLoanID
    AND dtmCheckinUTC IS NULL;

  IF @@ROWCOUNT = 0
    RAISERROR('Loan not found or already checked in.', 16, 1);
END
GO

-- Append note to loan
IF OBJECT_ID('dbo.usp_AddLoanNote','P') IS NOT NULL DROP PROCEDURE dbo.usp_AddLoanNote;
GO
CREATE PROCEDURE dbo.usp_AddLoanNote
  @intItemLoanID INT,
  @intLabTechID  INT = NULL,
  @strNote       VARCHAR(1000)
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TItemLoanNotes(intItemLoanID,intLabTechID,strNote)
  VALUES (@intItemLoanID,@intLabTechID,@strNote);

  INSERT dbo.TAuditLog(intLabTechID,strAction,strEntity,intEntityPK,strDetails)
  VALUES (@intLabTechID,'NOTE_ADD','TItemLoans',@intItemLoanID,@strNote);
END
GO

-- Create service ticket
IF OBJECT_ID('dbo.usp_ServiceTicketCreate','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServiceTicketCreate;
GO
CREATE PROCEDURE dbo.usp_ServiceTicketCreate
  @strPublicTicketID   VARCHAR(20),
  @intBorrowerID       INT = NULL,
  @intItemID           INT = NULL,
  @strItemLabel        VARCHAR(120) = NULL,
  @strIssue            VARCHAR(1000),
  @intAssignedLabTechID INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TServiceTickets(strPublicTicketID,intItemID,intBorrowerID,strItemLabel,strIssue,intAssignedLabTechID)
  VALUES (@strPublicTicketID,@intItemID,@intBorrowerID,@strItemLabel,@strIssue,@intAssignedLabTechID);

  SELECT SCOPE_IDENTITY() AS intServiceTicketID;
END
GO

-- Update service ticket status
IF OBJECT_ID('dbo.usp_ServiceTicketSetStatus','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServiceTicketSetStatus;
GO
CREATE PROCEDURE dbo.usp_ServiceTicketSetStatus
  @intServiceTicketID INT,
  @strStatus          VARCHAR(30),
  @intLabTechID       INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.TServiceTickets
  SET strStatus = @strStatus
  WHERE intServiceTicketID = @intServiceTicketID;

  INSERT dbo.TAuditLog(intLabTechID,strAction,strEntity,intEntityPK,strDetails)
  VALUES (@intLabTechID,'TICKET_STATUS','TServiceTickets',@intServiceTicketID,@strStatus);
END
GO

-- Append note to service ticket
IF OBJECT_ID('dbo.usp_AddServiceTicketNote','P') IS NOT NULL DROP PROCEDURE dbo.usp_AddServiceTicketNote;
GO
CREATE PROCEDURE dbo.usp_AddServiceTicketNote
  @intServiceTicketID INT,
  @intLabTechID       INT = NULL,
  @strNote            VARCHAR(1000)
AS
BEGIN
  SET NOCOUNT ON;
  INSERT dbo.TServiceTicketNotes(intServiceTicketID,intLabTechID,strNote)
  VALUES (@intServiceTicketID,@intLabTechID,@strNote);

  INSERT dbo.TAuditLog(intLabTechID,strAction,strEntity,intEntityPK,strDetails)
  VALUES (@intLabTechID,'NOTE_ADD','TServiceTickets',@intServiceTicketID,@strNote);
END
GO

/* =========================
   Example queries
   =========================
-- Items currently checked out
-- SELECT * FROM dbo.V_ItemCurrentStatus WHERE blnIsCheckedOut = 1;

-- Overdue loans (UTC assumption; convert if needed)
-- SELECT * FROM dbo.TItemLoans WHERE dtmCheckinUTC IS NULL AND dtmDueUTC IS NOT NULL AND dtmDueUTC < SYSUTCDATETIME();

-- Loan history for an item
-- SELECT * FROM dbo.TItemLoans WHERE intItemID=@ItemID ORDER BY dtmCheckoutUTC DESC;

-- Latest activity
-- SELECT TOP 200 * FROM dbo.TAuditLog ORDER BY dtmEventUTC DESC;
*/
