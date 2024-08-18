# nextcloud

Docker Hub: https://hub.docker.com/_/nextcloud
Proxy Port: 80

## Useful commands

```bash
sudo -u www-data php occ app:list
sudo -u www-data php occ app:disable <appname>
sudo -u www-data php occ maintenance:mode --on
php occ trashbin:cleanup --all-users

docker-compose exec --user www-data nextcloud php occ
```