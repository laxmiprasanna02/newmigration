#!/bin/bash
set -e

# Prepare the system
sudo apt-get update
sudo apt-get install -y curl software-properties-common

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add HashiCorp repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update the system and install Terraform
sudo apt-get update
sudo apt-get install -y terraform

# Install Node.js using nvm for better version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Setup environment variables for Terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Assume the Terraform directory is correctly setup in the repository
cd Terraform
terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
terraform apply -auto-approve
