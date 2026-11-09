FROM tomsquest/docker-radicale:3.9.0.0@sha256:2f215d0e6a78ff68c280975af6ce580b05976f70c62b51640397e3eb5a7aa0e9

# Railway wrapper: renders the Radicale config from the runtime-injected PORT,
# seeds the admin htpasswd line on first boot, then hands off to the stock
# image entrypoint (chown of /data + su-exec drop to the radicale user).
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["/venv/bin/radicale", "--config", "/config/config"]
