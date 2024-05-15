#!/bin/bash
set -e

# System updates and installs
sudo apt-get update
sudo apt-get install -y curl software-properties-common

# Install and configure nvm and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 18
nvm use 18

# Install npm dependencies
npm install
npm install ts-node --legacy-peer-deps

# Environment setup for Terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Navigate to Terraform directory and execute Terraform
cd Terraform
terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
terraform apply --auto-approve
