/* -----------------------------------------------------------------------------
   Name: LabCenter Inventory Management Schema
   Abstract: Creates the Lab Center database schema, supporting procedures, and
             supporting programmable objects with consistent naming conventions.
   Notes: Run on a blank SQL Server instance. Script is idempotent for dev use.
----------------------------------------------------------------------------- */

IF DB_ID('dbLabCenter') IS NULL
BEGIN
    CREATE DATABASE dbLabCenter;
END;
GO
USE dbLabCenter;
GO

/* -----------------------------------------------------------------------------
   Section: Drop Existing Objects (development convenience)
----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.TServiceTicketNotes','U') IS NOT NULL DROP TABLE dbo.TServiceTicketNotes;
IF OBJECT_ID('dbo.TItemLoanNotes','U')     IS NOT NULL DROP TABLE dbo.TItemLoanNotes;
IF OBJECT_ID('dbo.TServiceTickets','U')    IS NOT NULL DROP TABLE dbo.TServiceTickets;
IF OBJECT_ID('dbo.TAuditLog','U')          IS NOT NULL DROP TABLE dbo.TAuditLog;
IF OBJECT_ID('dbo.TItemLoans','U')         IS NOT NULL DROP TABLE dbo.TItemLoans;
IF OBJECT_ID('dbo.TItems','U')             IS NOT NULL DROP TABLE dbo.TItems;
IF OBJECT_ID('dbo.TBorrowerAliases','U')   IS NOT NULL DROP TABLE dbo.TBorrowerAliases;
IF OBJECT_ID('dbo.TBorrowers','U')         IS NOT NULL DROP TABLE dbo.TBorrowers;
IF OBJECT_ID('dbo.TLabTechs','U')          IS NOT NULL DROP TABLE dbo.TLabTechs;
IF OBJECT_ID('dbo.TDepartments','U')       IS NOT NULL DROP TABLE dbo.TDepartments;
GO

/* -----------------------------------------------------------------------------
   Section: Table Definitions
----------------------------------------------------------------------------- */
CREATE TABLE dbo.TDepartments
(
    DepartmentID      INT IDENTITY(1,1) NOT NULL,
    DepartmentName    NVARCHAR(100)     NOT NULL,
    CONSTRAINT PK_TDepartments PRIMARY KEY CLUSTERED (DepartmentID),
    CONSTRAINT UQ_TDepartments_DepartmentName UNIQUE (DepartmentName)
);

CREATE TABLE dbo.TLabTechs
(
    LabTechID     INT           IDENTITY(1,1) NOT NULL,
    FirstName     NVARCHAR(50)  NOT NULL,
    LastName      NVARCHAR(50)  NOT NULL,
    Email         NVARCHAR(120) NULL,
    PhoneNumber   NVARCHAR(25)  NULL,
    IsActive      BIT           NOT NULL CONSTRAINT DF_TLabTechs_IsActive DEFAULT (1),
    CreatedAt     DATETIME2(0)  NOT NULL CONSTRAINT DF_TLabTechs_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_TLabTechs PRIMARY KEY CLUSTERED (LabTechID)
);

CREATE TABLE dbo.TBorrowers
(
    BorrowerID       INT           IDENTITY(1,1) NOT NULL,
    FirstName        NVARCHAR(50)  NOT NULL,
    LastName         NVARCHAR(50)  NOT NULL,
    SchoolIdNumber   NVARCHAR(50)  NULL,
    PhoneNumber      NVARCHAR(25)  NULL,
    RoomNumber       NVARCHAR(25)  NULL,
    Instructor       NVARCHAR(100) NULL,
    DepartmentID     INT           NULL,
    BorrowerType     NVARCHAR(30)  NULL,
    CreatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_TBorrowers_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_TBorrowers PRIMARY KEY CLUSTERED (BorrowerID),
    CONSTRAINT FK_TBorrowers_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES dbo.TDepartments(DepartmentID)
);
CREATE INDEX IX_TBorrowers_LastName_FirstName ON dbo.TBorrowers (LastName, FirstName);
CREATE INDEX IX_TBorrowers_SchoolIdNumber ON dbo.TBorrowers (SchoolIdNumber);
CREATE UNIQUE INDEX UIX_TBorrowers_SchoolIdNumber ON dbo.TBorrowers (SchoolIdNumber) WHERE SchoolIdNumber IS NOT NULL;

CREATE TABLE dbo.TBorrowerAliases
(
    BorrowerAliasID INT           IDENTITY(1,1) NOT NULL,
    BorrowerID      INT           NOT NULL,
    Alias           NVARCHAR(120) NOT NULL,
    CreatedAt       DATETIME2(0)  NOT NULL CONSTRAINT DF_TBorrowerAliases_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_TBorrowerAliases PRIMARY KEY CLUSTERED (BorrowerAliasID),
    CONSTRAINT FK_TBorrowerAliases_BorrowerID FOREIGN KEY (BorrowerID) REFERENCES dbo.TBorrowers(BorrowerID) ON DELETE CASCADE,
    CONSTRAINT UQ_TBorrowerAliases UNIQUE (BorrowerID, Alias)
);
CREATE INDEX IX_TBorrowerAliases_Alias ON dbo.TBorrowerAliases (Alias);

CREATE TABLE dbo.TItems
(
    ItemID            INT           IDENTITY(1,1) NOT NULL,
    ItemName          NVARCHAR(120) NOT NULL,
    ItemNumber        NVARCHAR(60)  NULL,
    IsSchoolOwned     BIT           NOT NULL,
    DepartmentID      INT           NULL,
    Description       NVARCHAR(400) NULL,
    DuePolicy         NVARCHAR(30)  NOT NULL CONSTRAINT DF_TItems_DuePolicy DEFAULT ('NEXT_DAY_6PM'),
    DueDaysOffset     INT           NULL,
    DueHoursOffset    INT           NULL,
    DueTime           TIME(0)       NULL,
    FixedDueLocal     DATETIME2(0)  NULL,
    IsActive          BIT           NOT NULL CONSTRAINT DF_TItems_IsActive DEFAULT (1),
    CreatedAt         DATETIME2(0)  NOT NULL CONSTRAINT DF_TItems_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_TItems PRIMARY KEY CLUSTERED (ItemID),
    CONSTRAINT FK_TItems_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES dbo.TDepartments(DepartmentID),
    CONSTRAINT CK_TItems_DuePolicy CHECK (DuePolicy IN ('NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER')),
    CONSTRAINT UQ_TItems_ItemNumber UNIQUE (ItemNumber)
);
CREATE INDEX IX_TItems_ItemName ON dbo.TItems (ItemName);

CREATE TABLE dbo.TItemLoans
(
    ItemLoanID                INT           IDENTITY(1,1) NOT NULL,
    ItemID                    INT           NOT NULL,
    BorrowerID                INT           NOT NULL,
    CheckoutLabTechID         INT           NOT NULL,
    CheckoutUtc               DATETIME2(0)  NOT NULL CONSTRAINT DF_TItemLoans_CheckoutUtc DEFAULT (SYSUTCDATETIME()),
    DueUtc                    DATETIME2(0)  NULL,
    CheckoutNotes             NVARCHAR(400) NULL,
    CheckinUtc                DATETIME2(0)  NULL,
    CheckinLabTechID          INT           NULL,
    CheckinNotes              NVARCHAR(400) NULL,
    SnapshotBorrowerFirstName NVARCHAR(50)  NOT NULL,
    SnapshotBorrowerLastName  NVARCHAR(50)  NOT NULL,
    SnapshotSchoolIdNumber    NVARCHAR(50)  NULL,
    SnapshotPhoneNumber       NVARCHAR(25)  NULL,
    SnapshotRoomNumber        NVARCHAR(25)  NULL,
    SnapshotInstructor        NVARCHAR(100) NULL,
    SnapshotItemName          NVARCHAR(120) NOT NULL,
    SnapshotItemNumber        NVARCHAR(60)  NULL,
    SnapshotIsSchoolOwned     BIT           NOT NULL,
    SnapshotDepartmentName    NVARCHAR(100) NULL,
    CONSTRAINT PK_TItemLoans PRIMARY KEY CLUSTERED (ItemLoanID),
    CONSTRAINT FK_TItemLoans_ItemID FOREIGN KEY (ItemID) REFERENCES dbo.TItems(ItemID),
    CONSTRAINT FK_TItemLoans_BorrowerID FOREIGN KEY (BorrowerID) REFERENCES dbo.TBorrowers(BorrowerID),
    CONSTRAINT FK_TItemLoans_CheckoutLabTechID FOREIGN KEY (CheckoutLabTechID) REFERENCES dbo.TLabTechs(LabTechID),
    CONSTRAINT FK_TItemLoans_CheckinLabTechID FOREIGN KEY (CheckinLabTechID) REFERENCES dbo.TLabTechs(LabTechID),
    CONSTRAINT CK_TItemLoans_CheckinAfterCheckout CHECK (CheckinUtc IS NULL OR CheckinUtc >= CheckoutUtc)
);
CREATE INDEX IX_TItemLoans_Item ON dbo.TItemLoans (ItemID, CheckinUtc);
CREATE INDEX IX_TItemLoans_Borrower ON dbo.TItemLoans (BorrowerID, CheckinUtc);
CREATE INDEX IX_TItemLoans_CheckoutUtc ON dbo.TItemLoans (CheckoutUtc);
CREATE INDEX IX_TItemLoans_DueUtc ON dbo.TItemLoans (DueUtc);
CREATE INDEX IX_TItemLoans_Status ON dbo.TItemLoans (CheckinUtc, DueUtc);

CREATE TABLE dbo.TItemLoanNotes
(
    ItemLoanNoteID INT           IDENTITY(1,1) NOT NULL,
    ItemLoanID     INT           NOT NULL,
    LabTechID      INT           NULL,
    NoteUtc        DATETIME2(0)  NOT NULL CONSTRAINT DF_TItemLoanNotes_NoteUtc DEFAULT (SYSUTCDATETIME()),
    Note           NVARCHAR(1000) NOT NULL,
    CONSTRAINT PK_TItemLoanNotes PRIMARY KEY CLUSTERED (ItemLoanNoteID),
    CONSTRAINT FK_TItemLoanNotes_ItemLoanID FOREIGN KEY (ItemLoanID) REFERENCES dbo.TItemLoans(ItemLoanID),
    CONSTRAINT FK_TItemLoanNotes_LabTechID FOREIGN KEY (LabTechID) REFERENCES dbo.TLabTechs(LabTechID)
);
CREATE INDEX IX_TItemLoanNotes_ItemLoanID ON dbo.TItemLoanNotes (ItemLoanID, NoteUtc DESC);

CREATE TABLE dbo.TServiceTickets
(
    ServiceTicketID    INT           IDENTITY(1,1) NOT NULL,
    PublicTicketID     NVARCHAR(20)  NOT NULL,
    ItemID             INT           NULL,
    BorrowerID         INT           NULL,
    ItemLabel          NVARCHAR(120) NULL,
    Issue              NVARCHAR(1000) NOT NULL,
    LoggedUtc          DATETIME2(0)  NOT NULL CONSTRAINT DF_TServiceTickets_LoggedUtc DEFAULT (SYSUTCDATETIME()),
    AssignedLabTechID  INT           NULL,
    Status             NVARCHAR(30)  NOT NULL CONSTRAINT DF_TServiceTickets_Status DEFAULT ('Diagnosing'),
    CONSTRAINT PK_TServiceTickets PRIMARY KEY CLUSTERED (ServiceTicketID),
    CONSTRAINT FK_TServiceTickets_ItemID FOREIGN KEY (ItemID) REFERENCES dbo.TItems(ItemID),
    CONSTRAINT FK_TServiceTickets_BorrowerID FOREIGN KEY (BorrowerID) REFERENCES dbo.TBorrowers(BorrowerID),
    CONSTRAINT FK_TServiceTickets_AssignedLabTechID FOREIGN KEY (AssignedLabTechID) REFERENCES dbo.TLabTechs(LabTechID),
    CONSTRAINT CK_TServiceTickets_Status CHECK (Status IN ('Diagnosing','Awaiting Parts','Ready for Pickup','Quarantined','Completed','Cancelled')),
    CONSTRAINT UQ_TServiceTickets_PublicTicketID UNIQUE (PublicTicketID)
);
CREATE INDEX IX_TServiceTickets_Status ON dbo.TServiceTickets (Status, LoggedUtc DESC);
CREATE INDEX IX_TServiceTickets_Assigned ON dbo.TServiceTickets (AssignedLabTechID, Status);

CREATE TABLE dbo.TServiceTicketNotes
(
    ServiceTicketNoteID INT           IDENTITY(1,1) NOT NULL,
    ServiceTicketID     INT           NOT NULL,
    LabTechID           INT           NULL,
    NoteUtc             DATETIME2(0)  NOT NULL CONSTRAINT DF_TServiceTicketNotes_NoteUtc DEFAULT (SYSUTCDATETIME()),
    Note                NVARCHAR(1000) NOT NULL,
    CONSTRAINT PK_TServiceTicketNotes PRIMARY KEY CLUSTERED (ServiceTicketNoteID),
    CONSTRAINT FK_TServiceTicketNotes_ServiceTicketID FOREIGN KEY (ServiceTicketID) REFERENCES dbo.TServiceTickets(ServiceTicketID),
    CONSTRAINT FK_TServiceTicketNotes_LabTechID FOREIGN KEY (LabTechID) REFERENCES dbo.TLabTechs(LabTechID)
);
CREATE INDEX IX_TServiceTicketNotes_ServiceTicketID ON dbo.TServiceTicketNotes (ServiceTicketID, NoteUtc DESC);

CREATE TABLE dbo.TAuditLog
(
    TraceID          BIGINT        IDENTITY(1,1) NOT NULL,
    EventUtc         DATETIME2(0)  NOT NULL CONSTRAINT DF_TAuditLog_EventUtc DEFAULT (SYSUTCDATETIME()),
    LabTechID        INT           NULL,
    Action           NVARCHAR(50)  NOT NULL,
    Entity           NVARCHAR(50)  NOT NULL,
    EntityPrimaryKey BIGINT        NULL,
    Details          NVARCHAR(1000) NULL,
    CONSTRAINT PK_TAuditLog PRIMARY KEY CLUSTERED (TraceID),
    CONSTRAINT FK_TAuditLog_LabTechID FOREIGN KEY (LabTechID) REFERENCES dbo.TLabTechs(LabTechID)
);
CREATE INDEX IX_TAuditLog_EntityPrimaryKey ON dbo.TAuditLog (Entity, EntityPrimaryKey);
CREATE INDEX IX_TAuditLog_EventUtc ON dbo.TAuditLog (EventUtc DESC);
GO

/* -----------------------------------------------------------------------------
   Section: Views
----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.V_ItemCurrentStatus','V') IS NOT NULL DROP VIEW dbo.V_ItemCurrentStatus;
GO
CREATE VIEW dbo.V_ItemCurrentStatus
AS
SELECT
    i.ItemID,
    i.ItemName,
    i.ItemNumber,
    i.IsSchoolOwned,
    d.DepartmentName,
    l.ItemLoanID,
    l.CheckoutUtc,
    l.DueUtc,
    l.CheckinUtc,
    CASE WHEN l.CheckinUtc IS NULL THEN 1 ELSE 0 END AS IsCheckedOut,
    l.SnapshotBorrowerFirstName AS CurrentBorrowerFirstName,
    l.SnapshotBorrowerLastName  AS CurrentBorrowerLastName
FROM dbo.TItems AS i
LEFT JOIN (
    SELECT l1.*
    FROM dbo.TItemLoans AS l1
    INNER JOIN (
        SELECT ItemID, MAX(CheckoutUtc) AS MaxCheckoutUtc
        FROM dbo.TItemLoans
        GROUP BY ItemID
    ) AS lastOut
        ON l1.ItemID = lastOut.ItemID
       AND l1.CheckoutUtc = lastOut.MaxCheckoutUtc
) AS l ON l.ItemID = i.ItemID
LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = i.DepartmentID;
GO

/* -----------------------------------------------------------------------------
   Section: Triggers
----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.trg_TBorrowers_Insert','TR') IS NOT NULL DROP TRIGGER dbo.trg_TBorrowers_Insert;
GO
CREATE TRIGGER dbo.trg_TBorrowers_Insert
ON dbo.TBorrowers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT NULL,
           'BORROWER_CREATE',
           'TBorrowers',
           i.BorrowerID,
           CONCAT('{"name":"', i.FirstName, ' ', i.LastName, '","schoolId":"', ISNULL(i.SchoolIdNumber,''), '"}')
    FROM inserted AS i;
END;
GO

IF OBJECT_ID('dbo.trg_TItems_Insert','TR') IS NOT NULL DROP TRIGGER dbo.trg_TItems_Insert;
GO
CREATE TRIGGER dbo.trg_TItems_Insert
ON dbo.TItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT NULL,
           'ITEM_CREATE',
           'TItems',
           i.ItemID,
           CONCAT('{"itemName":"', i.ItemName, '","itemNumber":"', ISNULL(i.ItemNumber,''), '","schoolOwned":', IIF(i.IsSchoolOwned = 1,'true','false'), '}')
    FROM inserted AS i;
END;
GO

IF OBJECT_ID('dbo.trg_TItemLoans_Audit','TR') IS NOT NULL DROP TRIGGER dbo.trg_TItemLoans_Audit;
GO
CREATE TRIGGER dbo.trg_TItemLoans_Audit
ON dbo.TItemLoans
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT i.CheckoutLabTechID,
           'CHECKOUT',
           'TItemLoans',
           i.ItemLoanID,
           CONCAT('{"item":"', i.SnapshotItemName, '","itemNumber":"', ISNULL(i.SnapshotItemNumber,''), '","borrower":"', i.SnapshotBorrowerFirstName, ' ', i.SnapshotBorrowerLastName, '","checkoutUTC":"', CONVERT(VARCHAR(19), i.CheckoutUtc, 126), '","dueUTC":"', ISNULL(CONVERT(VARCHAR(19), i.DueUtc, 126), ''), '"}')
    FROM inserted AS i
    LEFT JOIN deleted AS d ON d.ItemLoanID = i.ItemLoanID
    WHERE d.ItemLoanID IS NULL;

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT i.CheckinLabTechID,
           'CHECKIN',
           'TItemLoans',
           i.ItemLoanID,
           CONCAT('{"item":"', i.SnapshotItemName, '","itemNumber":"', ISNULL(i.SnapshotItemNumber,''), '","borrower":"', i.SnapshotBorrowerFirstName, ' ', i.SnapshotBorrowerLastName, '","checkinUTC":"', CONVERT(VARCHAR(19), i.CheckinUtc, 126), '"}')
    FROM inserted AS i
    INNER JOIN deleted AS d ON d.ItemLoanID = i.ItemLoanID
    WHERE d.CheckinUtc IS NULL AND i.CheckinUtc IS NOT NULL;
END;
GO

IF OBJECT_ID('dbo.trg_TServiceTickets_Audit','TR') IS NOT NULL DROP TRIGGER dbo.trg_TServiceTickets_Audit;
GO
CREATE TRIGGER dbo.trg_TServiceTickets_Audit
ON dbo.TServiceTickets
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT i.AssignedLabTechID,
           'TICKET_CREATE',
           'TServiceTickets',
           i.ServiceTicketID,
           CONCAT('{"publicId":"', i.PublicTicketID, '","status":"', i.Status, '"}')
    FROM inserted AS i
    LEFT JOIN deleted AS d ON d.ServiceTicketID = i.ServiceTicketID
    WHERE d.ServiceTicketID IS NULL;

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    SELECT i.AssignedLabTechID,
           'TICKET_STATUS',
           'TServiceTickets',
           i.ServiceTicketID,
           CONCAT('{"publicId":"', i.PublicTicketID, '","status":"', i.Status, '"}')
    FROM inserted AS i
    INNER JOIN deleted AS d ON d.ServiceTicketID = i.ServiceTicketID
    WHERE ISNULL(d.Status, N'') <> ISNULL(i.Status, N'');
END;
GO

/* -----------------------------------------------------------------------------
   Section: Stored Procedures - Core Operations
----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.spCreateBorrower','P') IS NOT NULL DROP PROCEDURE dbo.spCreateBorrower;
GO
CREATE PROCEDURE dbo.spCreateBorrower
    @FirstName        NVARCHAR(50),
    @LastName         NVARCHAR(50),
    @SchoolIdNumber   NVARCHAR(50) = NULL,
    @PhoneNumber      NVARCHAR(25) = NULL,
    @RoomNumber       NVARCHAR(25) = NULL,
    @Instructor       NVARCHAR(100) = NULL,
    @DepartmentID     INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TBorrowers (FirstName, LastName, SchoolIdNumber, PhoneNumber, RoomNumber, Instructor, DepartmentID)
    VALUES (@FirstName, @LastName, @SchoolIdNumber, @PhoneNumber, @RoomNumber, @Instructor, @DepartmentID);

    SELECT SCOPE_IDENTITY() AS BorrowerID;
END;
GO

IF OBJECT_ID('dbo.spSearchBorrowers','P') IS NOT NULL DROP PROCEDURE dbo.spSearchBorrowers;
GO
CREATE PROCEDURE dbo.spSearchBorrowers
    @SearchTerm NVARCHAR(120),
    @Top        INT = 8
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Term NVARCHAR(120) = LTRIM(RTRIM(ISNULL(@SearchTerm, N'')));
    IF (@Term = N'')
    BEGIN
        SELECT TOP (0)
            b.BorrowerID,
            b.FirstName,
            b.LastName,
            b.SchoolIdNumber,
            CAST(NULL AS NVARCHAR(120)) AS MatchedAlias
        FROM dbo.TBorrowers AS b;
        RETURN;
    END;

    DECLARE @Like NVARCHAR(130) = N'%' + @Term + N'%';

    ;WITH BorrowerMatches AS
    (
        SELECT TOP (@Top)
            b.BorrowerID,
            b.FirstName,
            b.LastName,
            b.SchoolIdNumber,
            CAST(NULL AS NVARCHAR(120)) AS MatchedAlias,
            0 AS Priority,
            b.BorrowerID AS SortId
        FROM dbo.TBorrowers AS b
        WHERE b.FirstName LIKE @Like
           OR b.LastName LIKE @Like
           OR (b.FirstName + N' ' + b.LastName) LIKE @Like
           OR ISNULL(b.SchoolIdNumber, N'') LIKE @Like
        ORDER BY b.LastName, b.FirstName, b.BorrowerID DESC

        UNION ALL

        SELECT TOP (@Top)
            b.BorrowerID,
            b.FirstName,
            b.LastName,
            b.SchoolIdNumber,
            a.Alias AS MatchedAlias,
            1 AS Priority,
            a.BorrowerAliasID AS SortId
        FROM dbo.TBorrowers AS b
        INNER JOIN dbo.TBorrowerAliases AS a ON a.BorrowerID = b.BorrowerID
        WHERE a.Alias LIKE @Like
        ORDER BY a.BorrowerAliasID DESC
    )
    SELECT TOP (@Top)
        RankedMatches.BorrowerID,
        RankedMatches.FirstName,
        RankedMatches.LastName,
        RankedMatches.SchoolIdNumber,
        RankedMatches.MatchedAlias
    FROM
    (
        SELECT m.*, ROW_NUMBER() OVER (PARTITION BY m.BorrowerID ORDER BY m.Priority, m.SortId DESC) AS RowNumber
        FROM BorrowerMatches AS m
    ) AS RankedMatches
    WHERE RankedMatches.RowNumber = 1
    ORDER BY RankedMatches.Priority, RankedMatches.LastName, RankedMatches.FirstName, RankedMatches.BorrowerID DESC;
END;
GO

IF OBJECT_ID('dbo.spCreateItem','P') IS NOT NULL DROP PROCEDURE dbo.spCreateItem;
GO
CREATE PROCEDURE dbo.spCreateItem
    @ItemName         NVARCHAR(120),
    @ItemNumber       NVARCHAR(60) = NULL,
    @IsSchoolOwned    BIT,
    @DepartmentID     INT = NULL,
    @Description      NVARCHAR(400) = NULL,
    @DuePolicy        NVARCHAR(30) = 'NEXT_DAY_6PM',
    @DueDaysOffset    INT = NULL,
    @DueHoursOffset   INT = NULL,
    @DueTime          TIME(0) = NULL,
    @FixedDueLocal    DATETIME2(0) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Policy NVARCHAR(30) = UPPER(LTRIM(RTRIM(ISNULL(@DuePolicy, N'NEXT_DAY_6PM'))));
    IF (@Policy NOT IN ('NEXT_DAY_6PM','OFFSET','FIXED','SEMESTER'))
    BEGIN
        SET @Policy = 'NEXT_DAY_6PM';
    END;

    IF (@Policy = 'NEXT_DAY_6PM')
    BEGIN
        SET @DueDaysOffset = 1;
        SET @DueHoursOffset = 0;
        SET @DueTime = '18:00';
        SET @FixedDueLocal = NULL;
    END;
    ELSE IF (@Policy = 'OFFSET')
    BEGIN
        IF (@DueDaysOffset IS NULL AND @DueHoursOffset IS NULL)
            SET @DueDaysOffset = 1;
        SET @FixedDueLocal = NULL;
    END;
    ELSE IF (@Policy = 'FIXED')
    BEGIN
        SET @DueDaysOffset = NULL;
        SET @DueHoursOffset = NULL;
    END;
    ELSE IF (@Policy = 'SEMESTER')
    BEGIN
        SET @DueDaysOffset = NULL;
        SET @DueHoursOffset = NULL;
        SET @DueTime = NULL;
    END;

    INSERT dbo.TItems
    (
        ItemName, ItemNumber, IsSchoolOwned, DepartmentID, Description,
        DuePolicy, DueDaysOffset, DueHoursOffset, DueTime, FixedDueLocal
    )
    VALUES
    (
        @ItemName, @ItemNumber, @IsSchoolOwned, @DepartmentID, @Description,
        @Policy, @DueDaysOffset, @DueHoursOffset, @DueTime, @FixedDueLocal
    );

    SELECT SCOPE_IDENTITY() AS ItemID;
END;
GO

IF OBJECT_ID('dbo.spUpdateBorrower','P') IS NOT NULL DROP PROCEDURE dbo.spUpdateBorrower;
GO
CREATE PROCEDURE dbo.spUpdateBorrower
    @BorrowerID     INT,
    @FirstName      NVARCHAR(50),
    @LastName       NVARCHAR(50),
    @SchoolIdNumber NVARCHAR(50) = NULL,
    @PhoneNumber    NVARCHAR(25) = NULL,
    @RoomNumber     NVARCHAR(25) = NULL,
    @Instructor     NVARCHAR(100) = NULL,
    @DepartmentID   INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TBorrowers
    SET FirstName = @FirstName,
        LastName = @LastName,
        SchoolIdNumber = @SchoolIdNumber,
        PhoneNumber = @PhoneNumber,
        RoomNumber = @RoomNumber,
        Instructor = @Instructor,
        DepartmentID = @DepartmentID
    WHERE BorrowerID = @BorrowerID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Borrower not found.', 16, 1);
    END;
END;
GO

IF OBJECT_ID('dbo.spCheckoutItem','P') IS NOT NULL DROP PROCEDURE dbo.spCheckoutItem;
GO
CREATE PROCEDURE dbo.spCheckoutItem
    @ItemID             INT,
    @BorrowerID         INT,
    @CheckoutLabTechID  INT,
    @DueUtc             DATETIME2(0) = NULL,
    @CheckoutNotes      NVARCHAR(400) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotItemName NVARCHAR(120),
            @SnapshotItemNumber NVARCHAR(60),
            @SnapshotIsSchoolOwned BIT,
            @SnapshotDepartmentName NVARCHAR(100);

    SELECT @SnapshotItemName = i.ItemName,
           @SnapshotItemNumber = i.ItemNumber,
           @SnapshotIsSchoolOwned = i.IsSchoolOwned,
           @SnapshotDepartmentName = d.DepartmentName
    FROM dbo.TItems AS i
    LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = i.DepartmentID
    WHERE i.ItemID = @ItemID;

    DECLARE @SnapshotBorrowerFirstName NVARCHAR(50),
            @SnapshotBorrowerLastName  NVARCHAR(50),
            @SnapshotSchoolIdNumber    NVARCHAR(50),
            @SnapshotPhoneNumber       NVARCHAR(25),
            @SnapshotRoomNumber        NVARCHAR(25),
            @SnapshotInstructor        NVARCHAR(100);

    SELECT @SnapshotBorrowerFirstName = b.FirstName,
           @SnapshotBorrowerLastName  = b.LastName,
           @SnapshotSchoolIdNumber    = b.SchoolIdNumber,
           @SnapshotPhoneNumber       = b.PhoneNumber,
           @SnapshotRoomNumber        = b.RoomNumber,
           @SnapshotInstructor        = b.Instructor
    FROM dbo.TBorrowers AS b
    WHERE b.BorrowerID = @BorrowerID;

    IF EXISTS (SELECT 1 FROM dbo.TItemLoans WHERE ItemID = @ItemID AND CheckinUtc IS NULL)
    BEGIN
        RAISERROR('Item is already checked out.', 16, 1);
        RETURN;
    END;

    INSERT dbo.TItemLoans
    (
        ItemID, BorrowerID, CheckoutLabTechID, DueUtc, CheckoutNotes,
        SnapshotBorrowerFirstName, SnapshotBorrowerLastName, SnapshotSchoolIdNumber,
        SnapshotPhoneNumber, SnapshotRoomNumber, SnapshotInstructor,
        SnapshotItemName, SnapshotItemNumber, SnapshotIsSchoolOwned, SnapshotDepartmentName
    )
    VALUES
    (
        @ItemID, @BorrowerID, @CheckoutLabTechID, @DueUtc, @CheckoutNotes,
        @SnapshotBorrowerFirstName, @SnapshotBorrowerLastName, @SnapshotSchoolIdNumber,
        @SnapshotPhoneNumber, @SnapshotRoomNumber, @SnapshotInstructor,
        @SnapshotItemName, @SnapshotItemNumber, @SnapshotIsSchoolOwned, @SnapshotDepartmentName
    );

    SELECT SCOPE_IDENTITY() AS ItemLoanID;
END;
GO

IF OBJECT_ID('dbo.spUpdateLoanDue','P') IS NOT NULL DROP PROCEDURE dbo.spUpdateLoanDue;
GO
CREATE PROCEDURE dbo.spUpdateLoanDue
    @ItemLoanID      INT,
    @DueUtc          DATETIME2(0) = NULL,
    @CheckoutNotes   NVARCHAR(400) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TItemLoans
    SET DueUtc = @DueUtc,
        CheckoutNotes = @CheckoutNotes
    WHERE ItemLoanID = @ItemLoanID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Loan not found.', 16, 1);
    END;
END;
GO

IF OBJECT_ID('dbo.spCheckinItem','P') IS NOT NULL DROP PROCEDURE dbo.spCheckinItem;
GO
CREATE PROCEDURE dbo.spCheckinItem
    @ItemLoanID        INT,
    @CheckinLabTechID  INT,
    @CheckinNotes      NVARCHAR(400) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TItemLoans
    SET CheckinUtc = SYSUTCDATETIME(),
        CheckinLabTechID = @CheckinLabTechID,
        CheckinNotes = @CheckinNotes
    WHERE ItemLoanID = @ItemLoanID
      AND CheckinUtc IS NULL;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Loan not found or already checked in.', 16, 1);
    END;
END;
GO

IF OBJECT_ID('dbo.spSaveItem','P') IS NOT NULL DROP PROCEDURE dbo.spSaveItem;
GO
CREATE PROCEDURE dbo.spSaveItem
    @ItemID         INT = NULL,
    @ItemName       NVARCHAR(120),
    @ItemNumber     NVARCHAR(60) = NULL,
    @IsSchoolOwned  BIT,
    @DepartmentID   INT = NULL,
    @Description    NVARCHAR(400) = NULL,
    @IsActive       BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @ItemID IS NULL
    BEGIN
        INSERT dbo.TItems (ItemName, ItemNumber, IsSchoolOwned, DepartmentID, Description, IsActive)
        VALUES (@ItemName, @ItemNumber, @IsSchoolOwned, @DepartmentID, @Description, @IsActive);

        SELECT SCOPE_IDENTITY() AS ItemID;
    END
    ELSE
    BEGIN
        UPDATE dbo.TItems
        SET ItemName = @ItemName,
            ItemNumber = @ItemNumber,
            IsSchoolOwned = @IsSchoolOwned,
            DepartmentID = @DepartmentID,
            Description = @Description,
            IsActive = @IsActive
        WHERE ItemID = @ItemID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Item not found.', 16, 1);
        END;
    END;
END;
GO

IF OBJECT_ID('dbo.spAddLoanNote','P') IS NOT NULL DROP PROCEDURE dbo.spAddLoanNote;
GO
CREATE PROCEDURE dbo.spAddLoanNote
    @ItemLoanID INT,
    @LabTechID  INT = NULL,
    @Note       NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TItemLoanNotes (ItemLoanID, LabTechID, Note)
    VALUES (@ItemLoanID, @LabTechID, @Note);

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    VALUES (@LabTechID, 'NOTE_ADD', 'TItemLoans', @ItemLoanID, @Note);
END;
GO

IF OBJECT_ID('dbo.spCreateServiceTicket','P') IS NOT NULL DROP PROCEDURE dbo.spCreateServiceTicket;
GO
CREATE PROCEDURE dbo.spCreateServiceTicket
    @PublicTicketID     NVARCHAR(20),
    @BorrowerID         INT = NULL,
    @ItemID             INT = NULL,
    @ItemLabel          NVARCHAR(120) = NULL,
    @Issue              NVARCHAR(1000),
    @AssignedLabTechID  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TServiceTickets (PublicTicketID, ItemID, BorrowerID, ItemLabel, Issue, AssignedLabTechID)
    VALUES (@PublicTicketID, @ItemID, @BorrowerID, @ItemLabel, @Issue, @AssignedLabTechID);

    SELECT SCOPE_IDENTITY() AS ServiceTicketID;
END;
GO

IF OBJECT_ID('dbo.spUpdateServiceTicket','P') IS NOT NULL DROP PROCEDURE dbo.spUpdateServiceTicket;
GO
CREATE PROCEDURE dbo.spUpdateServiceTicket
    @ServiceTicketID    INT,
    @AssignedLabTechID  INT = NULL,
    @ItemID             INT = NULL,
    @BorrowerID         INT = NULL,
    @ItemLabel          NVARCHAR(120) = NULL,
    @Issue              NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TServiceTickets
    SET AssignedLabTechID = @AssignedLabTechID,
        ItemID = @ItemID,
        BorrowerID = @BorrowerID,
        ItemLabel = @ItemLabel,
        Issue = ISNULL(@Issue, Issue)
    WHERE ServiceTicketID = @ServiceTicketID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Service ticket not found.', 16, 1);
    END;
END;
GO

IF OBJECT_ID('dbo.spSetServiceTicketStatus','P') IS NOT NULL DROP PROCEDURE dbo.spSetServiceTicketStatus;
GO
CREATE PROCEDURE dbo.spSetServiceTicketStatus
    @ServiceTicketID INT,
    @Status          NVARCHAR(30),
    @LabTechID       INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TServiceTickets
    SET Status = @Status
    WHERE ServiceTicketID = @ServiceTicketID;

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    VALUES (@LabTechID, 'TICKET_STATUS', 'TServiceTickets', @ServiceTicketID, @Status);
END;
GO

IF OBJECT_ID('dbo.spAddServiceTicketNote','P') IS NOT NULL DROP PROCEDURE dbo.spAddServiceTicketNote;
GO
CREATE PROCEDURE dbo.spAddServiceTicketNote
    @ServiceTicketID INT,
    @LabTechID       INT = NULL,
    @Note            NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.TServiceTicketNotes (ServiceTicketID, LabTechID, Note)
    VALUES (@ServiceTicketID, @LabTechID, @Note);

    INSERT dbo.TAuditLog (LabTechID, Action, Entity, EntityPrimaryKey, Details)
    VALUES (@LabTechID, 'NOTE_ADD', 'TServiceTickets', @ServiceTicketID, @Note);
END;
GO

/* -----------------------------------------------------------------------------
   Section: Stored Procedures - Reporting & Search
----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.spGetDashboardStats','P') IS NOT NULL DROP PROCEDURE dbo.spGetDashboardStats;
GO
CREATE PROCEDURE dbo.spGetDashboardStats
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CONVERT(DATE, SYSUTCDATETIME());
    DECLARE @StartOfDay DATETIME2(0) = CAST(@Today AS DATETIME2(0));
    DECLARE @EndOfDay DATETIME2(0) = DATEADD(DAY, 1, @StartOfDay);

    SELECT
        outNow = COALESCE(SUM(CASE WHEN CheckinUtc IS NULL THEN 1 ELSE 0 END), 0),
        dueToday = COALESCE(SUM(CASE WHEN CheckinUtc IS NULL AND DueUtc >= @StartOfDay AND DueUtc < @EndOfDay THEN 1 ELSE 0 END), 0),
        repairs = (SELECT COUNT(*) FROM dbo.TServiceTickets WHERE Status IN ('Diagnosing','Awaiting Parts','Ready for Pickup','Quarantined')),
        overdue = COALESCE(SUM(CASE WHEN CheckinUtc IS NULL AND DueUtc IS NOT NULL AND DueUtc < SYSUTCDATETIME() THEN 1 ELSE 0 END), 0)
    FROM dbo.TItemLoans;
END;
GO

IF OBJECT_ID('dbo.spGetRecentLoans','P') IS NOT NULL DROP PROCEDURE dbo.spGetRecentLoans;
GO
CREATE PROCEDURE dbo.spGetRecentLoans
    @Top          INT = 50,
    @StatusFilter NVARCHAR(30) = NULL,
    @Search       NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LoanCTE AS
    (
        SELECT TOP (@Top)
            l.ItemLoanID,
            l.ItemID,
            l.BorrowerID,
            l.CheckoutUtc,
            l.DueUtc,
            l.CheckinUtc,
            l.CheckoutNotes,
            l.SnapshotBorrowerFirstName,
            l.SnapshotBorrowerLastName,
            l.SnapshotSchoolIdNumber,
            l.SnapshotRoomNumber,
            l.SnapshotItemName,
            l.SnapshotItemNumber,
            l.SnapshotDepartmentName,
            CASE
                WHEN l.CheckinUtc IS NOT NULL THEN N'Returned'
                WHEN l.DueUtc IS NOT NULL AND l.DueUtc < SYSUTCDATETIME() THEN N'Overdue'
                ELSE N'On Time'
            END AS LoanStatus
        FROM dbo.TItemLoans AS l
        ORDER BY l.CheckoutUtc DESC, l.ItemLoanID DESC
    )
    SELECT *
    FROM LoanCTE
    WHERE (@StatusFilter IS NULL OR LoanStatus = @StatusFilter OR (@StatusFilter = N'All'))
      AND (
            @Search IS NULL OR @Search = N'' OR
            LoanCTE.SnapshotBorrowerFirstName LIKE N'%' + @Search + N'%' OR
            LoanCTE.SnapshotBorrowerLastName LIKE N'%' + @Search + N'%' OR
            ISNULL(LoanCTE.SnapshotSchoolIdNumber, N'') LIKE N'%' + @Search + N'%' OR
            ISNULL(LoanCTE.SnapshotItemName, N'') LIKE N'%' + @Search + N'%' OR
            ISNULL(LoanCTE.SnapshotItemNumber, N'') LIKE N'%' + @Search + N'%'
          )
    ORDER BY LoanCTE.CheckoutUtc DESC;
END;
GO

IF OBJECT_ID('dbo.spGetServiceTickets','P') IS NOT NULL DROP PROCEDURE dbo.spGetServiceTickets;
GO
CREATE PROCEDURE dbo.spGetServiceTickets
    @Top          INT = 50,
    @StatusFilter NVARCHAR(30) = NULL,
    @Search       NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH TicketCTE AS
    (
        SELECT TOP (@Top)
            st.ServiceTicketID,
            st.PublicTicketID,
            st.ItemID,
            st.BorrowerID,
            st.ItemLabel,
            st.Issue,
            st.LoggedUtc,
            st.AssignedLabTechID,
            st.Status,
            b.FirstName AS BorrowerFirstName,
            b.LastName  AS BorrowerLastName,
            i.ItemName,
            lt.FirstName AS AssignedFirstName,
            lt.LastName  AS AssignedLastName
        FROM dbo.TServiceTickets AS st
        LEFT JOIN dbo.TBorrowers AS b ON b.BorrowerID = st.BorrowerID
        LEFT JOIN dbo.TItems AS i      ON i.ItemID = st.ItemID
        LEFT JOIN dbo.TLabTechs AS lt  ON lt.LabTechID = st.AssignedLabTechID
        ORDER BY st.LoggedUtc DESC, st.ServiceTicketID DESC
    )
    SELECT *
    FROM TicketCTE
    WHERE (@StatusFilter IS NULL OR Status = @StatusFilter OR (@StatusFilter = 'all') OR (@StatusFilter = 'All'))
      AND (
            @Search IS NULL OR @Search = N'' OR
            PublicTicketID LIKE N'%' + @Search + N'%' OR
            COALESCE(ItemName, ItemLabel, N'') LIKE N'%' + @Search + N'%' OR
            COALESCE(BorrowerFirstName, N'') LIKE N'%' + @Search + N'%' OR
            COALESCE(BorrowerLastName, N'') LIKE N'%' + @Search + N'%' OR
            COALESCE(AssignedFirstName, N'') LIKE N'%' + @Search + N'%' OR
            COALESCE(AssignedLastName, N'') LIKE N'%' + @Search + N'%'
          )
    ORDER BY TicketCTE.LoggedUtc DESC;
END;
GO

IF OBJECT_ID('dbo.spFindBorrowers','P') IS NOT NULL DROP PROCEDURE dbo.spFindBorrowers;
GO
CREATE PROCEDURE dbo.spFindBorrowers
    @Search NVARCHAR(120),
    @Top    INT = 20
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top)
        b.BorrowerID,
        b.FirstName,
        b.LastName,
        b.SchoolIdNumber,
        b.PhoneNumber,
        b.RoomNumber,
        b.Instructor,
        d.DepartmentName
    FROM dbo.TBorrowers AS b
    LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = b.DepartmentID
    WHERE b.FirstName LIKE N'%' + @Search + N'%'
       OR b.LastName LIKE N'%' + @Search + N'%'
       OR ISNULL(b.SchoolIdNumber, N'') LIKE N'%' + @Search + N'%'
    ORDER BY b.LastName, b.FirstName;
END;
GO

IF OBJECT_ID('dbo.spFindItems','P') IS NOT NULL DROP PROCEDURE dbo.spFindItems;
GO
CREATE PROCEDURE dbo.spFindItems
    @Search NVARCHAR(120),
    @Top    INT = 20
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top)
        i.ItemID,
        i.ItemName,
        i.ItemNumber,
        i.IsSchoolOwned,
        d.DepartmentName,
        i.IsActive
    FROM dbo.TItems AS i
    LEFT JOIN dbo.TDepartments AS d ON d.DepartmentID = i.DepartmentID
    WHERE i.ItemName LIKE N'%' + @Search + N'%'
       OR ISNULL(i.ItemNumber, N'') LIKE N'%' + @Search + N'%'
    ORDER BY i.ItemName;
END;
GO

IF OBJECT_ID('dbo.spGetAuditLog','P') IS NOT NULL DROP PROCEDURE dbo.spGetAuditLog;
GO
CREATE PROCEDURE dbo.spGetAuditLog
    @Top INT = 100
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top)
        a.TraceID,
        a.EventUtc,
        a.LabTechID,
        lt.FirstName,
        lt.LastName,
        a.Action,
        a.Entity,
        a.EntityPrimaryKey,
        a.Details
    FROM dbo.TAuditLog AS a
    LEFT JOIN dbo.TLabTechs AS lt ON lt.LabTechID = a.LabTechID
    ORDER BY a.EventUtc DESC;
END;
GO
