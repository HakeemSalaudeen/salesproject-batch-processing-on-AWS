terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}
