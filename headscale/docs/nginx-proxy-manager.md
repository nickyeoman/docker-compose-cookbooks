# Configure Nginx Proxy Manager

[← Back to README](../README.md)

Add a proxy host for your headscale domain:

* **Details tab:**
  * Domain Names: `headscale.example.com`
  * Scheme: `http`, Forward Hostname/IP: `headscale`, Forward Port: `8080`
  * Enable: **Websockets Support**, Block Common Exploits
* **SSL tab:**
  * Request a new Let's Encrypt certificate, force SSL
  * **Disable "HTTP/2 Support"** — important and easy to miss.

## Why HTTP/2 must be off

Tailscale clients register through a "noise" control protocol (`/ts2021`) that needs an upgrade handshake. Forcing HTTP/2 on this host silently breaks it, even though normal HTTPS requests (like `/health`) still work. Symptoms:

* `tailscale up` hangs indefinitely
* headscale logs `no upgrade header in TS2021 request`
* `/ts2021` requests return `status=500`

Don't disable caching/buffering unless you also see stalled long-poll connections — the important toggles are Websockets Support (on) and HTTP/2 Support (off).

## Admin UI

The admin panel goes on this **same** proxy host as a Custom Location (`/admin`), not a separate subdomain. See [Admin UI](admin-ui.md).
