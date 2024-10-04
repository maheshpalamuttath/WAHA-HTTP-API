#!/bin/bash

# install_docker.sh - A script to install Docker Engine on Debian-based systems

# Step 1: Update the apt package index
echo "Updating the apt package index..."
sudo apt update

# Step 2: Install prerequisite packages
echo "Installing prerequisite packages..."
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Step 3: Add Docker’s official GPG key
echo "Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Step 4: Set up the Docker repository
echo "Setting up the Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5: Update the package index again with the new repository
echo "Updating the apt package index with the new repository..."
sudo apt update

# Step 6: Install Docker Engine, containerd, and Docker Compose
echo "Installing Docker Engine, containerd, and Docker Compose..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 9: Enable and start Docker
echo "Enabling Docker to start on boot and starting the Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Check Docker service status
echo "Checking Docker service status..."
sudo systemctl status docker

# Completion message
echo "Docker installation completed successfully!"
