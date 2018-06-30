# this file is to obtain more information from the existing resources
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"

  allowed_account_ids = [
    "483936848441",
  ]
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

data "aws_iam_role" "lambda_service_role" {
  name = "eLambdaExecutionAnalyticsFinr"
}

output "LambdaServiceRole_arn" {
  value = "${data.aws_iam_role.lambda_service_role.arn}"
}
