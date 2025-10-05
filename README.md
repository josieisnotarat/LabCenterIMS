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

2. Provide SQL Server connection settings via environment variables (for example by creating a `.env` file):

   ```ini
   DB_SERVER=localhost
   DB_PORT=1433
   DB_USER=sa
   DB_PASSWORD=yourStrong(!)Password
   DB_NAME=dbLabCenter
   ```

3. Start the API server:

   ```bash
   npm start
   ```

The app serves both the API under `/api/*` and the static UI. Visit `http://localhost:3000/` after the server is running to see the dashboard populated with live data from SQL Server.