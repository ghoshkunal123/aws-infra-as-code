#use s3 to store remote state
terraform {
  backend "s3" {
    bucket = "lisahu_test_bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
