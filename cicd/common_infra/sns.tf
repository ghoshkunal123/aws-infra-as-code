# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  codepipeline_approval_sns_topic_name = "analytics-codepipeline-approval-${var.git_repo_alias}"
  codedeploy_failure_sns_topic_name    = "analytics-codedeploy-failure-${var.git_repo_alias}"
}

resource "aws_sns_topic" "codepipeline_approval" {
  name = "${local.codepipeline_approval_sns_topic_name}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.codepipeline_approval_sns_subscription_endpoint1}"
  }

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.codepipeline_approval_sns_subscription_endpoint2}"
  }
}
