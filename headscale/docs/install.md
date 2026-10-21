# Install Headscale

[← Back to README](../README.md)

Run on the **dedicated server** (public IP).

```bash
# Copy the starter config into place, then edit it
mkdir -p /data/headscale/config
cp config.yaml /data/headscale/config/config.yaml
nano /data/headscale/config/config.yaml   # set server_url to YOUR domain, e.g. https://headscale.example.com

# Copy env defaults and start the stack
cp sample.env .env
docker compose up -d
```

Headscale will not start without a valid `config.yaml`, and `server_url` **must** match your public domain.

Next: [configure Nginx Proxy Manager](nginx-proxy-manager.md), then verify:

```bash
curl https://headscale.example.com/health
```
