terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  required_version = ">= 1.0.5"
}

provider "aws" {
  allowed_account_ids = ["355297850295"]
  region              = "eu-central-1"
}