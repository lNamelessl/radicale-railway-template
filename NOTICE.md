# Notices and licenses

- **Radicale** — https://github.com/Kozea/Radicale — GNU GPL v3+ (server). Version deployed: 3.9.0.
- **tomsquest/docker-radicale** — https://github.com/tomsquest/docker-radicale — MIT (container wrapper; Radicale itself remains GPLv3+). Image pin: `tomsquest/docker-radicale:3.9.0.0@sha256:2f215d0e6a78ff68c280975af6ce580b05976f70c62b51640397e3eb5a7aa0e9`.
- **passlib / bcrypt / argon2-cffi** — bundled inside the upstream image for htpasswd hashing (BSD/Apache-family licenses).
- This repository contains only a Railway packaging wrapper (boot-time config render + first-boot htpasswd seed) and is provided as-is.
