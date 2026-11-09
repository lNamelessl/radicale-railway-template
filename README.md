# Radicale on Railway

One-click [Radicale](https://radicale.org) — the lightweight CalDAV/CardDAV server for calendars and contacts — packaged for Railway. Single container, one volume, zero required deploy-form prompts.

**Deploy:** [![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/radicale-template)

## What this template does on first boot

1. Renders the Radicale config from the runtime-injected `PORT` (Radicale config files cannot read environment variables).
2. Seeds an htpasswd file at `/data/users` with user `admin` and a bcrypt hash of the `ADMIN_PASSWORD` variable. **First boot only** — if the users file already contains a user, it is never overwritten (change the password in the file or delete `/data/users` to re-seed).
3. Runs the hardened [tomsquest/docker-radicale](https://github.com/tomsquest/docker-radicale) image (digest-pinned `3.9.0.0`), which chowns `/data` (Railway mounts are root-owned) and drops privileges to a non-root `radicale` user (uid 2999).

## Post-deploy

- **Admin password:** `ADMIN_PASSWORD` in the service's Variables tab (auto-generated per deploy via Railway secret reference).
- **Web UI:** `https://<your-domain>/.web` — visiting `/` redirects there. Log in as `admin` with the password from the Variables tab. Create calendars and address books in the UI.
- **Data:** everything persists in the `/data` volume (`/data/collections`, `/data/users`).

## Client setup

All clients use HTTP basic auth with user `admin` (or any user you add) and the password from the Variables tab. Radicale serves `/.well-known/caldav` and `/.well-known/cardav` redirects natively, so discovery against the root URL works everywhere.

- **Apple Calendar / Apple devices:** while logged into the web UI, open `https://<your-domain>/.mobileconfig` to download a signed config profile, or add a CalDAV account manually with server `https://<your-domain>/` and your username/password.
- **Thunderbird:** New Calendar → *On the Network* → URL `https://<your-domain>/` (or the full collection URL), username + password.
- **DAVx⁵ (Android):** add account → *Connection: URL and username* → base URL `https://<your-domain>/` (or `https://<your-domain>/admin/`), then refresh and pick collections.

## Adding users

```bash
railway ssh --service radicale
/venv/bin/python -c "from passlib.hash import bcrypt; print('alice:' + bcrypt.using(rounds=12).hash('THE-PASSWORD'))" >> /data/users
```
New lines take effect without a restart (the htpasswd file is re-read on login). Each user only sees their own collections (`rights.type = owner_only`).

## Configuration

| Variable | Default | Meaning |
|---|---|---|
| `ADMIN_PASSWORD` | `${{secret(24)}}` per deploy | Initial `admin` user password (seeded on first boot only) |
| `PORT` | injected by Railway | Listen port (rendered into `hosts`) |

Everything else is the baked config: bcrypt htpasswd auth, filesystem storage under `/data/collections`, internal web UI, TLS terminated at the Railway edge.

## Pins

- Image: `tomsquest/docker-radicale:3.9.0.0@sha256:2f215d0e6a78ff68c280975af6ce580b05976f70c62b51640397e3eb5a7aa0e9` (Radicale 3.9.0)
- Upstream: https://github.com/Kozea/Radicale — see `NOTICE.md` for licenses.
