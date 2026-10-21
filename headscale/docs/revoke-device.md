# Revoke a Compromised Device

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

```bash
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes list
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes delete -i <NODE-ID>
docker exec -it "$HEADSCALE_CONTAINER" headscale preauthkeys expire --user homelab <KEY>   # if the key leaked too
```

The device is cut off immediately; re-join later with a fresh key if needed.
