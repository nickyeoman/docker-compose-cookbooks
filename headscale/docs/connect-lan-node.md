# Connect the LAN Node

[← Back to README](../README.md)

On the **LAN node** (the Docker host running Jellyfin etc.), install the Tailscale client.

**Debian/Ubuntu:**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled
```

**Arch:**
```bash
sudo pacman -S tailscale
sudo systemctl enable --now tailscaled
```

Then on any distro:
```bash
sudo tailscale up --login-server=https://headscale.example.com --authkey <YOUR-PREAUTH-KEY>
```

Firewall: allow UDP 41641 for direct WireGuard connections (Tailscale falls back to slower DERP relays if blocked).

To reach *other* LAN devices through this node, see [Subnet Routing](subnet-routing.md).
