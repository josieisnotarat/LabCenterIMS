-- Loans (no item number usage)
USE dbLabCenter;

-- Loan #1 :: Jonathan Ehlman -> Everything
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-05-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Everything'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726743';

-- Loan #2 :: " Wagner -> Dignity
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-05-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dignity'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '588443';

-- Loan #3 :: " Wagner -> Dignity
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-05-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dignity'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '588443';

-- Loan #4 :: Clarence Stepp -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '475875';

-- Loan #5 :: Jessica Cortez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704399';

-- Loan #6 :: Jessica Cortez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704399';

-- Loan #7 :: Ryan Kellam -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706770';

-- Loan #8 :: Ryan Kellam -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706770';

-- Loan #9 :: Quintan Mincy -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '632672';

-- Loan #10 :: Quintan Mincy -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '632672';

-- Loan #11 :: Andrew Morlan -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #12 :: Andrew Morlan -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #13 :: Will Smith -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #14 :: Will Smith -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #15 :: Spencer Spek -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683043';

-- Loan #16 :: Spencer Spek -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683043';

-- Loan #17 :: Bryce Washick -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587445';

-- Loan #18 :: Bryce Washick -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587445';

-- Loan #19 :: Ben Wylie -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587114';

-- Loan #20 :: Ben Wylie -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587114';

-- Loan #21 :: William Smith -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #22 :: William Smith -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #23 :: Clarance Stepp -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '475875';

-- Loan #24 :: Clarance Stepp -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '475875';

-- Loan #25 :: Da'Quan Allen -> Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #26 :: Da'Quan Allen -> Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #27 :: Da'Quan Allen -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #28 :: Da'Quan Allen -> Trainer
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #29 :: Clarance Stepp -> Trainer 26
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 26'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '475875';

-- Loan #30 :: Clarance Stepp -> Trainer 26
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 26'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '475875';

-- Loan #31 :: Da'Quan Allen -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #32 :: Da'Quan Allen -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-06-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #33 :: Ben Wiley -> 7400 (NAND)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7400 (NAND)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587114';

-- Loan #34 :: Ben Wiley -> 7400 (NAND)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7400 (NAND)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '587114';

-- Loan #35 :: Donald Brill -> Resistors and Orange Board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Resistors and Orange Board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #36 :: Donald Brill -> Resistors and Orange Board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Resistors and Orange Board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #37 :: Quintan Mincy -> Trainor 26
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainor 26'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '632672';

-- Loan #38 :: Quintan Mincy -> Trainor 26
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-07-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainor 26'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '632672';

-- Loan #39 :: Donald Brill -> Red LED, 7408, 220 Resistor
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Red LED, 7408, 220 Resistor'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #40 :: Donald Brill -> Red LED, 7408, 220 Resistor
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Red LED, 7408, 220 Resistor'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #41 :: Kantima Egngtion -> Reistors
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #42 :: Kantima Egngtion -> Reistors
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #43 :: Donald Brill -> Reistors and bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors and bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #44 :: Donald Brill -> Reistors and bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors and bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '483907';

-- Loan #45 :: Kantima Egngtion -> Reistors, LED and bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors, LED and bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #46 :: Kantima Egngtion -> Reistors, LED and bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Reistors, LED and bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #47 :: Da'Quan Allen -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #48 :: Da'Quan Allen -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #49 :: Mikayla Harris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '620929';

-- Loan #50 :: Mikayla Harris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '620929';

-- Loan #51 :: Quintanilla Karen -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716176';

-- Loan #52 :: Quintanilla Karen -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716176';

-- Loan #53 :: Mussa Kebe -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #54 :: Moussa Kebe -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #55 :: Erin Moeller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '700224';

-- Loan #56 :: Erin Moeller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '700224';

-- Loan #57 :: Evan Selles -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #58 :: Evan Selles -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #59 :: Tanner Sharpe -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '679236';

-- Loan #60 :: Tanner Sharpe -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '679236';

-- Loan #61 :: Joey Tomamichel -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '701563';

-- Loan #62 :: Joey Tomamichel -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '701563';

-- Loan #63 :: Tanner Sharpe -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '679236';

-- Loan #64 :: Tanner Sharpe -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '679236';

-- Loan #65 :: Da'Quan Allen -> Trainer 4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #66 :: Da'Quan Allen -> Trainer 4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #67 :: Wesley Ortiz -> MSP430+USB cable
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '703415';

-- Loan #68 :: Wesley Ortiz -> MSP430+USB cable
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '703415';

-- Loan #69 :: Quintanilla Karen -> MSP430+USB cable: #1
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #1'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716176';

-- Loan #70 :: Quintanilla Karen -> MSP430+USB cable: #1
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #1'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716176';

-- Loan #71 :: Moussa Kebe -> MSP430+USB cable: #2
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #2'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #72 :: Moussa Kebe -> MSP430+USB cable: #2
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #2'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #73 :: Da'Quan Allen -> MSP430+USB cable: #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-07 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #74 :: Da'Quan Allen -> MSP430+USB cable: #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-07 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430+USB cable: #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #75 :: Alexander Bozhenov -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #76 :: Alexander Bozhenov -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #77 :: Jess Cortez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704399';

-- Loan #78 :: Jess Cortez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704399';

-- Loan #79 :: Andrew Day -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '507792';

-- Loan #80 :: Andrew Day -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '507792';

-- Loan #81 :: Mason Earls -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716207';

-- Loan #82 :: Mason Earls -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716207';

-- Loan #83 :: Max Hall -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #84 :: Max Hall -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #85 :: Damon Madaris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #86 :: Damon Madaris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #87 :: Cole Quitter -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680317';

-- Loan #88 :: Cole Quitter -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680317';

-- Loan #89 :: Tanner Thornberry -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709999';

-- Loan #90 :: Tanner Thornberry -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709999';

-- Loan #91 :: Minaj Waeba -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #92 :: Minaj Waeba -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #93 :: Katie Wernicke -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #94 :: Katie Wernicke -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #95 :: John Wilson -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704343';

-- Loan #96 :: John Wilson -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704343';

-- Loan #97 :: Katie Wernicke -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #98 :: Katie Wernicke -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #99 :: Max Hall -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #100 :: Max Hall -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #101 :: Damon Madaris -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #102 :: Damon Madaris -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #103 :: Mickaela Harris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '620929';

-- Loan #104 :: Mickaela Harris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '620929';

-- Loan #105 :: Evan Sellers -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #106 :: Evan Sellers -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #107 :: Da'Quan Allen -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #108 :: Da'Quan Allen -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #109 :: Damon Madaris -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #110 :: Damon Madaris -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #111 :: Katie Wernicke -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #112 :: Katie Wernicke -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #113 :: Max Paul -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #114 :: Max Paul -> Trainer #4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #115 :: Da'Quan Allen -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #116 :: Da'Quan Allen -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #117 :: Max Paul -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #118 :: Max Paul -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #119 :: Da'Quan Allen -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #120 :: Da'Quan Allen -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-09-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #121 :: Max Paul -> Trainer #04
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #04'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #122 :: Max Paul -> Trainer #04
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #04'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #123 :: Damon Madaris -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #124 :: Damon Madaris -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #125 :: Damon Madaris -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #126 :: Damon Madaris -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #127 :: Max Paul -> Trainer #04
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #04'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #128 :: Max Paul -> Trainer #04
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #04'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #129 :: Damon Madaris -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #130 :: Damon Madaris -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #131 :: Max Paul -> Trainer #15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #132 :: Max Paul -> Trainer #15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-10-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #133 :: John Wilson -> 22V10 chips
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '22V10 chips'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704343';

-- Loan #134 :: John Wilson -> 22V10 chips
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '22V10 chips'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '704343';

-- Loan #135 :: Damon Madaris -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #136 :: Damon Madaris -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #137 :: Max Paul -> Trainer #15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #138 :: Max Paul -> Trainer #15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #139 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #140 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #141 :: Damon Madaris -> Dig Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #142 :: Damon Madaris -> Dig Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #143 :: Moussa Kebe -> Dig Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #144 :: Moussa Kebe -> Dig Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-11-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702088';

-- Loan #145 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-12-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #146 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-12-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #147 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #148 :: Max Hall -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2023-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #149 :: Andrew Slipper -> Instrumentation Kit #06
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #06'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #150 :: Sam Beccaccio -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #151 :: Sam Beccaccio -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #152 :: Max Hall -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #153 :: Max Hall -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #154 :: Minaj Waeba -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #155 :: Katie Wernicke -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #156 :: Katie Wernicke -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '683161';

-- Loan #157 :: Sam Beccaccio -> Dig Trainer 25
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 25'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #158 :: Sam Beccaccio -> Dig Trainer 25
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 25'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #159 :: Max Hall -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #160 :: Max Hall -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #161 :: Kyle Hedlund -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '664114';

-- Loan #162 :: Kyle Hedlund -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '664114';

-- Loan #163 :: Jorden Hess -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #164 :: Jorden Hess -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #165 :: Galyam Korbogo -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #166 :: Galyam Korbogo -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #167 :: Damaind Madaris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #168 :: Damaind Madaris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #169 :: Sean Miller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #170 :: Tyler Miller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '506049';

-- Loan #171 :: Sean Miller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #172 :: Tyler Miller -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '506049';

-- Loan #173 :: William Smith -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #174 :: William Smith -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #175 :: Simon Valdez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #176 :: Simon Valdez -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #177 :: Jorden Hess -> Dig Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #178 :: Jorden Hess -> Dig Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #179 :: Galyam Korbogo -> Dig Trainer 25
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 25'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #180 :: Galyam Korbogo -> Dig Trainer 25
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 25'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #181 :: Simon Valdez -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #182 :: Simon Valdez -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #183 :: Sean Miller -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #184 :: Sean Miller -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #185 :: Damaind Madaris -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #186 :: Damaind Madaris -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #187 :: Kyle Hedlund -> Dig Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '664114';

-- Loan #188 :: Kyle Hedlund -> Dig Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '664114';

-- Loan #189 :: William Smith -> Dig Trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #190 :: William Smith -> Dig Trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #191 :: Tyler Miller -> Dig Trainer 9
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 9'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '506049';

-- Loan #192 :: Tyler Miller -> Dig Trainer 9
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 9'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '506049';

-- Loan #193 :: Sam Beccaccio -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #194 :: Sam Beccaccio -> Dig Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #195 :: Max Hall -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #196 :: Max Hall -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #197 :: Noah Patsfall -> Dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '658471';

-- Loan #198 :: Max Hall -> Dig Kit (temporary)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit (temporary)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #199 :: Max Hall -> Dig Kit (temporary)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit (temporary)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #200 :: Sam Beccaccio -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #201 :: Sam Beccaccio -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-01-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #202 :: Damaind Madaris -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #203 :: Damaind Madaris -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #204 :: Alexander Bozhenov -> Dig Kit (temporary)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit (temporary)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #205 :: Alexander Bozhenov -> Dig Kit (temporary)
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit (temporary)'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #206 :: Alexander Bozhenov -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #207 :: Alexander Bozhenov -> Dig Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #208 :: Sam Beccaccio -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #209 :: Sam Beccaccio -> Dig Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #210 :: Sam Beccaccio -> Dig Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #211 :: Sam Beccaccio -> Dig Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #212 :: Minaj Waeba -> Dig Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #213 :: Minaj Waeba -> Dig Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #214 :: Sam Beccaccio -> Dig Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #215 :: Sam Beccaccio -> Dig Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #216 :: Alexander Bozhenov -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #217 :: Alexander Bozhenov -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '702964';

-- Loan #218 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #219 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #220 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #221 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #222 :: Sam Beccaccio -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #223 :: Sam Beccaccio -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #224 :: Sam Beccaccio -> Motor kit 6
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor kit 6'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #225 :: Sam Beccaccio -> Motor kit 6
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor kit 6'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #226 :: Evan Sellers -> Motor Kit 7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #227 :: Evan Sellers -> Motor Kit 7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-02-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696723';

-- Loan #228 :: Galyam Korbeogo -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #229 :: Galyam Korbeogo -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #230 :: Damaind Madaris -> Trainor 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainor 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #231 :: Damaind Madaris -> Trainor 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainor 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #232 :: Sam Beccaccio -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #233 :: Sam Beccaccio -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #234 :: Damen Madaris -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #235 :: Damen Madaris -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #236 :: Sean Miller -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #237 :: Sean Miller -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #238 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #239 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #240 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #241 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #242 :: Daquan Allen -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #243 :: Daquan Allen -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '696703';

-- Loan #244 :: Sam Beccaccio -> Display 10, 74LS190
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Display 10, 74LS190'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #245 :: Sam Beccaccio -> Display 10, 74LS190
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Display 10, 74LS190'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #246 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #247 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-03-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #248 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #249 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #250 :: Minaj Waeba -> 7 seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7 seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #251 :: Minaj Waeba -> 7 seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7 seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #252 :: Sam Beccaccio -> Trainer 3, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #253 :: Sam Beccaccio -> Trainer 3, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #254 :: Sean Miller -> Dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #255 :: Sean Miller -> Dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '303364';

-- Loan #256 :: Damen Madaris -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #257 :: Damen Madaris -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #258 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #259 :: Minaj Waeba -> Trainer 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #260 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #261 :: Sam Beccaccio -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #262 :: Jasmine Hurst -> HP charger
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'HP charger'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '495148';

-- Loan #263 :: Jasmine Hurst -> HP charger
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'HP charger'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '495148';

-- Loan #264 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #265 :: Damen Madaris -> Trainer 30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #266 :: Sam Beccaccio -> Trainer 3, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #267 :: Sam Beccaccio -> Trainer 3, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 3, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #268 :: Manoj Waiba -> Trainer 1, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 1, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #269 :: Manoj Waiba -> Trainer 1, 7seg display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 1, 7seg display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #270 :: Damen Madaris -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #271 :: Damen Madaris -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-04-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #272 :: Manoj Waiba -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-05-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706645';

-- Loan #273 :: Damen Madaris -> Calculator
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Calculator'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #274 :: Alex Masraum -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699106';

-- Loan #275 :: Isabella Carmen -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #276 :: Joshua Hoffman -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '739273';

-- Loan #277 :: Quincy Milton -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '598689';

-- Loan #278 :: Dakota Risch -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '682898';

-- Loan #279 :: Jacob Steinmetz -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732516';

-- Loan #280 :: Quincy Milton -> Trainer 15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '598689';

-- Loan #281 :: Dakota Risch -> Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '682898';

-- Loan #282 :: Joshua Hoffman -> Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '739273';

-- Loan #283 :: Jacob Steinmetz -> Trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-26 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732516';

-- Loan #284 :: Aaron Arocho -> bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671792';

-- Loan #285 :: Aaron Arocho -> instrumentation kit 7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671792';

-- Loan #286 :: Zemirah Torrey -> instrumentation kit 12
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 12'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #287 :: Colin Mccloy -> bread board
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'bread board'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #288 :: Andrew Osburg -> instrumentation kit 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '664251';

-- Loan #289 :: Colin Mccloy -> instrumentation kit 4
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 4'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #290 :: Rathana Kreal -> instrumentation kit 6
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 6'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '151430';

-- Loan #291 :: Isabella Carmen -> instrumentation kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #292 :: Zemirah Torrey -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #293 :: Colin Mccloy -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #294 :: Damen Madaris -> Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #295 :: Kantima Egngtion -> Breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #296 :: Kantima Egngtion -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #297 :: Jorden Hess -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #298 :: Damen Madaris -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #299 :: Andrew Moreland -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #300 :: William Smith -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #301 :: Kantima Egngtion -> MSP430 #1
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'MSP430 #1'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #302 :: Andrew Moreland -> Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #303 :: Andrew Sliper -> Trainer 27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #304 :: Andrew Slipper -> Motor Kit #6
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #6'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #305 :: Sam Beccaccio -> Motor Kit #7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #306 :: Nelson Malakada -> Motor Kit #8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #307 :: Andrew Slipper -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #308 :: Zemirah Torrey -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-08-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #309 :: Andrew Slipper -> Instrumentation Kit #1
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #1'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #310 :: Andrew Slipper -> Motor Kit #8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717574';

-- Loan #311 :: Aaron Arocho -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671792';

-- Loan #312 :: Zemirah Torrey -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #313 :: Garrett Hornsby -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716991';

-- Loan #314 :: Galyam Korbogo -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #315 :: Jarod Moore -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #316 :: Jonathan Nemi -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731814';

-- Loan #317 :: Nicholas Odgers -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695941';

-- Loan #318 :: Justin Owens -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #319 :: Noah Patsfall -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '658471';

-- Loan #320 :: Tyler Vrh -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '743939';

-- Loan #321 :: Caroline Wilbur -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #322 :: Justin Owens -> Trainer #15
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #15'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #323 :: Garrett Hornsby -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716991';

-- Loan #324 :: Andrew Moreland -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #325 :: Justin Owens -> Trainer #27
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #27'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #326 :: Jarod Moore -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #327 :: Galyam Korbogo -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #328 :: Caroline Wilbur -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #329 :: Damen Madaris -> Trainer #9
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #9'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #330 :: Nicholas Odgers -> Trainer #9
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #9'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695941';

-- Loan #331 :: Abagial Atwood -> Instrumentation Kit #9
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #9'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '722073';

-- Loan #332 :: Nelson Makada -> Instrumentation Kit #5, Breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #5, Breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #333 :: Nelson Makada -> Digital Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Digital Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #334 :: Justin Owens -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #335 :: Jarod Moore -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #336 :: Damen Madaris -> Trainer #43
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #43'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #337 :: Bryce Drake -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708890';

-- Loan #338 :: Dakota Risch -> Trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '682898';

-- Loan #339 :: Nelson Malakada -> Motor Kit #8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #340 :: Abagial Atwood -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '722073';

-- Loan #341 :: Damen Madaris -> Trainer #03
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #03'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #342 :: Caroline Wilbur -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #343 :: Isabella Carmen -> motor and control kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'motor and control kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #344 :: Bryce Drake -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708890';

-- Loan #345 :: Eric Medly -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #346 :: Omar Sheta -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #347 :: Omar Sheta -> Trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #348 :: Bryce Drake -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708890';

-- Loan #349 :: Damen Madaris -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #350 :: Caroline Wilbur -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #351 :: Omar Sheta -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-09-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #352 :: Damen Madaris -> Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #353 :: Avana Hilton -> Microcontroller #2
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Microcontroller #2'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '656484';

-- Loan #354 :: Omar Sheta -> Trainer #3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-07 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #355 :: Rathana Kreal -> Soldering Kit #17
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Soldering Kit #17'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '151430';

-- Loan #356 :: Damen Madaris -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #357 :: Zemirah Torrey -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #358 :: Nelson Makada -> Instrumentation kit #05
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation kit #05'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #359 :: Damen Madaris -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #360 :: Caroline Wilbur -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-16 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #361 :: Zemirah Torrey -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #362 :: Zemirah Torrey -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #363 :: Zemirah Torrey -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #364 :: Zemirah Torrey -> trainer #43
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #43'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #365 :: Damen Madaris -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #366 :: Nelson Malakada -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #367 :: Caroline Wilbur -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #368 :: Sam Beccaccio -> Motor Kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #369 :: Isabella Carmen -> motor and control kit 6
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'motor and control kit 6'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #370 :: Sam Beccaccio -> Motor Kit 7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #371 :: Zemirah Torrey -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #372 :: Sam Beccaccio -> Motor Kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-10-31 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #373 :: Eric Medly -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #374 :: Omar Sheta -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #375 :: Eric Medly -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #376 :: Caroline Wilbur -> trainer 31 breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31 breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #377 :: Isabella Carmen -> motor and control kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'motor and control kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #378 :: Zemirah Torrey -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #379 :: Caroline Wilbur -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #380 :: Galyan Korbeogo -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-06 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #381 :: Nelson Malakada -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-07 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #382 :: Sam Beccaccio -> Motor Kit 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-12 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #383 :: Jorden Hess -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709439';

-- Loan #384 :: Andrew Moreland -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #385 :: William Smith -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #386 :: Avana Hilton -> Trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '656484';

-- Loan #387 :: Caroline Wilbur -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #388 :: Sam Beccaccio -> Motor Kit 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #389 :: Damen Madaris -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '719233';

-- Loan #390 :: Omar Sheta -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #391 :: Alexander Taylor -> 2 probes +breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '2 probes +breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '712169';

-- Loan #392 :: Isabella Carmen -> motor and control kit 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'motor and control kit 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '706242';

-- Loan #393 :: Sam Beccaccio -> Motor Kit 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-19 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '730163';

-- Loan #394 :: Amy Gutman Fuentes -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '231805';

-- Loan #395 :: Andrew Lakes -> probes x3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'probes x3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709925';

-- Loan #396 :: Omar Sheta -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-11-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #397 :: Omar Sheta -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-02 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717561';

-- Loan #398 :: Zemirah Torrey -> Trainer #03
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #03'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #399 :: Zemirah Torrey -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #400 :: Galyan Korbeogo -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #401 :: Caroline Wilbur -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #402 :: Kantima Egngtion -> 7 segment display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7 segment display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #403 :: Kantima Egngtion -> 74190 chip
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '74190 chip'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #404 :: Kantima Egngtion -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-05 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695527';

-- Loan #405 :: Zemirah Torrey -> Trainer #09
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #09'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '680996';

-- Loan #406 :: Andrew Moreland -> breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '709786';

-- Loan #407 :: Jackson Owens -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #408 :: Galyam Korbeogo -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #409 :: Caroline Wilbur -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2024-12-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732670';

-- Loan #410 :: Jonah Baldwin -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #411 :: Gerald Cummings -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #412 :: Evan Frank -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '682677';

-- Loan #413 :: Nathan Mcclellan -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #414 :: Evan Frank -> Trainer #30
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #30'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '682677';

-- Loan #415 :: Nathan Mcclellan -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #416 :: Jonah Baldwin -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #417 :: Gerald Cummings -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #418 :: Ben Weber -> instrumentation kit 13
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 13'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #419 :: Ethan Alexander -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738862';

-- Loan #420 :: Allison Carr -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '727389';

-- Loan #421 :: Anthony Franks -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '735376';

-- Loan #422 :: Joshua Hoffman -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '739273';

-- Loan #423 :: Miles Landon -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '687366';

-- Loan #424 :: Benie Lumbuambu -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #425 :: Collin Mccloy -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #426 :: Eric Medley -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #427 :: Nicholas Odgers -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695941';

-- Loan #428 :: Lucy Wang -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '727050';

-- Loan #429 :: Cecil Payne -> Instrumentation Kit #04
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #04'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '721046';

-- Loan #430 :: Logan Grever -> Instrumentation Kit #12
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Instrumentation Kit #12'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731464';

-- Loan #431 :: Jonah Baldwin -> instrumentation kit #14
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit #14'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #432 :: Jesse Cooper -> instrumentation kit 1
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 1'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '735841';

-- Loan #433 :: Adrian Bacon -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '633360';

-- Loan #434 :: Caleb Brennan -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #435 :: Simon Valdez -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #436 :: Galyam Korbogo -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #437 :: Justin Owens -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #438 :: Nelson Makada -> instrumentation kit 3
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'instrumentation kit 3'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #439 :: Nelson Makada -> phillips screwdriver
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'phillips screwdriver'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '711504';

-- Loan #440 :: Simon Valdez -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '717461';

-- Loan #441 :: Miles Landon -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '687366';

-- Loan #442 :: Benie Lumbuambu -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #443 :: Lucy Wang -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '727050';

-- Loan #444 :: Caleb Brennan -> trainer 8
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 8'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #445 :: Cecil Payne -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '721046';

-- Loan #446 :: Gerald Cummings -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #447 :: Jonah Baldwin -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #448 :: Nathan Mcclellan -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-27 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #449 :: Miles Landon -> trainer 09
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 09'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '687366';

-- Loan #450 :: Caleb Brennan -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #451 :: Benie Lumbuambu -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #452 :: Lucy Wang -> trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-01-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '727050';

-- Loan #453 :: Nathan Mcclellan -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #454 :: Gerald Cummings -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #455 :: Jonah Baldwin -> trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #456 :: Caleb Brennan -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #457 :: Jonah Baldwin -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #458 :: Gerald Cummings -> Trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #459 :: Nathan Mcclellan -> Trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #460 :: Benie Lumbuambu -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #461 :: Adrian Bacon -> trainer 31 + temp deg kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31 + temp deg kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '633360';

-- Loan #462 :: Jonah Baldwin -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732209';

-- Loan #463 :: Caleb Brennan -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #464 :: Benjamin Weber -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-13 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #465 :: Adrian Bacon -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '633360';

-- Loan #466 :: Joshua Hoffman -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '739273';

-- Loan #467 :: Galyam Korbogo -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #468 :: Justin Owens -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #469 :: Eric Medley -> 7seg  display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg  display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #470 :: Nicholas Odgers -> 7segment display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7segment display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695941';

-- Loan #471 :: Joshua Hoffman -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '739273';

-- Loan #472 :: Galyam Korbogo -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '725150';

-- Loan #473 :: Justin Owens -> 7seg
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '708026';

-- Loan #474 :: Eric Medley -> 7seg  display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7seg  display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '726553';

-- Loan #475 :: Nicholas Odgers -> 7segment display
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = '7segment display'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '695941';

-- Loan #476 :: Benie Lumbuambu -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #477 :: Caleb Brennan -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #478 :: Collin Mccloy -> Trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-02-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #479 :: Max Hall -> motor kit #4, multimeter
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'motor kit #4, multimeter'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '716944';

-- Loan #480 :: Cecil Payne -> Motor Kit #7, Multimeter
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Motor Kit #7, Multimeter'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '721046';

-- Loan #481 :: Gerald Cummings -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #482 :: Nathan Mcclellan -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #483 :: William Smith -> Various hookup wires for MSP430
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Various hookup wires for MSP430'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '678189';

-- Loan #484 :: Caleb Brennan -> trainer 32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #485 :: Benie Lumbuambu -> trainer 42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-04 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #486 :: Caleb Brennan -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-11 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #487 :: Gerald Cummings -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #488 :: Nathan Mcclellan -> trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #489 :: Caleb Brennan -> Trainer #09
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #09'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #490 :: Collin Mccloy -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738133';

-- Loan #491 :: Benie Lumbuambu -> Tranier #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-18 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Tranier #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #492 :: Nathan Mcclellan -> trainer #09
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #09'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #493 :: Gerald Cummings -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #494 :: Caleb Brennan -> Trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '617633';

-- Loan #495 :: Benie Lumbuambu -> Tranier #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Tranier #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #496 :: Nathan Mcclellan -> trainer #09
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-31 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #09'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #497 :: Gerald Cummings -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-03-31 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #498 :: Nathan Mcclellan -> trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-01 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #499 :: Gerald Cummings -> Trainer #08
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-07 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #08'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #500 :: Benie Lumbuambu -> Trainer #41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #501 :: Erin Molar -> soldering kit #16
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-09 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'soldering kit #16'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '700224';

-- Loan #502 :: Nathan Mcclellan -> trainer #08
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #08'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #503 :: Gerald Cummings -> Trainer #32
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #32'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #504 :: Benie Lumbuambu -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #505 :: Benie Lumbuambu -> soldering kit 35
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-17 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'soldering kit 35'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #506 :: Gerald Cummings -> Trainer #42
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-21 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #42'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #507 :: Benie Lumbuambu -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-22 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #508 :: Tyler Sansone -> Soldering Kit #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Soldering Kit #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '721045';

-- Loan #509 :: Benjamin Weber -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-23 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #510 :: Jason Stanley -> solder kit 12, breadboard
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 12, breadboard'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '676359';

-- Loan #511 :: Nathan Mcclellan -> trainer #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #512 :: Nathan Mcclellan -> trainer #08
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #08'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '671816';

-- Loan #513 :: Gerald Cummings -> Trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '741979';

-- Loan #514 :: Benie Lumbuambu -> trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-29 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '699442';

-- Loan #515 :: Arthur Viirchanko -> solder kit 02
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-04-30 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 02'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '749072';

-- Loan #516 :: Quincy Milton -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-05-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '598689';

-- Loan #517 :: Steven Mose -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-05-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732042';

-- Loan #518 :: Steven Mose -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-05-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '732042';

-- Loan #519 :: Daniel Hoffer -> dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-05-20 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '754286';

-- Loan #520 :: Russ Wright -> solder kit 37
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-07-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 37'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '745890';

-- Loan #521 :: Daniel Kaiser -> solder kit 25
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-07-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 25'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '676443';

-- Loan #522 :: Imaed Boudouma -> solder kit 33
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-07-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 33'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '691755';

-- Loan #523 :: Geuillermo Venegas -> solder kit 7
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-07-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit 7'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '755314';

-- Loan #524 :: Dontonio Brown -> wire strippers
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-07-28 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'wire strippers'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '721661';

-- Loan #525 :: Cameron Wallace -> solder kit #01 + 3sponges + bottle
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-12 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit #01 + 3sponges + bottle'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '656060';

-- Loan #526 :: Nathaniel Offei -> solder kit #21
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-12 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit #21'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '746378';

-- Loan #527 :: Erin Grow -> solder kit #31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-12 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'solder kit #31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '728227';

-- Loan #528 :: Cameron Wallace -> Solder kit 02
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-14 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Solder kit 02'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '656060';

-- Loan #529 :: Russ Wright -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '745890';

-- Loan #530 :: Ben Weber -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #531 :: Jared Moore -> Dig Kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-08-25 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'Dig Kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #532 :: Ben Webber -> trainer 41
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 41'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #533 :: Jared Moore -> temporary dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'temporary dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #534 :: Devin Ilunga -> trainer 34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731773';

-- Loan #535 :: Abygale Browning -> ruler
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-08 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'ruler'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '729129';

-- Loan #536 :: Devin Ilunga -> trainer #08
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #08'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731773';

-- Loan #537 :: Ben Webber -> trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';

-- Loan #538 :: Vince Vogel -> painter's tape
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-15 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'painter''s tape'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '753628';

-- Loan #539 :: Devin Ilunga -> trainer #08
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-10 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #08'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731773';

-- Loan #540 :: Devin Ilunga -> trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-24 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731773';

-- Loan #541 :: Jared Moore -> temporary dig kit
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-09-03 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'temporary dig kit'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '707595';

-- Loan #542 :: Devin Ilunga -> trainer #34
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    '2025-10-01 00:00:00',
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer #34'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '731773';

-- Loan #543 :: Benjamin Weber -> trainer 31
INSERT dbo.TItemLoans (
    intItemID, intBorrowerID, intCheckoutLabTechID,
    dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,
    snapItemName, snapIsSchoolOwned, snapDepartmentName
)
SELECT
    i.intItemID,
    b.intBorrowerID,
    (SELECT TOP(1) intLabTechID FROM dbo.TLabTechs ORDER BY intLabTechID),
    NULL,
    NULL,
    NULL,
    b.strFirstName, b.strLastName, b.strSchoolIDNumber, b.strPhoneNumber, b.strRoomNumber, b.strInstructor,
    i.strItemName, i.blnIsSchoolOwned, d.strDepartmentName
FROM dbo.TBorrowers b
LEFT JOIN dbo.TItems i ON i.strItemName = 'trainer 31'
LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID
WHERE b.strSchoolIDNumber = '738234';