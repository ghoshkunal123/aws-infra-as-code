# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  codepipeline_name = "${var.git_repo_full_name}"
}

resource "aws_codepipeline" "de" {
  name     = "${local.codepipeline_name}"
  role_arn = "${data.aws_iam_role.codepipeline_service_role.arn}"

  artifact_store {
    location = "${var.codepipeline_artifact_s3_bucket}"
    type     = "S3"

    encryption_key {
      id   = "${var.codepipeline_kms_arn}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["deploy"]

      configuration {
        S3Bucket             = "${var.git_to_s3_outputbucket}"
        S3ObjectKey          = "${var.codepipeline_s3_objectkey}"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Deploy-FINR-Account"

    action {
      name            = "deploy-finr-account"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        ApplicationName     = "${aws_codedeploy_app.finr.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.finr.deployment_group_name}"
      }
    }
  }

  stage {
    name = "Deploy-TEST-Account"

    action {
      name            = "deploy-test-account"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        ApplicationName     = "${var.codedeploy_test_application_name}"
        DeploymentGroupName = "${var.codedeploy_test_deployment_group_name}"
      }

      role_arn = "${var.codedeploy_cross_account_test_arn_role}"
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "Approval"
      owner    = "AWS"
      category = "Approval"
      provider = "Manual"
      version  = "1"

      configuration {
        NotificationArn    = "${aws_sns_topic.codepipeline_approval.arn}"
        CustomData         = "Please approve or reject to deply prod"
        ExternalEntityLink = "${var.codepipeline_approval_ext_link}"
      }
    }
  }

  stage {
    name = "Deploy-PROD-Account"

    action {
      name            = "deploy-prod-account"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        ApplicationName     = "TestApplication"         #TBD: placeholder for real codedeploy at prod account,n/a yet
        DeploymentGroupName = "TestDeploymentGroupName" #TBD: placeholder for real codedeploy at prod account,n/a yet
      }
    }
  }
}
