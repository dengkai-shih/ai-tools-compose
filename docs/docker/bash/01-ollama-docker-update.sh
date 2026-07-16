#!/bin/bash
# Program:
#       ollama-docker-update is a script to update ollama-docker to the latest version.
# History:
# 2026/06/10	Kyle	First release
# 2026/07/13	Kyle	Added docker compose up --pull never -d to recreate containers without pulling the latest image
#
# 1. update project data
# 1-1. pull newest github data
sudo git pull origin main
# 1-2. Pull updated image
sudo docker compose pull
# 1-3. Recreate containers
sudo docker compose up -d # pulls the latest image and recreates the containers
sudo docker compose up --pull never -d # recreates the containers without pulling the latest image
# 1-4. Prune Old Images
sudo docker image prune -f