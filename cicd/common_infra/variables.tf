# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {
  default = "default"
}

variable "git_repo_full_name" {}
variable "git_repo_alias" {}

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

variable "codedeploy_test_application_name" {
  default = "analytics-airflow"
}

variable "codedeploy_test_deployment_group_name" {
  default = "airflow"
}

#codepipeline
variable "git_to_s3_outputbucket" {
  default = "git-to-amazon-s3-outputbucket-1xatxah3q3bzb"
}

variable "codepipeline_artifact_s3_bucket" {
  default = "awscodepipeline-us-west-1-finr"
}

variable "codepipeline_kms_arn" {
  default = "arn:aws:kms:us-west-1:866431598927:key/9194cc37-84ae-4d8d-9d7e-fc3970188e4f" #BISecrets KMS from core accunt
}

variable "codepipeline_s3_objectkey" {}

variable "codedeploy_cross_account_test_arn_role" {
  default = "arn:aws:iam::483936848441:role/eCodePipelineCrossAccountRole"
}

#sns
variable "codepipeline_approval_ext_link" {}

variable "codepipeline_approval_sns_subscription_endpoint" {}
variable "codedeploy_failure_sns_subscription_endpoint" {}

#cloudwatch
variable "cloudwatch_triggered_s3_object" {}
