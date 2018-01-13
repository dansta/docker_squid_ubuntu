#!/bin/bash

# Run as root in the same directory as the Dockerfile

# Install password gen
apt-get install pwgen

# Create image
docker build -t squid:0.0.100 .


# Create east-west network
docker network create \
            --opt encrypted \
            --subnet 10.0.0.0/24 \
            --driver overlay \
            squid 

# Create volume for squid
docker volume create squid

# Create service
docker service create \
            --mode global \
            --update-delay 10s \
            --update-parallelism 2 \
            --env SQUID_PASSWORD="$(pwgen -N 1)" \
            --network squid \
            --mount source=squid,target=/var/log/docker/squid/ \
            --mount source=squid,target=/var/docker/squid/ \
            --name "squid" \
            --publish published=3128,target=3128 \
            --publish published=3130,target=3130 \
            --publish published=4003,target=4003 \
            --publish published=4002,target=4002 \
            --publish published=4827,target=4827 \
            --publish published=4000,target=4000 \
            squid:0.0.100

