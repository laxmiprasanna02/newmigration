#!/bin/bash
set -e

# Install Node.js
sudo yum install nodejs -y

# Install build tools
sudo yum install -y gcc gcc-c++

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
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Set AWS environment variables
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Navigate to Terraform directory
# cd Terraform

# # Initialize Terraform
# terraform init -backend-config="bucket=eu-eu-west-1-dev-156696388136-terraform-state-backend-187" -reconfigure

# # Apply Terraform changes
# terraform apply --auto-approve
