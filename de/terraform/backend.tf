#use s3 to store remote state
terraform {
  required_version = "0.11.0"

  backend "s3" {
    bucket  = "fe-finr-devops-private"
    key     = "de/terraform/terraform.tfstate"
    region  = "us-west-1"
    encrypt = true

    dynamodb_table = "finr-devops-tfstate-locks"
  }
}
