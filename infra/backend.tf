# terraform {
#   backend "s3" {
#     bucket = "terraform-backend-joshua"
#     key    = "exampleci/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

terraform {
  required_version = ">= 0.11, < 0.12"

  backend "s3" {
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "terraform-backend-joshua-test"
    key                         = "exampleci/terraform.tfstate"
  }
}
