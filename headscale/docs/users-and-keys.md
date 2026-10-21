# Create a User and Pre-Auth Key

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

```bash
docker exec -it "$HEADSCALE_CONTAINER" headscale -c /etc/headscale/config.yaml user create homelab
docker exec -it "$HEADSCALE_CONTAINER" headscale users list
docker exec -it "$HEADSCALE_CONTAINER" headscale preauthkeys create --user 1 --expiration 1h
```

Copy the printed key — you'll use it once on each device you join.

> **About `--expiration`:** it only limits the window in which the key can *register a new device*. Devices already joined stay authorized after the key expires. Use a longer expiration (e.g. `24h`) or `--reusable` when onboarding several devices.
