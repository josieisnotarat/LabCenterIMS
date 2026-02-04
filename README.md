# Lab Center IMS

Lab Center IMS is an inventory management system backed by SQL Server with a Node.js API server and a browser-based UI.

## Prerequisites

The setup script targets Windows PowerShell 5.1+ and expects the following tools or services:

- **SQL Server** (Developer or Express) running locally or on a reachable host.
- **sqlcmd** (SQL Server Command Line Utilities).
- **Node.js LTS** (npm is used to install dependencies and start the API server).
- **winget** (optional) to install Node.js or SQL Server Express automatically if they are missing.

## Quick start (recommended)

Use the bundled PowerShell script to configure SQL Server, write `.env`, install dependencies, and launch the app:

```powershell
# From the repo root
./setup.ps1 -SqlServer localhost -DatabaseName dbLabCenter
```

The script will:

1. Ensure Node.js is installed (installs via winget if available).
2. Validate `sqlcmd` is available.
3. Apply `LabCenterDatabase.sql` to the target SQL Server instance.
4. Create the application SQL login and grant `db_owner` on the database.
5. Write a `.env` file with the database connection details.
6. Run `npm install` (or rebuild native modules if `node_modules` already exists).
7. Launch `npm start` in a new PowerShell window and open the UI at `http://localhost:3000/`.

### Common setup parameters

```powershell
./setup.ps1 \
  -SqlServer localhost\SQLEXPRESS \
  -SqlPort 1433 \
  -DatabaseName dbLabCenter \
  -SqlAdminUser sa \
  -SqlAdminPassword "<your-password>" \
  -AppDbUser labcenter_app \
  -AppDbPassword "LabCenter!AppPass" \
  -InstallSqlServerExpress
```

- Use `-InstallSqlServerExpress` to let the script install SQL Server Express (default or SQLEXPRESS only).
- Omit `-SqlAdminUser`/`-SqlAdminPassword` to use Windows authentication with `sqlcmd`.

## Manual setup (if you cannot use the script)

1. **Install prerequisites**: SQL Server, sqlcmd utilities, and Node.js LTS.
2. **Create the database**: run `LabCenterDatabase.sql` against your SQL Server instance.
3. **Create an app login**: create a SQL login/user with `db_owner` on the database.
4. **Configure `.env`** at the repo root:

   ```env
   DB_USER=labcenter_app
   DB_PASSWORD=LabCenter!AppPass
   DB_SERVER=localhost
   DB_PORT=1433
   DB_NAME=dbLabCenter
   DB_ENCRYPT=false
   DB_TRUST_SERVER_CERTIFICATE=true
   ```

5. **Install dependencies**: `npm install`.
6. **Start the API server**: `npm start` and visit `http://localhost:3000/`.

## Additional documentation

- Database schema reference: `docs/sqlite-schema.md`
- API contract: `docs/api-contract.md`
- Data migration notes: `docs/data-migration.md`
