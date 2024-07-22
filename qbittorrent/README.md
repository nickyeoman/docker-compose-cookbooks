# qbittorrent

https://github.com/Trigus42/alpine-qbittorrentvpn

"Docker container which runs the latest qBittorrent-nox client while connecting to WireGuard or OpenVPN with netfilter killswitch to prevent IP leakage when the tunnel goes down."

## Default username

Admin

## WireGuard

The container will fail to boot if VPN_ENABLED is set and there is no valid INTERFACE.conf file present in the /config/wireguard directory. Drop a .conf file from your VPN provider into /config/wireguard and start the container again.

    Recommended INTERFACE names include wg0 or wgvpn0 or even wgmgmtlan0. However, the number at the end is in fact optional, and really any free-form string [a-zA-Z0-9_=+.-]{1,15} will work. So even interface names corresponding to geographic locations would suffice, such as cincinnati, nyc, or paris, if that's somehow desirable. [source]

## Ensure Permissions
chmod 600 /path/to/wg0.conf


## Setup

env file
```text
# qbittorrent
COOKBOOK=/home/user/git/docker-compose-cookbooks #HELP: cookbooks
VOL_PATH=/project-dir/project-name/data #HELP: volpath
QBT_IMAGE=trigus42/qbittorrentvpn:latest
QBT_PASS=01234567890 #HELP: #HELP: gen32
```

extends file
```yaml
version: '3.4'

services:
	  qbittorrent:
      extends:
        file: ${COOKBOOK}/qbittorrent/docker-compose.yml
        service: qbittorrent
      env_file:
        - .env
```