# LabCenterIMS

> Inventory & maintenance command center for Cincinnati State lab center.

- **SQL Server backbone** with normalized tables, triggers, and stored procedures that keep every piece of gear accounted for.
- **Node/Express API sidekick** that talks directly to the database so the front end always stays in sync with lab reality.
- **Seed data included**, so your mock dashboards light up with meaningful numbers seconds after install.

## 🧬 System anatomy
| Piece | What it does |
| --- | --- |
| `LabCenterDatabase.sql` | Builds the `dbLabCenter` database, tables for techs/borrowers/inventory, constraints, triggers, and helper stored procedures. |
| `server.js` + `package.json` | Lightweight API layer that wraps the stored procedures and feeds the front end. |
| `LabCenterIMS.html` | The prototype UI that expects the API endpoints described above. |

## 🧰 Prerequisites
Before you mash any buttons, make sure the following are installed:

1. **SQL Server** (Express is fine) and the `sqlcmd` command-line tool. (grab it here: https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us) If you do not already have SQL Server installed, the setup script can install SQL Server 2022 Express for you with the `-InstallSqlServerExpress` switch.
2. **Node.js (LTS)** and **npm**. If you're on Windows without Node yet, don't panic—the setup script can fetch it for you.
3. **Windows PowerShell (Admin rights)** for the automated setup path below.

> 💡 On non-Windows platforms you can still run the API and database manually; the helper script is just the fast lane for Windows users.

## 🚀 Setup (Windows)
Follow these steps:

1. **Open PowerShell as Administrator.** Right-click > "Run as administrator." This gives the script permission to create databases.
2. **Let PowerShell run the script.** If you see warnings about scripts being blocked, run:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
   Unblock-File -Path .\setup.ps1
   ```
3. **Launch the autopilot script:**
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
   ```
   No SQL Server yet? Run the script as an administrator with `-InstallSqlServerExpress` to install and start SQL Server Express automatically:
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -InstallSqlServerExpress
   ```
4. **Watch the console.** The script will:
   - Connect to SQL Server (defaults: `localhost`, port `1433`, Windows Auth).
   - Create or update the `dbLabCenter` database using `LabCenterDatabase.sql`.
   - Create an app login named `labcenter_app` with password `LabCenter!AppPass` (or reuse it if it already exists).
   - Write a fresh `.env` with the connection details.
   - Install Node dependencies (`npm install`).
   - Spin up the API with `npm start` in a new PowerShell window.
   - Launch `http://localhost:3000/` in your default browser so you can start poking around immediately.

   Need a different SQL instance? Supply `-SqlServer`, `-SqlPort`, `-DatabaseName`, `-SqlAdminUser`, or `-SqlAdminPassword` when you run the script.

5. **You're done!** Keep the API window open while testing. If you close it, relaunch later with:
   ```powershell
   npm start
   ```
   inside the project directory.

## 🧗 Manual setup (advanced nerd path)
Prefer to wire things up yourself? Here's the checklist:

1. Run `LabCenterDatabase.sql` in SQL Server Management Studio or via `sqlcmd` to create the database.
2. Create a `.env` file alongside `server.js` with your SQL credentials:
   ```ini
   SQL_SERVER=localhost
   SQL_PORT=1433
   SQL_DATABASE=dbLabCenter
   SQL_USER=labcenter_app
   SQL_PASSWORD=LabCenter!AppPass
   PORT=3000
   ```
   Adjust values to match your environment.
3. `npm install` to grab dependencies.
4. `npm start` to launch the API.
5. Open `LabCenterIMS.html` in a browser and update the fetch URLs if your API isn't on `localhost:3000`.

## 🔐 Authentication quickstart
- Upon first setup, the only user account that exists will have the username admin, and a default password of `password123`.
- New lab techs created via the API also start with `password123`. Update passwords directly in SQL Server when needed.

## 🛠️ Troubleshooting tips
- **SQL connection errors:** Double-check that SQL Server is running, the port is open, and your credentials match what's in `.env`.
- **`sqlcmd` not found:** Install the SQL Server Command Line Utilities or ensure they are on your PATH.
- **`winget` installation exit code -1978335230:** This is returned by the SQL Server installer when something blocks setup (usually a pending reboot or remnants of a previous SQL Server install). Reboot Windows, uninstall any partial SQL Server components from **Apps & Features**, and if the script still fails install [SQL Server 2022 Express manually](https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us) before re-running `setup.ps1`.
- **Port already in use (3000):** Either stop the other service or set a new `PORT` value in `.env` before running `npm start`.

## 🛰️ Next steps
- Extend the API with additional stored procedure wrappers.
- Modernize the UI to consume the live API endpoints.
- Add automated tests for happy lab techs and their QA friends.

Stay curious, stay nerdy, and keep those instruments calibrated! 🧪

## 🖥️ Electron packaging (SQLite)

The Electron build runs the UI without a local HTTP server by routing data requests over IPC to the SQLite data layer.

### Run locally

```bash
npm install
npm run start:electron
```

On first run, the app creates a SQLite database at:

- **Windows:** `%APPDATA%/LabCenterIMS/labcenter.db`
- **macOS:** `~/Library/Application Support/LabCenterIMS/labcenter.db`
- **Linux:** `~/.config/LabCenterIMS/labcenter.db`

A default admin user is created if none exists:

- Username: `admin`
- Password: `password123`

### Build installers

```bash
npm run dist
```

The packaged installers are written to the `dist/` directory.
