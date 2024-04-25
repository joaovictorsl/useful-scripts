#!/bin/bash
# Uninstall conflicting packages
echo ====\> UNINSTALL ALL CONFLICTING PACKAGES
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Set up Docker's apt repository
echo ====\> SETTING UP DOCKER\'S APT REPOSITORY
sudo apt-get update &&
sudo apt-get install ca-certificates curl -y &&
sudo install -m 0755 -d /etc/apt/keyrings &&
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
sudo chmod a+r /etc/apt/keyrings/docker.asc &&

# Add the repository to apt sources
echo ====\> ADD REPOSITORY TO APT SOURCES
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
echo ====\> INSTALLING DOCKER
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &&

# Manage Docker as a non-root user
echo ====\> RUNNING POSTINSTALL STUFF
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo ====\> DONE!
