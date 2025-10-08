/* ============================================================================
   Cincinnati State Lab Center  Inventory & Check-In/Out Database
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

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
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
IF OBJECT_ID('dbo.TBorrowerAliases','U')   IS NOT NULL DROP TABLE dbo.TBorrowerAliases;
IF OBJECT_ID('dbo.TBorrowers','U')         IS NOT NULL DROP TABLE dbo.TBorrowers;
IF OBJECT_ID('dbo.TLabTechs','U')          IS NOT NULL DROP TABLE dbo.TLabTechs;
IF OBJECT_ID('dbo.TAppUsers','U')          IS NOT NULL DROP TABLE dbo.TAppUsers; -- legacy cleanup
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
    strUsername         VARCHAR(120) NOT NULL UNIQUE,
    strDisplayName      VARCHAR(150) NOT NULL,
    strFirstName        VARCHAR(50)  NOT NULL,
    strLastName         VARCHAR(50)  NOT NULL,
    strEmail            VARCHAR(120) NULL,
    strPhoneNumber      VARCHAR(25)  NULL,
    strRole             VARCHAR(50)  NOT NULL,
    blnIsActive         BIT          NOT NULL CONSTRAINT DF_TLabTechs_IsActive DEFAULT (1),
    dtmCreated          DATETIME2(0) NOT NULL CONSTRAINT DF_TLabTechs_Created  DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT CK_TLabTechs_Role CHECK (strRole IN ('admin','co-op'))
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
CREATE UNIQUE INDEX UQ_TBorrowers_SchoolID ON dbo.TBorrowers(strSchoolIDNumber) WHERE strSchoolIDNumber IS NOT NULL;

CREATE TABLE dbo.TBorrowerAliases
(
    intBorrowerAliasID  INT IDENTITY(1,1) PRIMARY KEY,
    intBorrowerID       INT NOT NULL REFERENCES dbo.TBorrowers(intBorrowerID) ON DELETE CASCADE,
    strAlias            NVARCHAR(120) NOT NULL,
    dtmCreated          DATETIME2(0) NOT NULL CONSTRAINT DF_TBorrowerAliases_Created DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT UQ_TBorrowerAliases UNIQUE (intBorrowerID, strAlias)
);
CREATE INDEX IX_TBorrowerAliases_Alias ON dbo.TBorrowerAliases(strAlias);

CREATE TABLE dbo.TItems
(
    intItemID               INT IDENTITY(1,1) PRIMARY KEY,
    strItemName             VARCHAR(120) NOT NULL,
    strItemNumber           VARCHAR(60)  NULL,
    blnIsSchoolOwned        BIT          NOT NULL,
    intDepartmentID         INT          NULL REFERENCES dbo.TDepartments(intDepartmentID),
    strDescription          VARCHAR(400) NULL,
    strDuePolicy            VARCHAR(30)  NOT NULL CONSTRAINT DF_TItems_DuePolicy DEFAULT ('NEXT_DAY_6PM'),
    intDueDaysOffset        INT          NULL,
    intDueHoursOffset       INT          NULL,
    tDueTime                TIME(0)      NULL,
    dtmFixedDueLocal        DATETIME2(0) NULL,
    blnIsActive             BIT          NOT NULL CONSTRAINT DF_TItems_IsActive DEFAULT (1),
    dtmCreated              DATETIME2(0) NOT NULL CONSTRAINT DF_TItems_Created  DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT UQ_TItems_ItemNumber UNIQUE (strItemNumber)
);
ALTER TABLE dbo.TItems ADD CONSTRAINT CK_TItems_DuePolicy CHECK (strDuePolicy IN ('NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER'));
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
CREATE INDEX IX_TItemLoans_Status ON dbo.TItemLoans(dtmCheckinUTC, dtmDueUTC);

-- Per-loan notes (for "add note" in detail modal)
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
CREATE INDEX IX_TServiceTickets_Assigned ON dbo.TServiceTickets(intAssignedLabTechID, strStatus);

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
INSERT dbo.TLabTechs(strUsername,strDisplayName,strFirstName,strLastName,strEmail,strRole)
VALUES
    ('jwooldridge','Josie Wooldridge','Josie','Wooldridge','j.wooldridge@example.edu','admin'),
    ('asmith','Alex Smith','Alex','Smith','a.smith@example.edu','admin'),
    ('kjones','Kris Jones','Kris','Jones','k.jones@example.edu','co-op');



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

-- Borrower lookup for live search
IF OBJECT_ID('dbo.usp_SearchBorrowers','P') IS NOT NULL DROP PROCEDURE dbo.usp_SearchBorrowers;
GO
CREATE PROCEDURE dbo.usp_SearchBorrowers
  @SearchTerm NVARCHAR(120),
  @Top INT = 8
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Term NVARCHAR(120) = LTRIM(RTRIM(ISNULL(@SearchTerm, N'')));
  IF (@Term = N'')
  BEGIN
      SELECT TOP (0)
             b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             CAST(NULL AS NVARCHAR(120)) AS MatchedAlias
      FROM dbo.TBorrowers AS b;
      RETURN;
  END;

  DECLARE @Like NVARCHAR(130) = N'%' + @Term + N'%';

  ;WITH Matches AS
  (
      SELECT TOP (@Top)
             b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             CAST(NULL AS NVARCHAR(120)) AS MatchedAlias,
             0 AS Priority,
             b.intBorrowerID AS SortId
      FROM dbo.TBorrowers AS b
      WHERE b.strFirstName LIKE @Like
         OR b.strLastName LIKE @Like
         OR (b.strFirstName + N' ' + b.strLastName) LIKE @Like
         OR ISNULL(b.strSchoolIDNumber, N'') LIKE @Like
      ORDER BY b.strLastName, b.strFirstName, b.intBorrowerID DESC

      UNION ALL

      SELECT TOP (@Top)
             b.intBorrowerID,
             b.strFirstName,
             b.strLastName,
             b.strSchoolIDNumber,
             a.strAlias AS MatchedAlias,
             1 AS Priority,
             a.intBorrowerAliasID AS SortId
      FROM dbo.TBorrowers AS b
      INNER JOIN dbo.TBorrowerAliases AS a ON a.intBorrowerID = b.intBorrowerID
      WHERE a.strAlias LIKE @Like
      ORDER BY a.intBorrowerAliasID DESC
  )
  SELECT TOP (@Top)
         ranked.intBorrowerID,
         ranked.strFirstName,
         ranked.strLastName,
         ranked.strSchoolIDNumber,
         ranked.MatchedAlias
  FROM
  (
      SELECT *, ROW_NUMBER() OVER (PARTITION BY intBorrowerID ORDER BY Priority, SortId DESC) AS rn
      FROM Matches
  ) AS ranked
  WHERE rn = 1
  ORDER BY Priority, strLastName, strFirstName, intBorrowerID DESC;
END
GO

-- Create inventory item with due policy metadata
IF OBJECT_ID('dbo.usp_CreateItem','P') IS NOT NULL DROP PROCEDURE dbo.usp_CreateItem;
GO
CREATE PROCEDURE dbo.usp_CreateItem
  @strItemName        VARCHAR(120),
  @strItemNumber      VARCHAR(60) = NULL,
  @blnIsSchoolOwned   BIT,
  @intDepartmentID    INT = NULL,
  @strDescription     VARCHAR(400) = NULL,
  @strDuePolicy       VARCHAR(30) = 'NEXT_DAY_6PM',
  @intDueDaysOffset   INT = NULL,
  @intDueHoursOffset  INT = NULL,
  @tDueTime           TIME(0) = NULL,
  @dtmFixedDueLocal   DATETIME2(0) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Policy VARCHAR(30) = UPPER(LTRIM(RTRIM(ISNULL(@strDuePolicy, 'NEXT_DAY_6PM'))));
  IF (@Policy NOT IN ('NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER'))
      SET @Policy = 'NEXT_DAY_6PM';

  IF (@Policy = 'NEXT_DAY_6PM')
  BEGIN
      IF (@intDueDaysOffset IS NULL) SET @intDueDaysOffset = 1;
      IF (@intDueHoursOffset IS NULL) SET @intDueHoursOffset = 0;
      IF (@tDueTime IS NULL) SET @tDueTime = '18:00';
  END;

  INSERT dbo.TItems
  (
    strItemName,
    strItemNumber,
    blnIsSchoolOwned,
    intDepartmentID,
    strDescription,
    strDuePolicy,
    intDueDaysOffset,
    intDueHoursOffset,
    tDueTime,
    dtmFixedDueLocal
  )
  VALUES
  (
    @strItemName,
    @strItemNumber,
    @blnIsSchoolOwned,
    @intDepartmentID,
    @strDescription,
    @Policy,
    @intDueDaysOffset,
    @intDueHoursOffset,
    @tDueTime,
    @dtmFixedDueLocal
  );

  SELECT SCOPE_IDENTITY() AS intItemID;
END
GO

-- Update borrower profile
IF OBJECT_ID('dbo.usp_UpdateBorrower','P') IS NOT NULL DROP PROCEDURE dbo.usp_UpdateBorrower;
GO
CREATE PROCEDURE dbo.usp_UpdateBorrower
  @intBorrowerID       INT,
  @strFirstName        VARCHAR(50),
  @strLastName         VARCHAR(50),
  @strSchoolIDNumber   VARCHAR(50) = NULL,
  @strPhoneNumber      VARCHAR(25) = NULL,
  @strRoomNumber       VARCHAR(25) = NULL,
  @strInstructor       VARCHAR(100) = NULL,
  @intDepartmentID     INT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.TBorrowers
  SET strFirstName = @strFirstName,
      strLastName = @strLastName,
      strSchoolIDNumber = @strSchoolIDNumber,
      strPhoneNumber = @strPhoneNumber,
      strRoomNumber = @strRoomNumber,
      strInstructor = @strInstructor,
      intDepartmentID = @intDepartmentID
  WHERE intBorrowerID = @intBorrowerID;

  IF @@ROWCOUNT = 0
    RAISERROR('Borrower not found.', 16, 1);
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

-- Update due date or checkout metadata
IF OBJECT_ID('dbo.usp_UpdateLoanDue','P') IS NOT NULL DROP PROCEDURE dbo.usp_UpdateLoanDue;
GO
CREATE PROCEDURE dbo.usp_UpdateLoanDue
  @intItemLoanID INT,
  @dtmDueUTC     DATETIME2(0) = NULL,
  @strCheckoutNotes VARCHAR(400) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.TItemLoans
  SET dtmDueUTC = @dtmDueUTC,
      strCheckoutNotes = @strCheckoutNotes
  WHERE intItemLoanID = @intItemLoanID;

  IF @@ROWCOUNT = 0
    RAISERROR('Loan not found.', 16, 1);
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

-- Add / update inventory item
IF OBJECT_ID('dbo.usp_SaveItem','P') IS NOT NULL DROP PROCEDURE dbo.usp_SaveItem;
GO
CREATE PROCEDURE dbo.usp_SaveItem
  @intItemID       INT = NULL,
  @strItemName     VARCHAR(120),
  @strItemNumber   VARCHAR(60) = NULL,
  @blnIsSchoolOwned BIT,
  @intDepartmentID INT = NULL,
  @strDescription  VARCHAR(400) = NULL,
  @blnIsActive     BIT = 1
AS
BEGIN
  SET NOCOUNT ON;

  IF @intItemID IS NULL
  BEGIN
    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,blnIsActive)
    VALUES (@strItemName,@strItemNumber,@blnIsSchoolOwned,@intDepartmentID,@strDescription,@blnIsActive);

    SELECT SCOPE_IDENTITY() AS intItemID;
  END
  ELSE
  BEGIN
    UPDATE dbo.TItems
    SET strItemName = @strItemName,
        strItemNumber = @strItemNumber,
        blnIsSchoolOwned = @blnIsSchoolOwned,
        intDepartmentID = @intDepartmentID,
        strDescription = @strDescription,
        blnIsActive = @blnIsActive
    WHERE intItemID = @intItemID;

    IF @@ROWCOUNT = 0
      RAISERROR('Item not found.', 16, 1);
  END
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

-- Reassign or update ticket metadata
IF OBJECT_ID('dbo.usp_ServiceTicketUpdate','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServiceTicketUpdate;
GO
CREATE PROCEDURE dbo.usp_ServiceTicketUpdate
  @intServiceTicketID INT,
  @intAssignedLabTechID INT = NULL,
  @intItemID           INT = NULL,
  @intBorrowerID       INT = NULL,
  @strItemLabel        VARCHAR(120) = NULL,
  @strIssue            VARCHAR(1000) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.TServiceTickets
  SET intAssignedLabTechID = @intAssignedLabTechID,
      intItemID = @intItemID,
      intBorrowerID = @intBorrowerID,
      strItemLabel = @strItemLabel,
      strIssue = ISNULL(@strIssue, strIssue)
  WHERE intServiceTicketID = @intServiceTicketID;

  IF @@ROWCOUNT = 0
    RAISERROR('Service ticket not found.', 16, 1);
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
   Stored Procedures (reporting/search)
   ========================= */

-- Dashboard counters
IF OBJECT_ID('dbo.usp_GetDashboardStats','P') IS NOT NULL DROP PROCEDURE dbo.usp_GetDashboardStats;
GO
CREATE PROCEDURE dbo.usp_GetDashboardStats
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @today DATE = CONVERT(date, SYSUTCDATETIME());
  DECLARE @startOfDay DATETIME2(0) = CAST(@today AS DATETIME2(0));
  DECLARE @endOfDay DATETIME2(0) = DATEADD(DAY, 1, @startOfDay);

  SELECT
      outNow   = COALESCE(SUM(CASE WHEN dtmCheckinUTC IS NULL THEN 1 ELSE 0 END),0),
      dueToday = COALESCE(SUM(CASE WHEN dtmCheckinUTC IS NULL AND dtmDueUTC >= @startOfDay AND dtmDueUTC < @endOfDay THEN 1 ELSE 0 END),0),
      repairs  = (SELECT COUNT(*) FROM dbo.TServiceTickets WHERE strStatus IN ('Diagnosing','Awaiting Parts','Ready for Pickup','Quarantined')),
      overdue  = COALESCE(SUM(CASE WHEN dtmCheckinUTC IS NULL AND dtmDueUTC IS NOT NULL AND dtmDueUTC < SYSUTCDATETIME() THEN 1 ELSE 0 END),0)
  FROM dbo.TItemLoans;
END
GO

-- Recent loans with optional filters
IF OBJECT_ID('dbo.usp_GetRecentLoans','P') IS NOT NULL DROP PROCEDURE dbo.usp_GetRecentLoans;
GO
CREATE PROCEDURE dbo.usp_GetRecentLoans
  @Top INT = 50,
  @StatusFilter VARCHAR(30) = NULL,
  @Search NVARCHAR(120) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH LoanCTE AS (
    SELECT TOP (@Top)
        il.intItemLoanID,
        il.intItemID,
        il.intBorrowerID,
        il.dtmCheckoutUTC,
        il.dtmDueUTC,
        il.dtmCheckinUTC,
        il.strCheckoutNotes,
        il.snapBorrowerFirstName,
        il.snapBorrowerLastName,
        il.snapSchoolIDNumber,
        il.snapRoomNumber,
        il.snapItemName,
        il.snapItemNumber,
        il.snapDepartmentName,
        CASE
          WHEN il.dtmCheckinUTC IS NOT NULL THEN 'Returned'
          WHEN il.dtmDueUTC IS NOT NULL AND il.dtmDueUTC < SYSUTCDATETIME() THEN 'Overdue'
          ELSE 'On Time'
        END AS LoanStatus
    FROM dbo.TItemLoans il
    ORDER BY il.dtmCheckoutUTC DESC, il.intItemLoanID DESC
  )
  SELECT *
  FROM LoanCTE
  WHERE (@StatusFilter IS NULL OR LoanStatus = @StatusFilter OR (@StatusFilter = 'All'))
    AND (
      @Search IS NULL OR @Search = '' OR
      LoanCTE.snapBorrowerFirstName LIKE N'%' + @Search + N'%' OR
      LoanCTE.snapBorrowerLastName LIKE N'%' + @Search + N'%' OR
      LoanCTE.snapSchoolIDNumber LIKE N'%' + @Search + N'%' OR
      LoanCTE.snapItemName LIKE N'%' + @Search + N'%' OR
      LoanCTE.snapItemNumber LIKE N'%' + @Search + N'%'
    )
  ORDER BY LoanCTE.dtmCheckoutUTC DESC;
END
GO

-- Service ticket listings
IF OBJECT_ID('dbo.usp_GetServiceTickets','P') IS NOT NULL DROP PROCEDURE dbo.usp_GetServiceTickets;
GO
CREATE PROCEDURE dbo.usp_GetServiceTickets
  @Top INT = 50,
  @StatusFilter VARCHAR(30) = NULL,
  @Search NVARCHAR(120) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH TicketCTE AS (
    SELECT TOP (@Top)
        st.intServiceTicketID,
        st.strPublicTicketID,
        st.intItemID,
        st.intBorrowerID,
        st.strItemLabel,
        st.strIssue,
        st.dtmLoggedUTC,
        st.intAssignedLabTechID,
        st.strStatus,
        bt.strFirstName AS borrowerFirstName,
        bt.strLastName  AS borrowerLastName,
        it.strItemName,
        lt.strFirstName AS assignedFirstName,
        lt.strLastName  AS assignedLastName
    FROM dbo.TServiceTickets st
    LEFT JOIN dbo.TBorrowers bt ON bt.intBorrowerID = st.intBorrowerID
    LEFT JOIN dbo.TItems it      ON it.intItemID = st.intItemID
    LEFT JOIN dbo.TLabTechs lt   ON lt.intLabTechID = st.intAssignedLabTechID
    ORDER BY st.dtmLoggedUTC DESC, st.intServiceTicketID DESC
  )
  SELECT *
  FROM TicketCTE
  WHERE (@StatusFilter IS NULL OR strStatus = @StatusFilter OR (@StatusFilter = 'all') OR (@StatusFilter = 'All'))
    AND (
      @Search IS NULL OR @Search = '' OR
      strPublicTicketID LIKE N'%' + @Search + N'%' OR
      COALESCE(strItemName, strItemLabel, N'') LIKE N'%' + @Search + N'%' OR
      COALESCE(borrowerFirstName,N'') LIKE N'%' + @Search + N'%' OR
      COALESCE(borrowerLastName,N'') LIKE N'%' + @Search + N'%' OR
      COALESCE(assignedFirstName,N'') LIKE N'%' + @Search + N'%' OR
      COALESCE(assignedLastName,N'') LIKE N'%' + @Search + N'%'
    )
  ORDER BY TicketCTE.dtmLoggedUTC DESC;
END
GO

-- Borrower lookup helper
IF OBJECT_ID('dbo.usp_FindBorrowers','P') IS NOT NULL DROP PROCEDURE dbo.usp_FindBorrowers;
GO
CREATE PROCEDURE dbo.usp_FindBorrowers
  @Search NVARCHAR(120),
  @Top INT = 20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT TOP (@Top)
      b.intBorrowerID,
      b.strFirstName,
      b.strLastName,
      b.strSchoolIDNumber,
      b.strPhoneNumber,
      b.strRoomNumber,
      b.strInstructor,
      d.strDepartmentName
  FROM dbo.TBorrowers b
  LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = b.intDepartmentID
  WHERE b.strFirstName LIKE N'%' + @Search + N'%'
     OR b.strLastName LIKE N'%' + @Search + N'%'
     OR ISNULL(b.strSchoolIDNumber,N'') LIKE N'%' + @Search + N'%'
  ORDER BY b.strLastName, b.strFirstName;
END
GO

-- Item lookup helper
IF OBJECT_ID('dbo.usp_FindItems','P') IS NOT NULL DROP PROCEDURE dbo.usp_FindItems;
GO
CREATE PROCEDURE dbo.usp_FindItems
  @Search NVARCHAR(120),
  @Top INT = 20
AS
BEGIN
  SET NOCOUNT ON;

  SELECT TOP (@Top)
      i.intItemID,
      i.strItemName,
      i.strItemNumber,
      i.blnIsSchoolOwned,
      d.strDepartmentName,
      i.blnIsActive
  FROM dbo.TItems i
  LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
  WHERE i.strItemName LIKE N'%' + @Search + N'%'
     OR ISNULL(i.strItemNumber,N'') LIKE N'%' + @Search + N'%'
  ORDER BY i.strItemName;
END
GO

-- Latest audit log entries
IF OBJECT_ID('dbo.usp_GetAuditLog','P') IS NOT NULL DROP PROCEDURE dbo.usp_GetAuditLog;
GO
CREATE PROCEDURE dbo.usp_GetAuditLog
  @Top INT = 100
AS
BEGIN
  SET NOCOUNT ON;

  SELECT TOP (@Top)
      a.intTraceID,
      a.dtmEventUTC,
      a.intLabTechID,
      lt.strFirstName,
      lt.strLastName,
      a.strAction,
      a.strEntity,
      a.intEntityPK,
      a.strDetails
  FROM dbo.TAuditLog a
  LEFT JOIN dbo.TLabTechs lt ON lt.intLabTechID = a.intLabTechID
  ORDER BY a.dtmEventUTC DESC;
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

GO

/* =========================
   Demo seed data
   ========================= */
IF NOT EXISTS (SELECT 1 FROM dbo.TBorrowers)
BEGIN
    INSERT dbo.TBorrowers(strFirstName,strLastName,strSchoolIDNumber,strPhoneNumber,strRoomNumber,strInstructor,intDepartmentID)
    SELECT 'Jane','Doe','123456','513-555-1010','ATLC 102','Prof. Carter',d.intDepartmentID
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';

    INSERT dbo.TBorrowers(strFirstName,strLastName,strSchoolIDNumber,strPhoneNumber,strRoomNumber,strInstructor,intDepartmentID)
    SELECT 'Alex','Smith','332211','513-555-2020','ATLC 204','Dr. Nguyen',d.intDepartmentID
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'IT / Software';

    INSERT dbo.TBorrowers(strFirstName,strLastName,strSchoolIDNumber,strPhoneNumber,strRoomNumber,strInstructor,intDepartmentID)
    SELECT 'Chris','Patel','778899','513-555-3030','ATLC 120','Prof. Rivera',d.intDepartmentID
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';
END

IF NOT EXISTS (SELECT 1 FROM dbo.TItems)
BEGIN
    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'USB-C Cable (1m)','CAB-UC-001',1,d.intDepartmentID,'Standard USB-C charging/data cable','NEXT_DAY_6PM',1,0,'18:00',NULL
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';

    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'Raspberry Pi 5','DEV-RPI-005',1,d.intDepartmentID,'Single-board computer kit with PSU','OFFSET',3,0,'12:00',NULL
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'IT / Software';

    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'Scope Probe','OSC-SCP-07',1,d.intDepartmentID,'Oscilloscope probe replacement','OFFSET',7,0,'09:30',NULL
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';

    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'Lab Laptop 15','LAP-015',1,d.intDepartmentID,'15" Windows laptop for student checkout','SEMESTER',NULL,NULL,NULL,'2024-05-10T18:00:00'
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Media';

    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'Multimeter #A12','MM-A12',1,d.intDepartmentID,'Digital multimeter used in circuits lab','NEXT_DAY_6PM',1,0,'18:00',NULL
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';

    INSERT dbo.TItems(strItemName,strItemNumber,blnIsSchoolOwned,intDepartmentID,strDescription,strDuePolicy,intDueDaysOffset,intDueHoursOffset,tDueTime,dtmFixedDueLocal)
    SELECT 'Oscilloscope #S7','OSC-S7',1,d.intDepartmentID,'Bench oscilloscope station','SEMESTER',NULL,NULL,NULL,'2024-05-10T18:00:00'
    FROM dbo.TDepartments d WHERE d.strDepartmentName = 'Electrical Engineering Tech';
END

IF NOT EXISTS (SELECT 1 FROM dbo.TItemLoans)
BEGIN
    DECLARE @JaneID INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Jane' AND strLastName='Doe');
    DECLARE @AlexID INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Alex' AND strLastName='Smith');
    DECLARE @ChrisID INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Chris' AND strLastName='Patel');
    DECLARE @JosieID INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName='Josie');
    DECLARE @AlexTechID INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName='Alex');

    DECLARE @CableID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='USB-C Cable (1m)');
    DECLARE @PiID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='Raspberry Pi 5');
    DECLARE @ProbeID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='Scope Probe');

    DECLARE @Loan TABLE(intItemLoanID INT);

    INSERT INTO @Loan
    EXEC dbo.usp_CheckoutItem
        @intItemID            = @CableID,
        @intBorrowerID        = @JaneID,
        @intCheckoutLabTechID = @JosieID,
        @dtmDueUTC            = '2024-02-01T18:00:00',
        @strCheckoutNotes     = 'Checked condition';
    DECLARE @LoanJane INT = (SELECT TOP 1 intItemLoanID FROM @Loan ORDER BY intItemLoanID DESC);
    UPDATE dbo.TItemLoans SET dtmCheckoutUTC = DATEADD(HOUR,-6,SYSUTCDATETIME()) WHERE intItemLoanID = @LoanJane;

    DELETE FROM @Loan;
    INSERT INTO @Loan
    EXEC dbo.usp_CheckoutItem
        @intItemID            = @PiID,
        @intBorrowerID        = @AlexID,
        @intCheckoutLabTechID = @JosieID,
        @dtmDueUTC            = '2024-02-03T12:00:00',
        @strCheckoutNotes     = NULL;
    DECLARE @LoanAlex INT = (SELECT TOP 1 intItemLoanID FROM @Loan ORDER BY intItemLoanID DESC);
    UPDATE dbo.TItemLoans SET dtmCheckoutUTC = DATEADD(HOUR,-10,SYSUTCDATETIME()) WHERE intItemLoanID = @LoanAlex;

    DELETE FROM @Loan;
    INSERT INTO @Loan
    EXEC dbo.usp_CheckoutItem
        @intItemID            = @ProbeID,
        @intBorrowerID        = @ChrisID,
        @intCheckoutLabTechID = @AlexTechID,
        @dtmDueUTC            = '2024-01-15T09:30:00',
        @strCheckoutNotes     = 'Handle with care';
    DECLARE @LoanChris INT = (SELECT TOP 1 intItemLoanID FROM @Loan ORDER BY intItemLoanID DESC);
    UPDATE dbo.TItemLoans SET dtmCheckoutUTC = DATEADD(HOUR,-30,SYSUTCDATETIME()) WHERE intItemLoanID = @LoanChris;
END

IF NOT EXISTS (SELECT 1 FROM dbo.TServiceTickets)
BEGIN
    DECLARE @JaneID2 INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Jane' AND strLastName='Doe');
    DECLARE @AlexID2 INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Alex' AND strLastName='Smith');
    DECLARE @ChrisID2 INT = (SELECT intBorrowerID FROM dbo.TBorrowers WHERE strFirstName='Chris' AND strLastName='Patel');
    DECLARE @LaptopID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='Lab Laptop 15');
    DECLARE @MultimeterID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='Multimeter #A12');
    DECLARE @OscID INT = (SELECT intItemID FROM dbo.TItems WHERE strItemName='Oscilloscope #S7');
    DECLARE @JosieID2 INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName='Josie');
    DECLARE @AlexTechID2 INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName='Alex');
    DECLARE @KrisID INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName='Kris');

    DECLARE @Ticket TABLE(intServiceTicketID INT);

    INSERT INTO @Ticket EXEC dbo.usp_ServiceTicketCreate 'S-0192', @JaneID2, @MultimeterID, NULL, 'Reads zero', @JosieID2;
    DECLARE @TicketMultimeter INT = (SELECT TOP 1 intServiceTicketID FROM @Ticket ORDER BY intServiceTicketID DESC);
    UPDATE dbo.TServiceTickets SET dtmLoggedUTC = DATEADD(DAY,-2,SYSUTCDATETIME()), strStatus='Diagnosing' WHERE intServiceTicketID = @TicketMultimeter;

    DELETE FROM @Ticket;
    INSERT INTO @Ticket EXEC dbo.usp_ServiceTicketCreate 'S-0193', @AlexID2, @OscID, NULL, 'Display flicker', @AlexTechID2;
    DECLARE @TicketOsc INT = (SELECT TOP 1 intServiceTicketID FROM @Ticket ORDER BY intServiceTicketID DESC);
    UPDATE dbo.TServiceTickets SET dtmLoggedUTC = DATEADD(DAY,-3,SYSUTCDATETIME()), strStatus='Awaiting Parts' WHERE intServiceTicketID = @TicketOsc;

    DELETE FROM @Ticket;
    INSERT INTO @Ticket EXEC dbo.usp_ServiceTicketCreate 'S-0194', @ChrisID2, @LaptopID, NULL, 'Battery swell', @KrisID;
    DECLARE @TicketLaptop INT = (SELECT TOP 1 intServiceTicketID FROM @Ticket ORDER BY intServiceTicketID DESC);
    UPDATE dbo.TServiceTickets SET dtmLoggedUTC = DATEADD(DAY,-4,SYSUTCDATETIME()), strStatus='Ready for Pickup' WHERE intServiceTicketID = @TicketLaptop;
END
