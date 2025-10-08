# LabCenterIMS

## Database

The `LabCenterDatabase.sql` script builds a complete SQL Server schema for the Lab Center inventory and service tracking system. It:

* Creates normalized tables for departments, lab techs, borrowers, inventory, loans, service tickets, ticket/loan notes, and audit logging.
* Applies indexes, constraints, and triggers to keep data consistent and provide fast lookups for the UI workflows.
* Ships with stored procedures that encapsulate every core operation (create/update borrowers and items, checkout/checkin, set due dates, manage service tickets, append notes, and hydrate dashboard/search views).
* Seeds example data so the UI mock-up renders meaningful content immediately after executing the script.

To initialize a fresh environment, run the script in SQL Server Management Studio or via `sqlcmd`. It will create the `dbLabCenter` database (if needed) and populate all required objects.

## API server

The front-end now expects to communicate with a lightweight Node/Express API that proxies the stored procedures in `LabCenterDatabase.sql`.

### Automated setup (Windows)

The project ships with a Windows PowerShell helper that bootstraps everything for you as long as Node.js, npm, and SQL Server (with the `sqlcmd` CLI) are available on your machine.

1. Open Windows PowerShell **as Administrator**. Running elevated ensures the script can create the database.
2. Allow the script to run if your execution policy blocks unsigned scripts:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
   Unblock-File -Path .\setup.ps1
   ```

3. Execute the setup script:

   ```powershell
   ./setup.ps1
   ```

   * By default the script connects to `localhost` on port `1433` using Windows Authentication. Supply `-SqlAdminUser` and `-SqlAdminPassword` if you need to authenticate with a SQL login (for example `sa`).
   * Override `-SqlServer`, `-SqlPort`, or `-DatabaseName` if your SQL Server instance uses a non-default host, port, or database name.
   * If Node.js isn't installed yet, the script will install the LTS release automatically with `winget`. If `winget` isn't available, install Node.js manually from [nodejs.org](https://nodejs.org/en/download/).
   * The helper creates (or reuses) an application login named `labcenter_app` with the password `LabCenter!AppPass`, writes these settings to `.env`, installs Node dependencies, starts `npm start` in a new PowerShell window, and opens `http://localhost:3000/` in your default browser.

Once the setup window reports success, interact with the app in the browser. If you close the API window later, you can restart it manually with `npm start` from the project directory.

## Authentication

The UI now requires users to sign in before accessing any API endpoints. Use an existing lab tech username from the database with the default password `password123`. The API validates logins directly against the `dbo.TLabTechs.strPassword` column, and new users created through the API start with the same default password so they can sign in immediately. Update passwords straight in SQL Server if you need different credentials.
