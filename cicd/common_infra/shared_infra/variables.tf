# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

variable "git_repo_full_name" {}

variable "git_repo_alias" {}

variable "allowed_account_id" {}

variable "account_alias" {}

variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {
  default = "default"
}

#tags
variable "tag_app" {
  default = "de"
}

variable "tag_Project" {
  default = "ANLY-2018"
}

variable "tag_Owner" {
  default = "feidataengineering@financialengines.com"
}

variable "tag_CostCenter" {
  default = "270"
}

variable "tag_office" {
  default = "analytics"
}

#codedeploy
variable "codedeploy_service_role" {
  default = "AWSCodeDeployServiceRole"
}

variable "codedeploy_deployment_group_tagkey" {
  default = "CodeDeploy"
}

variable "codedeploy_trigger_name" {
  default = "codedeploy-failure"
}

variable "codedeploy_failure_sns_subscription_endpoint" {}

# lambda
variable "lambda_operate_ec2_file_name" {
  default = "codepipeline_operate_ec2"
}

variable "lambda_operate_ec2_func_name" {
  default = "fngn-analytics-finr-codepipeline-operate-EC2"
}

variable "invoked_lambda_role_arn" {
  type = "map"

  default = {
    finr = "arn:aws:iam::224919220385:role/eLambdaExecutionFinrAdmin"
    test = "arn:aws:iam::483936848441:role/eLambdaExecutionAnalyticsFinr"
    prod = "arn:aws:iam::584917584607:role/eLambdaExecutionAnalyticsFinr"
  }
}
