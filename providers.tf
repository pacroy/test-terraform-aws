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
  alias = "ec2_contributors"
  assume_role {
    role_arn     = "arn:aws:iam::778097775924:role/system/ec2_contributors"
  }
}

provider "aws" {
  alias = "s3_contributors"
  assume_role {
    role_arn     = "arn:aws:iam::778097775924:role/system/s3_contributors"
  }
}
