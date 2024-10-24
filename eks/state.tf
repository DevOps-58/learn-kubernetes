provider "aws" {}

terraform {
  backend "s3" {
    bucket = "girisha-b58-tf-state"
    key    = "eks-b58/terraform.tfstate"
    region = "us-east-1"
  }
}