// AWS
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

// DigitalOcean
// terraform {
//   backend "s3" {
//     skip_requesting_account_id  = true
//     skip_credentials_validation = true
//     skip_get_ec2_platforms      = true
//     skip_metadata_api_check     = true
//     access_key                  = "XXXXXXXX"
//     secret_key                  = "XXXXXXXXXXXXXXXXX"
//     endpoint                    = "https://xxx.digitaloceanspaces.com"
//     region                      = "us-east-1"
//     bucket                      = "<name-space>"
//     key                         = "path/terraform.tfstate"
//   }
// }
