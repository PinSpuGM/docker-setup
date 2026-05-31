#!/bin/bash

# Completely uninstall Docker and remove all related data on Debian-based gcloud compute instances
# Written by Pin
#
# Download this script:
#   curl -fsSLO https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/uninstall_docker.bash
#   wget https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/uninstall_docker.bash

# Stop and disable Docker services
sudo systemctl stop docker docker.socket containerd 2>/dev/null
sudo systemctl disable docker docker.socket containerd 2>/dev/null

# Remove Docker packages (all components installed by install_docker.bash)
sudo apt-get purge -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  docker \
  docker-engine \
  docker.io \
  containerd \
  runc \
  2>/dev/null

sudo apt-get autoremove -y --purge

# Remove Docker data: images, containers, volumes, networks
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker config and runtime directories
sudo rm -rf /etc/docker
sudo rm -rf /run/docker
sudo rm -rf /run/docker.sock
sudo rm -f  /var/run/docker.sock

# Remove the Docker APT repository and GPG key (added by install_docker.bash)
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

# Remove Docker CLI configuration from the current user's home directory
rm -rf "$HOME/.docker"

# Remove the current user from the docker group, then delete the group
if getent group docker > /dev/null 2>&1; then
  if id -nG "$USER" | grep -qw docker; then
    sudo gpasswd -d "$USER" docker 2>/dev/null
  fi
  sudo groupdel docker 2>/dev/null
fi

# Refresh APT package index
sudo apt-get update

echo "Docker and all related data have been completely removed."
