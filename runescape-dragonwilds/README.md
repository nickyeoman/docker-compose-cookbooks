# runescape-dragonwilds

## Overview

Dedicated server for RuneScape: DragonWilds, run via SteamCMD. Server files are downloaded/updated on start and saves persist to a host volume.

## Project Details

-   **Project Repository:** [indifferentbroccoli/runescape-dragonwilds-server-docker](https://github.com/indifferentbroccoli/runescape-dragonwilds-server-docker)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/indifferentbroccoli/runescape-dragonwilds-server-docker)
-   **Compose Example:** [Compose](https://github.com/indifferentbroccoli/runescape-dragonwilds-server-docker#docker-compose)
-   **Reverse Proxy Port:** none — game traffic is UDP `7777` (game) and `8888` (beacon), not proxied through NPM

## Getting Started

1. Copy `sample.env` to `.env` and set `RSDW_OWNER_ID` (your Player ID, found in the game's Settings) and `RSDW_ADMIN_PASSWORD`
2. Forward UDP `7777` and `8888` on your router/firewall to the Docker host
3. Start the container: `docker compose up -d`
4. Watch the first start (it downloads the server files): `docker compose logs -f`
5. In game, find the server by `RSDW_SERVER_NAME` and use `RSDW_ADMIN_PASSWORD` for Server Management

## Environment Variable Notes

    RSDW_OWNER_ID – REQUIRED. Your RuneScape: DragonWilds Player ID (in-game Settings)
    RSDW_ADMIN_PASSWORD – REQUIRED. Server Management password, default: ChangeThisPassword
    RSDW_WORLD_PASSWORD – optional join password; empty = public
    RSDW_SERVER_NAME – server display name, default: DragonWildsServer
    RSDW_WORLD_NAME – world created on first start, default: MyWorld
    RSDW_MAX_PLAYERS – default: 6
    RSDW_PORT – game UDP port, default: 7777 (also sets DEFAULT_PORT in the container)
    RSDW_BEACON_PORT – world settings beacon UDP port, default: 8888 (also sets BEACON_PORT)
    RSDW_UPDATE_ON_START – set false to skip SteamCMD download/validation on start
    RSDW_PUID / RSDW_PGID – owner of the server files, default: 1000

## Volume Notes

    /home/steam/server-files – host path /data/runescape-dragonwilds/server-files (server binaries, saves, config)

Back up the saves inside this directory; the server binaries can be re-downloaded.

## Network Notes

Requires proxy network (declared for convention only — players connect directly over UDP, not through NPM).

## Docker Run

```bash
docker run -d \
  --name runescape-dragonwilds \
  --restart unless-stopped \
  --stop-timeout 30 \
  -p 7777:7777/udp \
  -p 8888:8888/udp \
  -e OWNER_ID=YourPlayerId \
  -e ADMIN_PASSWORD=ChangeThisPassword \
  -v /data/runescape-dragonwilds/server-files:/home/steam/server-files \
  indifferentbroccoli/runescape-dragonwilds-server-docker:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

- Host and container ports **must match** — mismatched ports cause join failures. The compose file uses the same var for both sides; don't remap one without the other.
- The beacon port (8888) is required for creating/editing worlds.
- The server won't show up without working port forwarding and a valid `OWNER_ID`/`ADMIN_PASSWORD`.
- RAM: about 2 GB + 1 GB per player (8 GB for a full 6-player server).
- `stop_grace_period: 30s` gives the server time to save on shutdown.
- Crossplay (PC, PS5, Xbox Series X|S, Switch 2) is supported since 1.0. The image doesn't set `PlatformPolicy` in `DedicatedServer.ini`, so the game default (`Crossplay`) applies. It rewrites that file on every start, so a manual `PlatformPolicy=` edit to lock the server to one platform won't survive a restart.
- Clients must be on the same game version as the server — keep `RSDW_UPDATE_ON_START=true` and restart after game patches. There is no cross-save: character progress doesn't carry between platforms.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: runescape-dragonwilds
Compose file path: runescape-dragonwilds/compose.yaml
Additional env file (optional): runescape-dragonwilds/sample.env

Then "Load" runescape-dragonwilds/sample.env into the Environmental variables in dockhand

Create the Stack
