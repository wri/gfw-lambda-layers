terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      region  = "us-east-1"
      version = ">= 3, < 4"
    }
  }
  required_version = ">= 0.13"
}
