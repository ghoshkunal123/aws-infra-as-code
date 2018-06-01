# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  codedeploy_deployment_group_tagvalue = "${var.git_repo_full_name}"
  codedeploy_deployment_group_name     = "${var.git_repo_alias}"
}

resource "aws_codedeploy_app" "finr" {
  name = "${local.codedeploy_application_name}"
}

resource "aws_codedeploy_deployment_group" "finr" {
  app_name               = "${aws_codedeploy_app.finr.name}"
  deployment_group_name  = "${local.codedeploy_deployment_group_name}"
  service_role_arn       = "${data.aws_iam_role.codedeploy_service_role.arn}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_filter = {
    key   = "${var.codedeploy_deployment_group_tagkey}"
    type  = "KEY_AND_VALUE"
    value = "${local.codedeploy_deployment_group_tagvalue}"
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "${var.codedeploy_trigger_name}"
    trigger_target_arn = "${aws_sns_topic.codedeploy_failure.arn}"
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true

    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}
