# qbittorrent

"Docker container which runs the latest qBittorrent-nox client while connecting to WireGuard or OpenVPN with netfilter killswitch to prevent IP leakage when the tunnel goes down."

https://github.com/Trigus42/alpine-qbittorrentvpn

port: 8080

## Overview

BitTorrent client with a full-featured web UI.

## Project Details

-   **Container Image:** [trigus42/qbittorrentvpn:latest](https://hub.docker.com/r/trigus42/qbittorrentvpn)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    QBT_PASS – default: ChangeThisPassword
    QBT_PORT – default: 8080

## Volume Notes

    /config – host path /data/qbit/config
    /downloads – host path /data/qbit/downloads
    /incomplete – host path /data/qbit/incomplete
    /dev/net/tun – host path /dev/net/tun

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name qbittorrent \
  -p 8080:8080 \
  -v /data/qbit/config:/config \
  -v /data/qbit/downloads:/downloads \
  -v /data/qbit/incomplete:/incomplete \
  -v /dev/net/tun:/dev/net/tun \
  trigus42/qbittorrentvpn:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Check the container logs on first start for the temporary web UI password.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: qbittorrent
Compose file path: qbittorrent/compose.yaml
Additional env file (optional): qbittorrent/sample.env

Then "Load" qbittorrent/sample.env into the Environmental variables in dockhand

Create the Stack

## Default username

Admin

## WireGuard

The container will fail to boot if VPN_ENABLED is set and there is no valid INTERFACE.conf file present in the /config/wireguard directory. Drop a .conf file from your VPN provider into /config/wireguard and start the container again.

    Recommended INTERFACE names include wg0 or wgvpn0 or even wgmgmtlan0. However, the number at the end is in fact optional, and really any free-form string [a-zA-Z0-9_=+.-]{1,15} will work. So even interface names corresponding to geographic locations would suffice, such as cincinnati, nyc, or paris, if that's somehow desirable. [source]

## Ensure Permissions

chmod 600 /path/to/wg0.conf

## Gotchas

For the trigus42/qbittorrentvpn image the env Username doesn't work, it's just admin.
