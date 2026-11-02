# Radarr

## Overview

Radarr is an automated movie collection manager for Usenet and BitTorrent users. It monitors your watchlist (from Trakt, IMDb, etc.), scans configured indexers for releases, and sends matches to your download client. After download, it renames and organizes files into your movie library and notifies your media server.

## Project Details

- **Project Repository:** [https://radarr.video/](https://radarr.video/)
- **Container Image:** [ghcr.io/hotio/radarr](https://hotio.dev/containers/radarr/)
- **Reverse Proxy Port:** `7878`

## Getting Started

### Prepare the shared media folder (once per host)

All media apps run as user `1000` and share `/data/media`. If Docker creates the folder itself it's owned by root, and the apps fail with *"Folder '/media/' is not writable by user 'hotio'"*. Create it with the right owner before first start:

```bash
sudo mkdir -p /data/media/{downloads/prowlarr,movies,shows,music,books}
sudo chown -R 1000:1000 /data/media
sudo chmod -R u+rwX,g+rwX /data/media
```

Check with `ls -ln /data/media` — the owner should be `1000 1000`.

Open http://localhost:7878 in your browser. Do these in order: the qBittorrent download client and Prowlarr need to be connected before you add movies.

1. **Create the admin account.** On first boot Radarr shows an *Authentication Required* dialog. Set **Authentication Method** to `Forms (Login Page)`, choose a username and password, click **Save**, and sign in.
2. **Copy Radarr's API key.** Go to **Settings → General → Security** and copy the **API Key**. Prowlarr needs it in step 4.
3. **Add the root folder.** Go to **Settings → Media Management → Add Root Folder** and choose `/media/movies`. Under **Importing**, turn on **Use Hardlinks instead of Copy** (click **Show Advanced** at the top if you don't see it).
4. **Connect Prowlarr.** This step is done in **Prowlarr** (http://localhost:9696), not Radarr. Go to **Settings → Apps → `+` → Radarr** and fill in:

   | Field | Value |
   |---|---|
   | Name | `Radarr` |
   | Sync Level | `Full Sync` |
   | Prowlarr Server | `http://prowlarr:9696` |
   | Radarr Server | `http://radarr:7878` |
   | API Key | the key from step 2 |
   | Sync Categories | leave the defaults (Movies, `2000`-range) |

   Click **Test**. A green check means both directions work. Click **Save**.

   Then in Prowlarr, go to **Settings → Apps** and click **Sync App Indexers**. Back in Radarr, **Settings → Indexers** should now list every Prowlarr indexer, each named `<indexer> (Prowlarr)`. Don't add or edit indexers in Radarr. Prowlarr owns them and overwrites changes on the next sync.
5. **Add qBittorrent as the download client.** In Radarr, go to **Settings → Download Clients → `+` → qBittorrent**:

   | Field | Value |
   |---|---|
   | Name | `qBittorrent` |
   | Host | `qbittorrent` |
   | Port | `8080` |
   | Username | `admin` |
   | Password | `QBT_PASS` from the qBittorrent stack |
   | Category | `prowlarr` |

   Click **Test**, then **Save**. The category makes qBittorrent save Radarr's downloads to `/media/downloads/prowlarr`, which Radarr can see at the same path.
6. **Add a movie.** Click **Add New**, search for a title, pick the root folder `/media/movies` and a quality profile, tick **Start search for missing movie**, then **Add Movie**. Check progress under **Activity → Queue**.

Optionally connect a **List** (Trakt, IMDb, etc.) under **Settings → Lists** to auto-add movies from your watchlists.

#### If the Prowlarr test fails

- **"Unable to connect to Radarr"**: Prowlarr and Radarr must both be on the `proxy` network. Use container names, never `localhost`. Inside a container, `localhost` is the container itself.
- **"Unauthorized" or 401**: the API key is wrong. Copy it again from Radarr's **Settings → General**.
- **Test passes but no indexers show up in Radarr**: click **Sync App Indexers** in Prowlarr, and check that the indexers in Prowlarr support movie categories (`2000`-range).
- **Searches find nothing**: check **System → Status** in both apps for indexer health warnings. A Cloudflare-protected indexer needs the `flaresolverr` tag in Prowlarr (see the Prowlarr README).

### Download flow

qBittorrent downloads to `/media/downloads/prowlarr` → Radarr picks it up, renames the file, and moves it into `<Root Folder>/Movie Name (Year)/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `RADARR_IMAGE` | Container image (default: `ghcr.io/hotio/radarr:release`) |
| `RADARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `RADARR_PORT` | Published port for the web UI (default: `7878`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `RADARR_MEDIA` | Shared media root on the host (default: `/data/media`), mounted at `/media`. Must be the same folder qBittorrent, Sonarr and Jellyfin use |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/radarr/config` | Application configuration and database |
| `${RADARR_MEDIA:-/data/media}` → `/media` | Shared media library, kept separate from `VOL_PATH` since it's typically mounted into Sonarr, Radarr, Bazarr, and Jellyfin/etc. |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=radarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 7878:7878 \
  -v ${VOL_PATH:-/data}/radarr/config:/config \
  -v ${RADARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/radarr:release
```

## Additional Notes / Gotchas

- **One shared media folder.** qBittorrent, Sonarr, Radarr and Jellyfin all use `/data/media` on the host. qBittorrent, Sonarr and Radarr mount it at `/media`, so a download has the same path in every container: no Remote Path Mapping needed, and imports can use hardlinks (instant, no extra disk space). Enable **Settings → Media Management → Use Hardlinks instead of Copy**.
- **Layout:** `/data/media/downloads/prowlarr` (qBittorrent category `prowlarr`), `/data/media/shows` (Sonarr), `/data/media/movies` (Radarr). The `shows`/`movies` names match the Jellyfin stack's library mounts.
- In the qBittorrent download client settings, set **Category** to `prowlarr`.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** radarr
- **Compose file path:** radarr/compose.yaml
- **Additional env file (optional):** radarr/sample.env

Load `radarr/sample.env` into the Environment variables in Dockhand, then create the Stack.
