#!/bin/bash

# Ensure curl and lsb-release are installed
sudo apt update

# Install required packages (including build-essential)
sudo apt install -y curl lsb-release dos2unix nodejs npm build-essential

# Install NVM (if not already installed)
if ! command -v nvm &> /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  source ~/.bashrc
fi

# Install Node.js 18 (using nvm)
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
sudo apt update

sudo apt install -y terraform

# Set environmental variables for AWS and Terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev

# Initialize and apply Terraform configuration (adjust the path if needed)
# cd Terraform
# terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend" -force-copy
# terraform apply --auto-approve
