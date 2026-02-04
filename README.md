# LabCenterIMS

> Inventory & maintenance command center for Cincinnati State lab center.

- **Electron + SQLite** desktop app for a single‑install, offline‑friendly workflow.
- **Local embedded database** seeded on first run so the app launches immediately.
- **IPC data access** keeps the UI responsive without running a local HTTP server.

## 🧬 System anatomy
| Piece | What it does |
| --- | --- |
| `LabCenterIMS.html` | The desktop UI rendered inside Electron. |
| `electron/` | Electron main + preload that route UI requests over IPC. |
| `db/` | SQLite schema + initialization helpers and the data access layer. |

## 🧰 Prerequisites

1. **Node.js (LTS)** and **npm**.

## 🚀 Run the app (one‑and‑done)

Install dependencies once, then launch with a single command:

```bash
npm install
node launch.js
```

(You can also use `npm start`, which runs the same launch script.)

### Where the SQLite DB lives

On first run, the app creates a SQLite database at:

- **Windows:** `%APPDATA%/LabCenterIMS/labcenter.db`
- **macOS:** `~/Library/Application Support/LabCenterIMS/labcenter.db`
- **Linux:** `~/.config/LabCenterIMS/labcenter.db`

A default admin user is created if none exists:

- Username: `admin`
- Password: `password123`

## 📦 Build installers

```bash
npm run dist
```

The packaged installers are written to the `dist/` directory.

## 🛰️ Notes

- **Data persists** between runs: SQLite is stored on disk in your user profile, so closing the app does not remove data.
- **No SQL Server required.** This project now runs purely on Electron + SQLite.

## 🛠️ Troubleshooting (Electron native modules)

If you see a `better-sqlite3` NODE_MODULE_VERSION error after upgrading Node or Electron, rebuild the native module:

```bash
npm install
```

The postinstall hook runs `electron-rebuild` for `better-sqlite3`. If you need to run it manually:

```bash
npx electron-rebuild -f -w better-sqlite3
```
