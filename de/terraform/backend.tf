#use s3 to store remote state
terraform {
  backend "s3" {
    bucket = "lisahu_test_bucket"
    key    = "terraform/mac_machine/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
#   TBD: To be tested
#    dynamodb_table = "finr-de-tfstate-locks"
  }
}
