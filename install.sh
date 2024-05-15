#!/bin/bash
set -e

# Convert line endings to Unix format
dos2unix "$0"

# Rest of your script
sudo apt-get update
sudo apt-get install -y nodejs npm

# Install build tools
sudo apt-get install -y build-essential

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js 18
nvm install 18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Terraform installation
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update https://apt.releases.hashicorp.com
sudo apt-get install -y terraform
