# PeerTube

* [Docs](https://docs.joinpeertube.org/)

Proxy port: 1935

Change admin user (username is admin in gui but root in cli):

```
docker compose exec peertube npm run reset-password -- -u root
```

NOTICE: I've added this one for testing, it didn't fit what I was wanting, but I'll levae it here as it did boot.
