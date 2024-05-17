#!/bin/bash
set -e  # Exit on first error

# Install Node.js and development tools (gcc/g++)
sudo apt update  # Update package lists
sudo apt install -y nodejs gcc g++

# Install and configure nvm (Node Version Manager)
curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Use backslash escape for source in this line
nvm install 18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Install Terraform (using HashiCorp repository)
sudo apt update  # Update package lists
sudo apt install -y terraform

# Set environment variables for AWS and Terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Change directory to Terraform project (adjust if needed)
cd Terraform

# Terraform commands (replace with your specific commands)
terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
terraform apply --auto-approve
