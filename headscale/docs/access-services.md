# Access LAN Services (e.g. Jellyfin)

[← Back to README](../README.md)

With Tailscale connected on your phone/laptop, browse to:

* `http://<lan-node-tailscale-ip>:8096` (the 100.64.x.x address from `tailscale status`), or
* `http://<lan-node-hostname>.tailnet.local:8096` via MagicDNS (base domain set in `config.yaml`)

Port 8096 only needs to be reachable on the LAN node itself — **never** forward it on your router.

MagicDNS base domain is `tailnet.local`; change it in `config.yaml` if it clashes with your LAN DNS.
