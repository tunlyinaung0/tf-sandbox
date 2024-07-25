terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.59.0"
    }
  }

  backend "s3" {
    bucket = "tf-sandbox-assignment"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = local.region
}