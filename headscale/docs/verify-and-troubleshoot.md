# Verify and Troubleshoot

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

```bash
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes list   # on the dedicated server
tailscale status                                             # on any client
tailscale ping <lan-node-hostname-or-100.64.x.x-ip>          # from your laptop/phone
```

A reply of `pong via ...` (direct or DERP) means the mesh works.

## `tailscale up` hangs or `/ts2021` returns 500

Almost always the reverse proxy — check [NPM settings](nginx-proxy-manager.md) (Websockets on, HTTP/2 off). To confirm, watch both sides while retrying `tailscale up`:

```bash
journalctl -u tailscaled -f                 # on the client
docker logs -f "$HEADSCALE_CONTAINER"        # on the server
```

`/ts2021` requests should return `status=200`, not `500`.
