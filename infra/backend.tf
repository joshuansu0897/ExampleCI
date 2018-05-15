provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-joshua"
    key    = "exampleci/terraform.tfstate"
    region = "us-east-1"
  }
}
