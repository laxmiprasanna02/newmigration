#!/bin/bash
set -eo pipefail

# Ensure curl and lsb-release are installed
sudo apt-get update
# sudo apt-get install -y curl lsb-release dos2unix nodejs npm build-essential

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Load NVM script into current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js 18
nvm install 18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Add HashiCorp GPG key for Terraform repository
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

# Update package lists again and install Terraform
sudo apt-get update
sudo apt-get install -y terraform

# Set environmental variables for AWS and Terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Initialize and apply Terraform configuration
# cd Terraform
# terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend" -force-copy
# terraform apply --auto-approve
