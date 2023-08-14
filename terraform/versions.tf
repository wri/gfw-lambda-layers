terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4, < 5"
    }
  }
  required_version = ">= 0.13, < 0.14"
}
provider "aws" {
  region  = "us-east-1"
}