#!/bin/bash
GREEN='\033[1;32m'
NO_COLOR='\033[0m'

echo -e "${GREEN}====> UNINSTALL ALL CONFLICTING PACKAGES${NO_COLOR}"

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo -e "${GREEN}====> SETTING UP DOCKER'S APT REPOSITORY${NO_COLOR}"

sudo apt-get update &&
sudo apt-get install ca-certificates curl -y &&
sudo install -m 0755 -d /etc/apt/keyrings &&
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
sudo chmod a+r /etc/apt/keyrings/docker.asc &&

echo -e "${GREEN}====> ADD REPOSITORY TO APT SOURCES${NO_COLOR}"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo -e "${GREEN}====> INSTALLING DOCKER${NO_COLOR}"

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &&

echo -e "${GREEN}====> RUNNING POSTINSTALL STUFF${NO_COLOR}"

# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER

echo -e "${GREEN}====> DONE!${NO_COLOR}"

newgrp docker
