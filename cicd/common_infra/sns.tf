# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  codepipeline_approval_sns_topic_name = "codepipeline-approval-${var.git_repo_alias}"
  codedeploy_failure_sns_topic_name    = "codedeploy-failure-${var.git_repo_alias}"
}

resource "aws_sns_topic" "codepipeline_approval" {
  name = "${local.codepipeline_approval_sns_topic_name}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.codepipeline_approval_sns_subscription_endpoint}"
  }
}

resource "aws_sns_topic" "codedeploy_failure" {
  name = "${local.codedeploy_failure_sns_topic_name}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.codedeploy_failure_sns_subscription_endpoint}"
  }
}
