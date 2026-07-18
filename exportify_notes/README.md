# Exportify

Exportify exports your Spotify playlists (tracks, artists, albums, and audio features) to CSV files. It has no published container image — only a Dockerfile you'd have to build yourself — and the hosted version runs entirely client-side in the browser with no server-side data storage, so there's nothing to self-host that isn't better served by the hosted app. See `container-requests.md` for the "will not be in the repo" rationale.

- Project Repository: https://github.com/watsonbox/exportify
- Hosted App: https://exportify.app/

## Tutorial: Exporting your Spotify playlists

### Option A — use the hosted app (recommended)

1. Go to https://exportify.app/
2. Click **Log in with Spotify** and authorize the app (it only requests read access to your playlists — it never modifies your Spotify account)
3. Your playlists load as a list; click **Export** next to a single playlist to download its CSV, or **Export All** to download every playlist as a zip of CSVs
4. Each CSV includes: Track URI, Track Name, Artist, Album, Release Date, Duration, Popularity, and Spotify audio-feature columns (Danceability, Energy, Key, Loudness, Tempo, etc.)

Since everything runs in your browser and talks directly to Spotify's API, no data passes through or is stored on any third-party server.

### Option B — run it yourself (no published image, build from source)

Only worth doing if you don't trust the hosted instance or want to self-host on an internal network.

```bash
git clone https://github.com/watsonbox/exportify.git
cd exportify
```

1. Create a Spotify app at https://developer.spotify.com/dashboard to get a Client ID
2. Add your redirect URI (e.g. `http://localhost:5000/callback` or your own domain) in the Spotify app settings
3. Copy the example env and set your client id/redirect uri:
   ```bash
   cp .env.example .env
   nano .env
   ```
4. Build and run with the project's own Dockerfile:
   ```bash
   docker build -t exportify .
   docker run -d --name exportify -p 5000:5000 --env-file .env exportify
   ```
5. Open `http://localhost:5000` and log in with Spotify as above

### Using the exported CSVs

- Import into a spreadsheet to dedupe playlists, sort by audio features, or build custom smart playlists
- Feed into other tools (e.g. `pandas.read_csv`) for playlist analysis
- Re-import isn't supported by Exportify itself — CSV export is one-way; use a separate tool (e.g. `spotify-backup`, `soundiiz`) if you need CSV-to-Spotify import

## Gotchas

- Spotify's API rate-limits large libraries; exporting many playlists back-to-back may need retries
- Audio-feature columns depend on Spotify's Audio Features API remaining available — Spotify has deprecated/restricted parts of this API for new apps in the past, so some columns may be blank depending on your app's API access tier
- The self-hosted route requires you to register and maintain your own Spotify Developer app (Client ID + redirect URI), which the hosted version already handles for you
