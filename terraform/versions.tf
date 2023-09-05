terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4, < 5"
      region  = "us-east-1"
    }
  }
  required_version = ">= 0.13, < 0.14"
}