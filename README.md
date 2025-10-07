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

### Automated setup

Run the provided setup script to install Node dependencies, provision SQL Server inside Docker, load the schema, create the application login, and write the `.env` file that the API consumes.

On macOS/Linux (Bash):

```bash
./setup.sh
```

On Windows (PowerShell 5.1+):

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

The PowerShell helper will attempt to install Node.js via `winget` if it is missing and will verify that Docker Desktop is installed and running before proceeding. If `winget` or Docker Desktop are not available, the script will stop with guidance so you can install the prerequisite manually (running the terminal as Administrator may be required for package installation).

Once the setup script completes, start the API with `npm start` and browse to `http://localhost:3000/`.

1. Install the dependencies:

   ```bash
   npm install
   ```

2. Start the API server:

   ```bash
   npm start
   ```

The Node server reads its SQL Server connection settings from environment variables or a local `.env` file. The automated setup script writes defaults for the bundled Docker container (`labcenter_app` / `LabCenter!AppPass` against `localhost:1433`). Update `.env` or the environment as needed if you are connecting to a different SQL Server instance.

The app serves both the API under `/api/*` and the static UI. Visit `http://localhost:3000/` after the server is running to see the dashboard populated with live data from SQL Server.

## Authentication

The UI now requires users to sign in before accessing any API endpoints. Use an existing lab tech username from the database with the default password `password123`. You can change credentials directly in SQL Server by updating the `dbo.TLabTechCredentials` table or by creating new users through the API and then updating their hashes manually.
