#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f package.json ]]; then
  echo "Creating package.json..."
  npm init -y >/dev/null
fi

echo "Installing Electron and better-sqlite3..."
npm install electron better-sqlite3

echo "Setup complete. Run: npx electron electron/main.js"
