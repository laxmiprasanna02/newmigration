#!/bin/bash
set -e

# Install Node.js
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

# Set AWS environment variables
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Navigate to the Terraform directory
# cd Terraform

# # Initialize Terraform
# terraform init -backend-config="bucket=eu-eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy

# # Apply Terraform changes
# terraform apply --auto-approve
