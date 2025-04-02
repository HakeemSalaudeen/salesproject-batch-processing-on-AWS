# create terraform state file s3 bucket
terraform {
  backend "s3" {
    bucket = "statefile-backend-bucket"
    region = "eu-central-1"
    key    = "ty-salesproject/salesproject/terraform.tfstate"
  }
}