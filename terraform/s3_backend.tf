###############################################################################################################################
############S3-Backend-Terraform Statefile
###############################################################################################################################

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "insider-s3-terraform-backend-test"
    region  = "us-east-1"
    key     = "terraform-backend/terraform.tfstate"
  }
}
