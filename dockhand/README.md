# Dockhand

Port: 3000

I'm using this to replace portainer.

## Run an Agent

```
docker run -d \
  --name hawser-dockhand-agent \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DOCKHAND_URL="https://dockhand.example.com" \
  -e DOCKHAND_TOKEN="PFTtPtVFcJ7nCppmbVzqCN4pt4Vxzkjp" \
  ghcr.io/dockhand/hawser:latest
```

## Ansible

This is how I got it working on ansible (roughly):

```
- name: HAWSER - Pull Docker Image
  docker_image:
    name: "ghcr.io/finsys/hawser:{{ hawser_version }}"
    source: pull

- name: HAWSER - Ensure container is running
  docker_container:
    name: hawser
    recreate: true
    image: "ghcr.io/finsys/hawser:{{ hawser_version }}"
    state: started
    restart_policy: always
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    env:
      DOCKHAND_SERVER_URL: "{{ dockhand_url }}"
      TOKEN: "{{ hawser_token }}"
      AGENT_NAME: "{{ hawser_agent_name }}"
```