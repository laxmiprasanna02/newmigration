#!/bin/bash
set -e

# Update package sources
sudo apt-get update

# Install Node.js and build tools
sudo apt-get install -y nodejs npm build-essential

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Source nvm script to ensure it's available in this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use a specific version of Node.js
nvm install 18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y terraform

# Set environment variables for Terraform
export AWS_REGION="eu-west-1"
export AWS_PROFILE="dev"
export TF_VAR_profile="dev"

# Navigate to the Terraform directory and initialize and apply configuration
cd Terraform
terraform init -backend-config="bucket=eu-eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
terraform apply -auto-approve
