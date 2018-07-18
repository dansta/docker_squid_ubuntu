#!/bin/bash

# Create image
docker build -t 192.168.1.1:5000/squid:1 .
docker push 192.168.10.1:5000/squid:1

docker volume create squid

# Create service
docker service create \
            --replicas 4 \
            --update-delay 60s \
            --update-parallelism 1 \
            --env SQUID_PASSWORD="secretpassword" \
            --mount source=squid,target=/var/log/squid/ \
            --mount source=squid,target=/var/spool/squid/ \
            --name "squid" \
            --publish published=3128,target=3128 \
            --publish published=3130,target=3130 \
            --publish published=4003,target=4003 \
            --publish published=4002,target=4002 \
            --publish published=4827,target=4827 \
            --publish published=4000,target=4000 \
            192.168.1.1:5000/squid:1
