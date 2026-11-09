#!/bin/sh
set -e

PORT="${PORT:-5232}"

# Render the Radicale config. Radicale's config file cannot read environment
# variables, and Railway injects PORT at runtime, so the file is rendered on
# every boot (Prosody precedent).
cat > /config/config <<EOF
[server]
hosts = 0.0.0.0:${PORT}

[auth]
type = htpasswd
htpasswd_filename = /data/users
htpasswd_encryption = bcrypt

[storage]
filesystem_folder = /data/collections

[web]
type = internal
prefer_browser_login = False

[rights]
type = owner_only

[headers]
Content-Security-Policy = default-src 'self'; object-src 'none'
EOF

# Seed the admin htpasswd line on FIRST BOOT ONLY (non-destructive: if the
# users file already contains a user:hash line, leave it untouched so that
# panel-managed users and later password changes survive reboots).
if ! grep -q '^[^#][^:]*:[^:]*' /data/users 2>/dev/null; then
  if [ -z "${ADMIN_PASSWORD}" ]; then
    echo "WARNING: ADMIN_PASSWORD is empty; skipping htpasswd seed" >&2
  else
    HASH="$(/venv/bin/python -c "import os; from passlib.hash import bcrypt; print(bcrypt.using(rounds=12).hash(os.environ['ADMIN_PASSWORD']))")"
    printf 'admin:%s\n' "$HASH" > /data/users
    echo "Seeded htpasswd admin user from ADMIN_PASSWORD"
  fi
fi

# Hand off to the stock image entrypoint: chowns /data (Railway mounts are
# root-owned) and drops privileges to the radicale user via su-exec.
exec /usr/local/bin/docker-entrypoint.sh "$@"
