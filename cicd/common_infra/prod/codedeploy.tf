# Copyright 2018
# Author: Lisa Hu

locals {
  codedeploy_failure_sns_topic_name    = "analytics-failure-${var.git_repo_alias}"
  codedeploy_deployment_group_tagvalue = "${var.git_repo_full_name}"
  codedeploy_deployment_group_name     = "${var.git_repo_alias}"
  codedeploy_application_name          = "analytics-${var.git_repo_alias}"
}

resource "aws_codedeploy_app" "prod" {
  name = "${local.codedeploy_application_name}"
}

# create a deployment group
resource "aws_codedeploy_deployment_group" "prod" {
  app_name               = "${aws_codedeploy_app.prod.name}"
  deployment_group_name  = "${local.codedeploy_deployment_group_name}"
  service_role_arn       = "${data.aws_iam_role.codedeploy_service_role.arn}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_filter = {
    key   = "CodeDeploy"
    type  = "KEY_AND_VALUE"
    value = "${local.codedeploy_deployment_group_tagvalue}"
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "${var.codedeploy_trigger_name}"
    trigger_target_arn = "${aws_sns_topic.codedeploy_failure_prod.arn}"
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true

    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}

resource "aws_sns_topic" "codedeploy_failure_prod" {
  name = "${local.codedeploy_failure_sns_topic_name}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.codedeploy_failure_sns_subscription_endpoint}"
  }
}
