# LabCenter IMS (Electron + SQLite)

This repository contains a self-contained Electron desktop application that runs the LabCenter IMS UI (`LabCenterIMS.html`) and a local SQLite database. Follow the steps below to install dependencies, create the SQLite database, and launch the app.

## Prerequisites

- **Node.js LTS (18+ recommended)** with npm.
  - Download: https://nodejs.org/en/download/
- **Build tools for native Node modules** (only needed if `better-sqlite3` cannot download a prebuilt binary for your OS/Node version).
  - **Windows:** Install “Build Tools for Visual Studio 2022” (C++ workload).
  - **macOS:** `xcode-select --install`
  - **Linux:** install your distro’s `build-essential` / `gcc` / `g++` / `make` packages.

## Installation

### Option A: One-command setup script (recommended)

Pick the script for your OS; it creates a minimal `package.json` (if missing), installs Electron + SQLite, installs `@electron/rebuild`, and rebuilds `better-sqlite3` for your Electron version.

**macOS/Linux (bash):**
```bash
chmod +x ./scripts/setup-electron.sh
./scripts/setup-electron.sh
```

**Windows (PowerShell):**
```powershell
./scripts/setup-electron.ps1
```

### Option B: Manual setup (no helper scripts)

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd LabCenterIMS
   ```

2. **Initialize npm**
   ```bash
   npm init -y
   ```

3. **Install Electron and SQLite dependencies**
   ```bash
   npm install electron better-sqlite3
   ```

4. **Install Electron rebuild tooling**
   ```bash
   npm install -D @electron/rebuild
   ```

5. **Rebuild native modules for Electron**
   ```bash
   npx electron-rebuild -f -w better-sqlite3
   ```

6. **Add a start script to `package.json`**

   Open `package.json` and add/update the `scripts` section:
   ```json
   {
     "scripts": {
       "start": "electron electron/main.js"
     }
   }
   ```

7. **Launch the app**
   ```bash
   npm start
   ```

#### Manual install notes by OS

- **Windows (PowerShell):** if native builds are required, install Visual Studio Build Tools (C++ workload), then run the same `npm init -y` / `npm install ...` commands from the repo root, then run `npx electron-rebuild -f -w better-sqlite3`.
- **macOS:** install Xcode Command Line Tools first (`xcode-select --install`) so `better-sqlite3` can compile if no prebuilt binary is available, then run `npx electron-rebuild -f -w better-sqlite3`.
- **Linux:** install compiler tooling first (`build-essential`, `python3`, `make`, `g++`), then run the same npm commands and `npx electron-rebuild -f -w better-sqlite3`.

## Running the Electron App

Start the Electron app using either npm or the direct Electron entry point:

```bash
npm start
# or
npx electron electron/main.js
```

The app will:

- Create a SQLite database at the Electron user data directory (for example, on Windows: `%APPDATA%/LabCenterIMS/labcenter.db`; on macOS: `~/Library/Application Support/LabCenterIMS/labcenter.db`).
- Initialize the schema from `db/schema.sql`.
- Seed a default admin account on first run.

## Default Login

Use the seeded admin credentials on first launch:

- **Username:** `admin`
- **Password:** `password123`

> Change this password after the first login (edit in the UI or directly in SQLite).

## Optional: Reset or Move the Database

If you need to reset the database, delete the `labcenter.db` file from the Electron user data folder and relaunch the app. A new database will be created automatically.

If you want to use a custom database location, set the `SQLITE_PATH` environment variable before launching:

```bash
SQLITE_PATH=/path/to/labcenter.db npx electron electron/main.js
```

## Troubleshooting

- **`better-sqlite3` fails to build:** ensure your OS build tools are installed (see prerequisites).
- **App launches but shows a blank screen:** confirm the `LabCenterIMS.html` file exists in the repository root and that the app was started from the repo directory.
- **PowerShell script permissions are blocked:** open PowerShell *as Administrator* and run:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  ```
  Then re-run your script. If you want a per-user change instead, use:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```
- **PowerShell reports the script isn’t digitally signed:** either use the execution policy commands above, or unblock the script file and try again:
  ```powershell
  Unblock-File -Path .\scripts\setup-electron.ps1
  ```
- **`better-sqlite3` was compiled against a different Node/Electron version:** re-install or rebuild the module against Electron’s Node version:
  ```bash
  npm rebuild better-sqlite3 --build-from-source
  ```
  If that fails, remove `node_modules` and reinstall:
  ```bash
  rm -rf node_modules package-lock.json
  npm install electron better-sqlite3
  npm install -D @electron/rebuild
  npx electron-rebuild -f -w better-sqlite3
  ```

## What’s Included

- Electron main process: `electron/main.js`
- SQLite schema: `db/schema.sql`
- UI entry point: `LabCenterIMS.html`

## Support

If you run into issues, capture the console output from the terminal where Electron is launched and include it in your support request.
