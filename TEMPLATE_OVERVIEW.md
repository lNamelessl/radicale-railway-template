# Deploy and Host

This template deploys **Radicale 3.9.0** — the lightweight CalDAV/CardDAV server (calendars + contacts) — as a single hardened container on Railway with one persistent volume and zero required deploy-form prompts.

After deploying, open the service's **Variables** tab: the admin password is already generated per-deploy in `ADMIN_PASSWORD`. Log in at the web UI (your Railway domain, path `/.web`) as user `admin`, create your first calendar or address book, and connect your devices.

One-click deploy button:

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/radicale-template)

Intro before the required sections: Radicale syncs calendars and contacts to phones and laptops over open CalDAV/CardDAV protocols. This template runs the hardened, digest-pinned image of Radicale 3.9.0, renders its config at boot from the runtime port, seeds a bcrypt-protected htpasswd file on first boot only, and stores everything in the `/data` volume.

## About Hosting

Hosting Radicale yourself means your calendars and contacts live in plain, standard files on **your** volume — no vendor lock-in, no third-party sync service reading your data. The template provisions:

- **One service** — Radicale 3.9.0 (non-root at runtime, Railway terminates TLS at the edge).
- **One volume** mounted at `/data` — collections, and the htpasswd users file, all persist across deploys and restarts.
- **Zero required variables** — `ADMIN_PASSWORD` is pre-filled with a per-deploy generated secret; nothing to type at deploy time.
- Auth is HTTP basic over bcrypt (htpasswd), and every user only sees their own collections.

Rough sizing: Radicale idles under ~50 MB RAM; a personal calendar library is a few MB. The default volume size is far more than a personal account ever needs.

## Why Deploy

- **Instant private sync**: deploy, open the Variables tab, copy your password, add the account in Apple Calendar, Thunderbird, or DAVx⁵ — done in under five minutes.
- **Zero-prompt deploy**: unlike deploying Radicale manually (writing config files, htpasswd entries, ownership), this template boots fully configured: port rendering, bcrypt seeding, volume ownership and privilege drop are all handled at boot.
- **Hardened upstream image**: digest-pinned `tomsquest/docker-radicale:3.9.0.0`, runs as a non-root user, includes brute-force login delay.
- **Standard protocols**: CalDAV (events, tasks) and CardDAV (contacts) with native `/.well-known/caldav` and `/.well-known/cardav` redirects — clients discover everything from the root URL.
- **Your data, portable**: collections are plain iCalendar (.ics) and vCard (.vcf) files on the volume — copy them anywhere.

## Common Use Cases

- **Private calendar sync** across iPhone, iPad, Mac, Android and Thunderbird without iCloud or Google.
- **Shared family/team contacts** — add a user per person (one ssh command), each sees only their own address books and calendars.
- **Todo.txt-style task sync** — tasks are CalDAV VTODOs; pair with clients that support them (e.g. Thunderbird, DAVx⁵-based task apps).
- **Backup target for busy calendars** — many calendar apps and booking tools speak CalDAV; point them at your own server.
- **Self-hosted replacement for a paid DAV host** — one small Railway service and volume instead of a monthly subscription.

## Dependencies for

### Deployment Dependencies

- **Railway account** — the template provisions one service plus one volume; no external database or other services are needed.
- **No required variables** — `ADMIN_PASSWORD` (admin password) is auto-generated per deploy as a Railway secret reference and surfaced in the Variables tab; `PORT` is injected by the platform automatically.
- **A CalDAV/CardDAV client** for everyday use: Apple Calendar, Thunderbird, DAVx⁵, or any CalDAV-capable app. Client URLs and step-by-step setup live in the repository README.
- **Upstream software**: Radicale 3.9.0 (GPLv3+) via the hardened `tomsquest/docker-radicale` container image (MIT); licenses are collected in `NOTICE.md` in the repository.
