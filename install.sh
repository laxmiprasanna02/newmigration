#!/bin/bash
set -e

sudo yum install nodejs -y
sudo yum install gcc -y  && sudo yum install gcc-c++ -y  && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source ~/.bashrc && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm install 18 && nvm use 18

npm install
npm install ts-node --legacy-peer-deps

# Terraform installation
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
# This script is to maintain AWS resources created by terraform
export AWS_REGION=eu-west-1
export AWS_PROFILE=dev
export TF_VAR_profile=dev
cd Terraform
terraform init -backend-config="bucket=eu-eu-west-1-dev-156696388136-terraform-state-backend-187" -force-copy
terraform apply --auto-approve
