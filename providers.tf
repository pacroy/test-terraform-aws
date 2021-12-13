terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "partfbackend"
    key    = "test-terraform-aws/terraform.tfstate"
  }
}

provider "aws" {}
