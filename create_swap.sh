#!/bin/bash

# Function to display and execute commands
execute() {
  echo "Executing: $1"
  eval "$1"
}

# STEP 1: Check if SWAP partition already exists
echo "STEP 1: Checking for existing SWAP partition..."
execute "sudo swapon --show"

# STEP 2: Show current partition structure
echo "STEP 2: Showing current partition structure..."
execute "df -h"

# STEP 3: Disable the use of swap
echo "STEP 3: Disabling current swap..."
execute "sudo swapoff -a"

# STEP 4: Create SWAP file (8GB in this example)
echo "STEP 4: Creating SWAP file..."
SWAP_SIZE="8G"
execute "sudo fallocate -l $SWAP_SIZE /swapfile"
execute "ls -lh /swapfile"

# STEP 5: Give root-only permissions to the SWAP file
echo "STEP 5: Setting permissions for SWAP file..."
execute "sudo chmod 600 /swapfile"

# STEP 6: Mark the file as SWAP space
echo "STEP 6: Marking the file as SWAP space..."
execute "sudo mkswap /swapfile"

# STEP 7: Enable the SWAP
echo "STEP 7: Enabling the SWAP..."
execute "sudo swapon /swapfile"

# STEP 8: Check if SWAP is created
echo "STEP 8: Checking if SWAP is created..."
execute "sudo swapon --show"

# STEP 9: Check the final partition structure
echo "STEP 9: Showing final partition structure..."
execute "free -h"

# STEP 10: Set the SWAP file as permanent
echo "STEP 10: Making SWAP permanent..."
execute "sudo cp /etc/fstab /etc/fstab.bak"
execute "echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab"

# Adjusting swappiness and cache pressure
echo "Adjusting swappiness and cache pressure..."
execute "sudo sysctl vm.swappiness=10"
execute "sudo sysctl vm.vfs_cache_pressure=50"

# Persist settings in /etc/sysctl.conf
echo "Persisting swappiness and cache pressure settings..."
execute "sudo bash -c 'echo vm.swappiness=10 >> /etc/sysctl.conf'"
execute "sudo bash -c 'echo vm.vfs_cache_pressure=50 >> /etc/sysctl.conf'"

# Opening ports
echo "Opening ports 80, 443, and 3000..."
execute "sudo ufw allow 80/tcp"
execute "sudo ufw allow 443/tcp"
execute "sudo ufw allow 3000/tcp"

echo "Finished setting up SWAP and configuring firewall!"
