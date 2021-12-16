terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::778097775924:role/system/ec2_contributors"
  }
}
