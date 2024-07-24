# Vaultwarden

Dockerhub: https://hub.docker.com/r/vaultwarden/server
Github: https://github.com/dani-garcia/vaultwarden
Wiki: https://github.com/dani-garcia/vaultwarden/wiki

Reverse Proxy Port: 80

## Usage

[Disable new users](https://github.com/dani-garcia/bitwarden_rs/wiki/Disable-registration-of-new-users).

[SMTP](https://github.com/dani-garcia/bitwarden_rs/wiki/SMTP-configuration)

To enable the admin page, you need to set an authentication token. This token can be anything, but it's recommended to use a long, randomly generated string of characters, for example running openssl rand -base64 48.