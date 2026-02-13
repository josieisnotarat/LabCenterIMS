const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { initializeDatabase } = require('../db/initialize');
const sqlite = require('../db/sqlite');
const { createApiHandler } = require('./api');

let db;
let apiHandler;

function getDatabasePath() {
  return path.resolve(__dirname, '..', 'db', 'labcenter.db');
}

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 800,
    webPreferences: {
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    }
  });

  win.loadFile(path.join(__dirname, '..', 'LabCenterIMS.html'));
}

app.whenReady().then(() => {
  const dbPath = getDatabasePath();
  process.env.SQLITE_PATH = dbPath;
  initializeDatabase(dbPath);

  db = sqlite.openDatabase(dbPath);
  apiHandler = createApiHandler(db);

  ipcMain.handle('api-request', (event, payload) => {
    try {
      return apiHandler(payload || {});
    } catch (err) {
      console.error(err);
      return { status: 500, body: { error: 'Internal Server Error', detail: err.message } };
    }
  });

  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  if (db) {
    try {
      db.close();
    } catch {
      /* ignore */
    }
  }
});
