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

data "aws_iam_role" "codepipeline_service_role" {
  name = "eCodepipeline"
}

output "eCodepipeline_arn" {
  value = "${data.aws_iam_role.codepipeline_service_role.arn}"
}

output "eCodepipeline_path" {
  value = "${data.aws_iam_role.codepipeline_service_role.path}"
}

data "aws_iam_role" "codedeploy_service_role" {
  name = "AWSCodeDeployServiceRole"
}

output "AWSCodeDeployServiceRole_arn" {
  value = "${data.aws_iam_role.codedeploy_service_role.arn}"
}

data "aws_iam_role" "lambda_service_role" {
  name = "eLambdaExecutionFinrAdmin"
}

output "LambdaServiceRole_arn" {
  value = "${data.aws_iam_role.lambda_service_role.arn}"
}
