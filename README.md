# LabCenter IMS (Electron + SQLite)

This repository contains a self-contained Electron desktop application that runs the LabCenter IMS UI (`LabCenterIMS.html`) and a local SQLite database. Follow the steps below to install dependencies, create the SQLite database, and launch the app.

## Prerequisites

- **Node.js LTS (18+ recommended)** with npm.
  - Download: https://nodejs.org/en/download/
- **Build tools for native Node modules** (required by `better-sqlite3`).
  - **Windows:** Install “Build Tools for Visual Studio 2022” (C++ workload) or run `npm install --global --production windows-build-tools` (older option).
  - **macOS:** `xcode-select --install`
  - **Linux:** install your distro’s `build-essential` / `gcc` / `g++` / `make` packages.

## Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd LabCenterIMS
   ```

2. **Initialize npm (only if `package.json` is missing)**
   ```bash
   npm init -y
   ```

3. **Install Electron and SQLite dependencies**
   ```bash
   npm install electron better-sqlite3
   ```

## Running the Electron App

Start the Electron app using the main process entry point:

```bash
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

## What’s Included

- Electron main process: `electron/main.js`
- SQLite schema: `db/schema.sql`
- UI entry point: `LabCenterIMS.html`

## Support

If you run into issues, capture the console output from the terminal where Electron is launched and include it in your support request.
