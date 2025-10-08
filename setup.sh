#!/usr/bin/env bash
set -euo pipefail
set +H 2>/dev/null || true

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

INFO_COLOR='\033[1;34m'
SUCCESS_COLOR='\033[1;32m'
WARN_COLOR='\033[1;33m'
RESET_COLOR='\033[0m'

info() {
  echo -e "${INFO_COLOR}[INFO]${RESET_COLOR} $*"
}

success() {
  echo -e "${SUCCESS_COLOR}[SUCCESS]${RESET_COLOR} $*"
}

warn() {
  echo -e "${WARN_COLOR}[WARN]${RESET_COLOR} $*"
}

run_as_root() {
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
      sudo "$@"
    else
      echo "Root privileges are required to run '$*'. Please rerun this script as root or install sudo." >&2
      exit 1
    fi
  else
    "$@"
  fi
}

APT_UPDATED=0
apt_update_once() {
  if [ "$APT_UPDATED" -eq 0 ]; then
    info "Updating apt package index..."
    run_as_root apt-get update >/dev/null
    APT_UPDATED=1
  fi
}

ensure_cmd() {
  local cmd="$1"
  local package="${2:-$1}"

  if command -v "$cmd" >/dev/null 2>&1; then
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
    apt_update_once
    info "Installing ${package}..."
    run_as_root apt-get install -y "$package" >/dev/null
  else
    echo "Required command '$cmd' is not available and automatic installation is unsupported on this system." >&2
    exit 1
  fi

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Failed to install required command '$cmd'." >&2
    exit 1
  fi
}

ensure_cmd npm npm
ensure_cmd docker docker.io

if [ ! -d "node_modules" ] || [ ! -d "node_modules/express" ] || [ ! -d "node_modules/mssql" ]; then
  info "Installing Node dependencies..."
  npm install >/dev/null
  success "Node dependencies installed."
else
  info "Node dependencies already present. Skipping npm install."
fi

DB_CONTAINER_NAME=${DB_CONTAINER_NAME:-labcenter-sql}
DB_IMAGE=${DB_IMAGE:-mcr.microsoft.com/mssql/server:2022-latest}
DEFAULT_SA_PASSWORD='YourStrong(!)Password'
SA_PASSWORD="${SA_PASSWORD:-$DEFAULT_SA_PASSWORD}"
DB_PORT=${DB_PORT:-1433}
DB_NAME=${DB_NAME:-dbLabCenter}
APP_DB_USER=${APP_DB_USER:-labcenter_app}
APP_DB_PASSWORD=${APP_DB_PASSWORD:-LabCenter!AppPass}
SQL_FILE="$ROOT_DIR/LabCenterDatabase.sql"
ENV_FILE="$ROOT_DIR/.env"

if [ ! -f "$SQL_FILE" ]; then
  echo "Database script '$SQL_FILE' not found." >&2
  exit 1
fi

info "Ensuring SQL Server container '${DB_CONTAINER_NAME}' is running..."

container_exists() {
  docker ps -a --format '{{.Names}}' | grep -Fxq "$DB_CONTAINER_NAME"
}

container_running() {
  docker ps --format '{{.Names}}' | grep -Fxq "$DB_CONTAINER_NAME"
}

if container_exists; then
  if container_running; then
    info "Container '${DB_CONTAINER_NAME}' is already running."
  else
    info "Starting existing SQL Server container..."
    docker start "$DB_CONTAINER_NAME" >/dev/null
    success "Container started."
  fi
else
  info "Creating new SQL Server container '${DB_CONTAINER_NAME}'."
  docker run -d \
    --name "$DB_CONTAINER_NAME" \
    -e 'ACCEPT_EULA=Y' \
    -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" \
    -p "${DB_PORT}:1433" \
    "$DB_IMAGE" >/dev/null
  success "SQL Server container created."
fi

info "Waiting for SQL Server to be ready..."
ATTEMPTS=0
MAX_ATTEMPTS=30
until docker exec "$DB_CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ]; then
    echo "SQL Server did not become ready in time." >&2
    exit 1
  fi
  sleep 2
done
success "SQL Server is ready."

info "Applying database schema and seed data..."
docker exec -i "$DB_CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "$SA_PASSWORD" -d master -b < "$SQL_FILE"
success "Database schema applied."

info "Ensuring application database login '${APP_DB_USER}' exists..."
docker exec "$DB_CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "$SA_PASSWORD" -d master -Q "IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'${APP_DB_USER}') BEGIN CREATE LOGIN [${APP_DB_USER}] WITH PASSWORD = '${APP_DB_PASSWORD}', CHECK_POLICY = OFF; END"

docker exec "$DB_CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "$SA_PASSWORD" -d "$DB_NAME" -Q "IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'${APP_DB_USER}') BEGIN CREATE USER [${APP_DB_USER}] FOR LOGIN [${APP_DB_USER}]; END; IF NOT EXISTS (SELECT 1 FROM sys.database_role_members drm INNER JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id AND r.name = N'db_owner' INNER JOIN sys.database_principals m ON m.principal_id = drm.member_principal_id AND m.name = N'${APP_DB_USER}') BEGIN ALTER ROLE db_owner ADD MEMBER [${APP_DB_USER}]; END;"
success "Database login configured."

if [ -f "$ENV_FILE" ]; then
  BACKUP_FILE="${ENV_FILE}.bak.$(date +%s)"
  warn ".env file already exists. Backing up to ${BACKUP_FILE}."
  cp "$ENV_FILE" "$BACKUP_FILE"
fi

cat > "$ENV_FILE" <<ENV
DB_USER=${APP_DB_USER}
DB_PASSWORD=${APP_DB_PASSWORD}
DB_SERVER=localhost
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
ENV

success "Wrote database connection details to ${ENV_FILE}."

cat <<'INSTRUCTIONS'
Next steps:
  1. Start the API server with: npm start
  2. Visit http://localhost:3000/ to use the Lab Center IMS UI.

Default application login:
  Username: admin
  Password: password123
INSTRUCTIONS

success "Lab Center IMS environment setup complete."
