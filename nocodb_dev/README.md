# nocodb

Last Updated: Thu August 01, 2024 18:40:57 PDT

## Overview
Docker Hub: https://hub.docker.com/r/nocodb/nocodb
Project: https://nocodb.com/
Docker Compose Example: https://github.com/nocodb/nocodb/blob/master/docker-compose/mysql/docker-compose.yml
Proxy Port: 8080

## Description

This project is setup to use sql lite.  Although it can use mysql with some env vars.

## Notes

# environment:
    #   - NC_DB=${NCDB_NC_DB:-mysql2://root_db:3306?u=noco&p=password&d=root_db}