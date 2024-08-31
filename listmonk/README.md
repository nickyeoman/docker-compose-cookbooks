example that I had working at one point
################################################################################
# listmonk
# port 9000
################################################################################
  listmonkdb:
    image: postgres:16.2
    restart: always
    environment:
      - POSTGRES_DB=listmonk
      - POSTGRES_USER=listmonk
      - POSTGRES_PASSWORD=censored
    volumes:
      - ./data/postgres:/var/lib/postgresql/data

  listmonk:
    image: listmonk/listmonk:v3.0.0
    restart: always
    command: [sh, -c, "yes | ./listmonk --install --config config.toml && ./listmonk --config config.toml"]
    volumes:
      - ./data/listmonk:/app/data
      - ./data/listmonk.config.toml:/listmonk/config.toml
