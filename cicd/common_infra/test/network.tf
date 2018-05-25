# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

# this file is to obtain more information from the existing resources
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

data "aws_iam_role" "codedeploy_service_role" {
  name = "AWSCodeDeployServiceRole"
}

output "AWSCodeDeployServiceRole_arn" {
  value = "${data.aws_iam_role.codedeploy_service_role.arn}"
}
