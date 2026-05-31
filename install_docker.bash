#!/bin/bash

# This is a minimal script to install Docker on Debian-based gcloud compute instances
# Written by Pin
#
# Download this script:
#   curl -fsSLO https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/install_docker.bash
#   wget https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/install_docker.bash

# Remove any previously installed Docker versions
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null

# Install required dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the Docker APT repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start the Docker service and enable it to start automatically on boot
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to the docker group to avoid "permission denied" errors
if getent group docker &>/dev/null; then
  if ! id -nG "$USER" | grep -qw docker; then
    sudo gpasswd -a "$USER" docker
  fi
fi

# Fix docker socket ownership and permissions
SOCK="/var/run/docker.sock"
if [ -S "$SOCK" ]; then
  sudo chown root:docker "$SOCK"
  sudo chmod 660 "$SOCK"
fi

echo "Docker installed! Log out and back in for group changes to take effect."
docker --version