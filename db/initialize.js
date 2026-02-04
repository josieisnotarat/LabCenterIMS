const fs = require('fs');
const path = require('path');
const sqlite = require('./sqlite');

function initializeDatabase(dbPath) {
  const db = sqlite.openDatabase(dbPath);
  const schemaPath = path.join(__dirname, 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf8');
  db.exec(schema);

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
