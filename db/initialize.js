const fs = require('fs');
const path = require('path');
const sqlite = require('./sqlite');


function ensureColumn(db, tableName, columnName, columnDef) {
  const columns = db.prepare(`PRAGMA table_info(${tableName});`).all();
  const exists = columns.some((column) => column.name === columnName);
  if (!exists) {
    db.prepare(`ALTER TABLE ${tableName} ADD COLUMN ${columnDef};`).run();
  }
}

function initializeDatabase(dbPath) {
  const db = sqlite.openDatabase(dbPath);
  const schemaPath = path.join(__dirname, 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf8');
  db.exec(schema);

  ensureColumn(db, 'TServiceTickets', 'snapRoomNumber', 'snapRoomNumber TEXT');
  ensureColumn(db, 'TServiceTickets', 'snapInstructor', 'snapInstructor TEXT');
  ensureColumn(db, 'TServiceTickets', 'snapDepartmentName', 'snapDepartmentName TEXT');

  const adminExists = db.prepare(`
    SELECT 1 FROM TLabTechs WHERE strUsername = 'admin' LIMIT 1;
  `).get();

  if (!adminExists) {
    db.prepare(`
      INSERT INTO TLabTechs (
        strUsername,
        strDisplayName,
        strFirstName,
        strLastName,
        strEmail,
        strPassword,
        strRole,
        blnIsActive,
        dtmCreated
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
    `).run(
      'admin',
      'Administrator',
      'Admin',
      'User',
      'admin@example.edu',
      'password123',
      'admin',
      1,
      new Date().toISOString()
    );
  }

  db.close();
}

module.exports = { initializeDatabase };
