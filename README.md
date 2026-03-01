# n8n-local

Local Dockerized n8n stack (main + worker + Postgres + Redis) using pinned images.

## Services

- **n8n (main)**: web UI + API at `http://localhost:5678`
- **n8n-worker**: queue worker process for background executions
- **postgres**: persistence for n8n metadata/execution records
- **redis**: Bull queue backend for queue mode

## Versions (pinned)

- `docker.n8n.io/n8nio/n8n:2.4.6` (main + worker)
- `postgres:15`
- `redis:7`

## Quick start

```bash
cp .env.example .env
# Edit .env values, especially POSTGRES_PASSWORD and N8N_ENCRYPTION_KEY
./n8n.sh up
./n8n.sh ps
```

Open: `http://localhost:5678`

## Commands

```bash
./n8n.sh up
./n8n.sh down
./n8n.sh logs
./n8n.sh ps
```

## Public HTTPS ingress (preferred): host-level Cloudflare Tunnel

This project intentionally **does not** run `cloudflared` or Caddy inside Docker Compose.
Preferred public ingress is host-level Cloudflare Tunnel mapped to local n8n.

Suggested hostname: `n8n.tomsalphaclawbot.work`

Example flow:

```bash
# one-time
cloudflared tunnel create n8n-local
cloudflared tunnel route dns n8n-local n8n.tomsalphaclawbot.work

# copy this project's example to host config path
cp cloudflared-config.example.yml ~/.cloudflared/config-n8n-local.yml
# edit tunnel UUID + credentials-file path

# run tunnel from host
cloudflared tunnel --config ~/.cloudflared/config-n8n-local.yml run <tunnel-uuid>
```

## Notes

- Queue mode is enabled via `EXECUTIONS_MODE=queue` and Redis-backed Bull config.
- The same `DATA_FOLDER` is mounted for main + worker to share encryption/config context.
- For production hardening, use strong secrets and backups for Postgres + n8n data.
- Reverse-proxy cookie hardening is enabled (`N8N_PROXY_HOPS=1`, `N8N_EDITOR_BASE_URL=https://n8n.tomsalphaclawbot.work`, `N8N_SECURE_COOKIE=true`).
- If Safari still shows a secure-cookie warning, clear site cookies and use the public HTTPS URL (avoid mixed localhost/public login sessions).
