provider "aws" {
    region  = var.region
    profile = var.profile
}

terraform {
  backend "s3" {
    key             = "terraform"
    dynamodb_table  = "EU-dev-fluidra-terraform-lock-00"
    region          = "eu-west-1"
  }
}