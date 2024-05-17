#!/bin/bash
set -e  # Exit on error

# Update package lists
sudo apt update

# Install Node.js and development tools (gcc/g++)
sudo apt install -y nodejs gcc g++

# Install and configure nvm (Node Version Manager)
curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.39.1/install.sh | bash
source ~/.bashrc  # Reload bashrc to ensure nvm is loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Use backslash escape for source in this line
nvm install 18  # Install Node.js v18
nvm use 18

# Install npm packages
npm install
npm install ts-node --legacy-peer-deps

# Terraform installation via HashiCorp's official repository
sudo apt-get update && sudo apt-get install -y software-properties-common gnupg
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
sudo apt update
sudo apt install -y terraform

# Set environment variables for AWS and Terraform
export AWS_REGION="eu-west-1"
export AWS_PROFILE="dev"
export TF_VAR_profile="dev"

# Change directory to Terraform project (adjust directory as needed)
cd Terraform

# Terraform initialization and apply
# terraform init -backend-config="bucket=eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
# terraform apply --auto-approve
