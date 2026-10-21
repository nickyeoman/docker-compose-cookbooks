# Connect Phone / Laptop

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

## Android / iOS

1. Install the Tailscale app (Play Store / App Store).
2. Point it at your server:
   * **Android** (tested on v1.102.3, Galaxy S25 Ultra): **Settings → Add account**, tap the **three-dot menu (⋮)**, choose the alternate/custom coordination server option, enter `https://headscale.example.com`.
   * **iOS:** on the sign-in screen, choose **Alternate coordination server** before logging in.
3. Log in. If the app shows a registration key instead of accepting a pre-auth key, approve it on the dedicated server:
   ```bash
   docker exec -it "$HEADSCALE_CONTAINER" headscale nodes register --user homelab --key <KEY-FROM-DEVICE>
   ```

## Laptop / Desktop

Install the client (https://tailscale.com/download), then either use a pre-auth key:

```bash
sudo tailscale up --login-server=https://headscale.example.com --authkey <YOUR-PREAUTH-KEY>
```

Or approve interactively:

```bash
sudo tailscale up --login-server=https://headscale.example.com
# copy the printed key, then on the dedicated server:
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes register --user homelab --key <KEY-FROM-DEVICE>
```
