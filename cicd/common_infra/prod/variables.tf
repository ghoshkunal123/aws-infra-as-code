# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

variable "git_repo_full_name" {}
variable "git_repo_alias" {}

variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {
  default = "default"
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

variable "lambda_operate_ec2_file_name" {
  default = "codepipeline_operate_ec2"
}

variable "lambda_operate_ec2_func_name" {
  default = "fngn-analytics-finr-codepipeline-operate-EC2"
}
