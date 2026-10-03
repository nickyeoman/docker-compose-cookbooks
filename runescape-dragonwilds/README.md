# runescape-dragonwilds

## Overview

Dedicated server for RuneScape: DragonWilds. Runs on a Linux Docker host and accepts players from PC, PS5, Xbox Series X|S and Switch 2 (crossplay, game 1.0+). Server files are downloaded/updated on start and saves persist to a host volume.

## Project Details

-   **Project Repository:** [indifferentbroccoli/runescape-dragonwilds-server-docker](https://github.com/indifferentbroccoli/runescape-dragonwilds-server-docker)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/indifferentbroccoli/runescape-dragonwilds-server-docker)
-   **Compose Example:** [Compose](https://github.com/indifferentbroccoli/runescape-dragonwilds-server-docker#docker-compose)
-   **Documentation:** [Dedicated Servers - A How-To Guide](https://dragonwilds.runescape.com/news/how-to-dedicated-servers)
-   **Reverse Proxy Port:** none — game traffic is UDP `7777` (game) and `8888` (beacon), not proxied through NPM

## Getting Started

Consoles can't run the server, so you need a separate always-on machine (rented dedicated server, VPS or home server). These steps assume a Linux host that already runs Docker with the `proxy` network created, an x86_64 (amd64) CPU (the image has no ARM build), at least 8 GB RAM, and that you only own the Xbox version of the game.

### 1. Get your Player ID (on the Xbox)

1. On the Xbox, open RuneScape: DragonWilds → **Settings** and scroll to the bottom
2. Note the **Player ID** — 32 letters and numbers. There's no clipboard from Xbox to the server, so copy it out carefully (a photo of the screen helps). One wrong character and the server won't recognise you as owner.

### 2. Open the ports

Players connect straight to the server over UDP, so UDP `7777` and `8888` have to be reachable from the internet. Which steps apply depends on where the server lives — check whether its own IP (`ip -4 addr`) matches its public IP (`curl -4 ifconfig.me`).

**Rented dedicated server / VPS (the server's IP is public):** no router or port forwarding involved. Open UDP `7777` and `8888` in the hosting provider's network firewall / security group, if one is enabled in their control panel.

### 3. Deploy with Dockhand

1. Create the stack from Git as described in [Dockhand Stack, Deploy from Git](#dockhand-stack-deploy-from-git) and "Load" `runescape-dragonwilds/sample.env` into the environment variables
2. Before deploying, edit these variables in Dockhand:
    - `RSDW_OWNER_ID` – the Player ID from step 1 (the container exits with `OWNER_ID is not set` if empty)
    - `RSDW_ADMIN_PASSWORD` – replace `ChangeThisPassword`
    - `RSDW_WORLD_NAME` – the name players will search for
    - `RSDW_WORLD_PASSWORD` – optional, leave empty for a public world
3. Deploy the stack and watch the container logs in Dockhand — the first start downloads several GB of server files before the server comes up

### 4. Join from the Xbox

1. Xbox **Settings → Account → Privacy & online safety**: allow playing with people outside Xbox (crossplay is blocked at the console level otherwise). An Xbox Game Pass Core/Ultimate subscription is needed for online play.
2. In game: **Play → Worlds → Public** tab, search for the exact `RSDW_WORLD_NAME` (case sensitive), wait a few seconds, then join.
3. Enter `RSDW_WORLD_PASSWORD` if you set one. Use `RSDW_ADMIN_PASSWORD` under **Server Management** to change world settings.

If the world shows up in search but you can't join, the ports aren't reachable — recheck step 2.

## Environment Variable Notes

    RSDW_OWNER_ID – REQUIRED. Your Player ID (bottom of the in-game Settings menu, see Getting Started)
    RSDW_ADMIN_PASSWORD – REQUIRED. Server Management password, default: ChangeThisPassword
    RSDW_WORLD_PASSWORD – optional join password; empty = public
    RSDW_SERVER_NAME – server display name, default: DragonWildsServer
    RSDW_WORLD_NAME – world created on first start; this is what players search for, default: MyWorld
    RSDW_MAX_PLAYERS – default: 6
    RSDW_PORT – game UDP port, default: 7777 (also sets DEFAULT_PORT in the container)
    RSDW_BEACON_PORT – world settings beacon UDP port, default: 8888 (also sets BEACON_PORT)
    RSDW_UPDATE_ON_START – set false to skip the server download/validation on start
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
- Joining players never need the Owner ID — only the host does.
- RAM: about 2 GB + 1 GB per player (8 GB for a full 6-player server).
- Older CPUs: if the container dies with `Illegal instruction` right after the download finishes, the CPU is missing an instruction set the server binary needs (e.g. AVX2) — use a newer host.
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
