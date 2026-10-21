# Admin UI (headscale-admin)

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

The stack runs `headscale-ui` (goodieshq/headscale-admin), a browser app that talks to the headscale API using an API key.

**Serve it on a subpath of your headscale domain, not a separate subdomain.** The app's asset path is hardcoded to `/admin`, and on a different origin the browser blocks API calls via CORS (headscale sends no `Access-Control-Allow-Origin` headers, and adding them in NPM risks breaking the proxy host).

1. **Add a Custom Location** on the *existing* `headscale.example.com` proxy host in NPM:
   * Location: `/admin`
   * Scheme: `http`, Forward Hostname/IP: `headscale-ui`, Forward Port: `80`
2. **Generate an API key** (shown only once):
   ```bash
   docker exec -it "$HEADSCALE_CONTAINER" headscale apikeys create --expiration 90d
   ```
3. **Open** `https://headscale.example.com/admin/` and enter:
   * **Server URL:** `https://headscale.example.com`
   * **API Key:** the key from step 2

Manage keys with `headscale apikeys list` / `headscale apikeys expire`; mint a new one before the old one expires.

> Credentials are saved in each browser's `localStorage`. On another browser/device, enter the *same* key again — only generate a new key if it expired or was revoked.

`HEADSCALE_URL=http://headscale:8080` in `compose.yaml` only prefills the internal address; you still authenticate with an API key.
