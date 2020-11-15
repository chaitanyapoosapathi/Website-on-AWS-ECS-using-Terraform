terraform {
  backend "s3" {
    bucket         = "bucket"
    key            = "bucket.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    dynamodb_table = "-tf-state-lock"
  }
}

provider "aws" {
  region = "ca-central-1"
  version = "~> 3.0"
}


locals {
  prefix = "northone"
  common_tags = {
    Project     = "northone-test"
    Owner       = "chaitanya"
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
