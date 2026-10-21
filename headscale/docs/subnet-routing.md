# Subnet Routing (Optional)

[← Back to README](../README.md)

Commands below use `$HEADSCALE_CONTAINER`. Set it once per shell session on the dedicated server (change the value if your compose project name differs; find it with `docker ps`):

```bash
export HEADSCALE_CONTAINER=headscale-headscale-1
```

Lets tailnet devices reach *everything* on the LAN, not just the LAN node.

On the **LAN node**:

```bash
sudo tailscale up --login-server=https://headscale.example.com --advertise-routes=192.168.1.0/24

# enable IP forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

Approve the route on the **dedicated server**:

```bash
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes list-routes
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes approve-routes -i <NODE-ID> --routes 192.168.1.0/24
```
