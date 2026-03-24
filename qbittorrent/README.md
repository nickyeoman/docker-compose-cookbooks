# qbittorrent

"Docker container which runs the latest qBittorrent-nox client while connecting to WireGuard or OpenVPN with netfilter killswitch to prevent IP leakage when the tunnel goes down."

https://github.com/Trigus42/alpine-qbittorrentvpn

port: 8080

## Default username

Admin

## WireGuard

The container will fail to boot if VPN_ENABLED is set and there is no valid INTERFACE.conf file present in the /config/wireguard directory. Drop a .conf file from your VPN provider into /config/wireguard and start the container again.

    Recommended INTERFACE names include wg0 or wgvpn0 or even wgmgmtlan0. However, the number at the end is in fact optional, and really any free-form string [a-zA-Z0-9_=+.-]{1,15} will work. So even interface names corresponding to geographic locations would suffice, such as cincinnati, nyc, or paris, if that's somehow desirable. [source]

## Ensure Permissions

chmod 600 /path/to/wg0.conf

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: qbittorrent
Compose file path: qbittorrent/compose.yaml
Additional env file (optional): qbittorrent/sample.env

Then "Load" archivebox/sample.env into the Environmental variables in dockhand

Create the Stack


## Gotchas

For the trigus42/qbittorrentvpn image the env Username doesn't work, it's just admin.