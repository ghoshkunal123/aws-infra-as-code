# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  codepipeline_name           = "${var.git_repo_full_name}"
  codedeploy_application_name = "analytics-${var.git_repo_alias}"
  stage_name_finr             = "Deploy-FINR-Account"             #TBD: if this name is changed, eLambdaExecutionFinrAdmin.json.tpl should be changed too.
  stage_name_test             = "Deploy-TEST-Account"
  stage_name_prod             = "Deploy-PROD-Account"
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
    name = "${local.stage_name_finr}"

    action {
      name            = "startEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StartEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      run_order = 1
    }

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

      run_order = 2
    }

    action {
      name            = "stopEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StopEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      run_order = 3
    }
  }

  stage {
    name = "${local.stage_name_test}"

    action {
      name            = "startEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StartEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      role_arn  = "${var.codedeploy_cross_account_test_arn_role}"
      run_order = 1
    }

    action {
      name            = "deploy-test-account"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        ApplicationName     = "${local.codedeploy_application_name}"
        DeploymentGroupName = "${local.codedeploy_deployment_group_name}"
      }

      role_arn  = "${var.codedeploy_cross_account_test_arn_role}"
      run_order = 2
    }

    action {
      name            = "stopEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StopEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      role_arn  = "${var.codedeploy_cross_account_test_arn_role}"
      run_order = 3
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
    name = "${local.stage_name_prod}"

    action {
      name            = "startEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StartEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      role_arn  = "${var.codedeploy_cross_account_prod_arn_role}"
      run_order = 1
    }

    action {
      name            = "deploy-prod-account"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        ApplicationName     = "${local.codedeploy_application_name}"
        DeploymentGroupName = "${local.codedeploy_deployment_group_name}"
      }

      role_arn  = "${var.codedeploy_cross_account_prod_arn_role}"
      run_order = 2
    }

    action {
      name            = "stopEC2"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["deploy"]
      version         = "1"

      configuration {
        FunctionName   = "${var.lambda_operate_ec2_func_name}"
        UserParameters = "{     \"Operation\": \"StopEC2\",     \"TagKey\": \"Name\",     \"TagValue\": \"fngn-dataeng-airflow-worker*\" }"
      }

      role_arn  = "${var.codedeploy_cross_account_prod_arn_role}"
      run_order = 3
    }
  }
}
