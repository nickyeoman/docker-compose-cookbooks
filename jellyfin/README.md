# Jellyfin

## Overview

Jellyfin is a free, open-source media server. It organizes your movies, shows, music and books and streams them to web, mobile and TV clients. In this setup Sonarr and Radarr fill the library; Jellyfin just reads it.

## Project Details

- **Project Repository:** [https://jellyfin.org/](https://jellyfin.org/) ([Docs](https://jellyfin.org/docs/))
- **Container Image:** [jellyfin/jellyfin](https://hub.docker.com/r/jellyfin/jellyfin)
- **Reverse Proxy Port:** `8096`

## Getting Started

### Prepare the shared media folder (once per host)

All media apps run as user `1000` and share `/data/media`. If Docker creates the folder itself it's owned by root, and the apps fail with *"Folder '/media/' is not writable by user 'hotio'"*. Create it with the right owner before first start:

```bash
sudo mkdir -p /data/media/{downloads/prowlarr,movies,shows,music,books}
sudo chown -R 1000:1000 /data/media
sudo chmod -R u+rwX,g+rwX /data/media
```

Check with `ls -ln /data/media` — the owner should be `1000 1000`.

Open http://localhost:8096 in your browser and complete the setup wizard:

1. **Create your admin account**
2. **Add media libraries** — point each one at the matching container folder:

   | Library type | Folder |
   |---|---|
   | Movies | `/movies` |
   | Shows | `/shows` |
   | Music | `/music` |
   | Books | `/books` |

3. Finish the wizard. Jellyfin scans the folders and pulls metadata.

For Jellyseerr, create an API key under **Dashboard → API Keys**.

### GPU transcoding (optional)

Deploy `compose-gpu.yaml` instead of `compose.yaml`. It uses the same env vars. The file defaults to NVIDIA.

1. **Install the NVIDIA Container Toolkit on the host** (once per host; skip it if another GPU stack such as Ollama already works):

   ```bash
   sudo pacman -S nvidia-container-toolkit        # Arch
   sudo nvidia-ctk runtime configure --runtime=docker
   sudo systemctl restart docker
   ```

2. **Check the container can see the GPU:** `docker exec jellyfin nvidia-smi`
3. **Enable it in Jellyfin:** go to **Dashboard → Playback → Transcoding**:
   - **Hardware acceleration:** NVENC
   - **Hardware decoding:** tick every codec your card supports. An RTX 30-series card decodes H.264, HEVC (incl. 10bit), VP9 (incl. 10bit) and AV1.
   - **AV1 encoding:** RTX 40-series and newer only. Leave it off on older cards.
   - **Tone mapping:** turn it on for HDR content. It runs on the GPU.
4. **Confirm it's working:** play something that needs transcoding. `nvidia-smi` on the host should list a `jellyfin-ffmpeg` process.

**Intel/AMD:** in `compose-gpu.yaml`, remove the `deploy` block and uncomment the `/dev/dri:/dev/dri` device. Then choose VAAPI (AMD) or QSV (Intel) as the hardware acceleration.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `JELLYFIN_IMAGE` | Container image (default: `jellyfin/jellyfin:latest`) |
| `JELLYFIN_RESTART` | Restart policy (default: `unless-stopped`) |
| `JELLYFIN_PORT` | Published port for the web UI (default: `8096`) |
| `JELLYFIN_URL` | Public URL clients use to reach the server (default: `http://localhost:8096`) — set this to your reverse proxy URL |
| `JELLYFIN_MEDIA` | Shared media root on the host (default: `/data/media`) — the same folder qBittorrent, Sonarr, Radarr and Bazarr use |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/jellyfin/config` | Configuration, database and metadata |
| `${VOL_PATH:-/data}/jellyfin/cache` | Transcode and image cache |
| `${JELLYFIN_MEDIA:-/data/media}/movies` → `/movies` | Movies (Radarr root folder `/media/movies`) |
| `${JELLYFIN_MEDIA:-/data/media}/shows` → `/shows` | TV shows (Sonarr root folder `/media/shows`) |
| `${JELLYFIN_MEDIA:-/data/media}/music` → `/music` | Music |
| `${JELLYFIN_MEDIA:-/data/media}/books` → `/books` | Books |

Jellyfin mounts only the library subfolders, not `/data/media/downloads`, so half-finished downloads never show up in the library.

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

Jellyseerr reaches Jellyfin at `http://jellyfin:8096` over the `proxy` network.

## Docker Run

```bash
docker run -d \
  --name=jellyfin \
  -e JELLYFIN_PublishedServerUrl=http://localhost:8096 \
  -p 8096:8096 \
  -v ${VOL_PATH:-/data}/jellyfin/cache:/cache \
  -v ${VOL_PATH:-/data}/jellyfin/config:/config \
  -v ${JELLYFIN_MEDIA:-/data/media}/books:/books \
  -v ${JELLYFIN_MEDIA:-/data/media}/movies:/movies \
  -v ${JELLYFIN_MEDIA:-/data/media}/music:/music \
  -v ${JELLYFIN_MEDIA:-/data/media}/shows:/shows \
  --network proxy \
  --restart unless-stopped \
  jellyfin/jellyfin:latest
```

## Additional Notes / Gotchas

- **Only port 8096 is published.** HTTPS (8920) is handled by Nginx Proxy Manager. Local network auto-discovery (UDP 1900/7359) won't work through the bridge network, so add the server to clients by URL.
- **Photos** are left out on purpose — use the Immich stack for photo libraries.
- **Hardware transcoding** is not in `compose.yaml`. See *GPU transcoding* under Getting Started.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** jellyfin
- **Compose file path:** jellyfin/compose.yaml (or jellyfin/compose-gpu.yaml for hardware transcoding)
- **Additional env file (optional):** jellyfin/sample.env

Load `jellyfin/sample.env` into the Environment variables in Dockhand, then create the Stack.
