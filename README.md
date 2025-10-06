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

1. Install the dependencies:

   ```bash
   npm install
   ```

2. (Optional) Override the default SQL Server connection values by setting environment variables before starting the server. The API reads the following keys (with the defaults shown in parentheses):

   * `DB_SERVER` / `SQL_SERVER` (`localhost`)
   * `DB_PORT` / `SQL_PORT` (`1433`)
   * `DB_NAME` / `SQL_DATABASE` (`dbLabCenter`)
   * `DB_USER` / `SQL_USER` (`sa`)
   * `DB_PASSWORD` / `SQL_PASSWORD` (`yourStrong(!)Password`)
   * `DB_ENCRYPT` (`false`), `DB_TRUST_SERVER_CERTIFICATE` (`true`)

   These aliases make it easy to match local setups, Docker connection strings, or Azure SQL environments without editing source files.

3. Start the API server:

   ```bash
   npm start
   ```

The Node server ships with sensible defaults (`localhost:1433`, `dbLabCenter`, `sa` / `yourStrong(!)Password`). Provide environment variables if your SQL Server instance uses different connection details.

The app serves both the API under `/api/*` and the static UI. Visit `http://localhost:3000/` after the server is running to see the dashboard populated with live data from SQL Server.
