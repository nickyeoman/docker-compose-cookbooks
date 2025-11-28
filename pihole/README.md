# PiHole

## Overview

This Docker Compose project deploys a Pi-hole DNS sinkhole and network-wide ad blocker. It centralizes DNS filtering, logging, and management behind a lightweight containerized service.

## Project Details

-   **Project Repository:** [Link](https://pi-hole.net/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/pihole/pihole)
-   **Compose Example:** [Compose](https://hub.docker.com/r/pihole/pihole)
-   **Documentation:** [Docs](https://docs.docker.com/compose/install/)
-   **Reverse Proxy Port:** `53 (tcp & udp), 80, 443, 67, 123`

## Environment Variable Notes

Below are the key environment variables commonly used with the Pi-hole container.  
You can also read more here: https://hub.docker.com/r/pihole/pihole

```
TZ – Your timezone (e.g., "America/Toronto"). Used for correct log timestamps.
WEBPASSWORD – Password for the Pi-hole admin web interface. If omitted, a random one is generated.
DNSMASQ_LISTENING – Set to "all" to allow queries from the LAN.
ServerIP – The host machine’s LAN IP address. Required so Pi-hole can properly generate block pages.
FTLCONF_LOCAL_IPV4 – Alternative to ServerIP for newer versions; defines Pi-hole’s listening IP.
INTERFACE – Network interface Pi-hole should bind to (e.g., eth0). Optional if using host networking.
VIRTUAL_HOST – (Optional) Used with reverse proxies for URL routing.
```

## Volume Notes

Pi-hole uses volumes to persist configuration and query data:

```
/etc/pihole – Stores Pi-hole configs, gravity lists, custom blocklists, DHCP settings, logs.
/etc/dnsmasq.d – Stores dnsmasq configuration files used by Pi-hole’s DNS service.
```

## Additional Notes / Gotchas

DHCP Server: If running Pi-hole as your network DHCP server, the container must run in host networking mode to broadcast DHCP packets correctly.

Networking: Pi-hole works best in host networking mode. If using bridge mode, you must set ServerIP and ensure port 53 (TCP/UDP) is exposed.

Port Conflicts: Nothing else on the host may use port 53. Disable systemd-resolved or any local DNS server if necessary.

Docker + Reverse Proxy: Pi-hole doesn’t always play nicely behind reverse proxies. If using one, forward only the admin interface (port 80) and keep DNS ports (53) exposed directly.

Gravity Updates: Pi-hole updates blocklists daily. If using custom lists, verify they can be fetched without authentication or special headers.
