# Directus

[official Website](https://directus.io/) and [Documentation](https://docs.directus.io/)

[Docker Hub](https://hub.docker.com/r/directus/directus)

Proxy port: 8055

On first run: The initial admin email address and password will be shown in the terminal. 
If you forgot and did a detached: ```docker compose logs -f```

## Gotacha

Reset password:
```bash
sudo nala install argon2
echo -n "TheNewPasswordHere" | argon2 "$(openssl rand -base64 16)" -id -m 16 -t 3 -p 4
```
