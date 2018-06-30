# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  src_dir  = "lambda_py"
  dest_dir = "lambda_func"
}

# the following lambda is to start/stop ec2, invoked by codepipeline
data "archive_file" "operate_ec2" {
  type        = "zip"
  source_file = "${path.module}/${local.src_dir}/${var.lambda_operate_ec2_file_name}.py"
  output_path = "${path.module}/${local.dest_dir}/${var.lambda_operate_ec2_file_name}_upload.zip"
}

resource "aws_lambda_function" "codepipeline" {
  function_name    = "${var.lambda_operate_ec2_func_name}"
  handler          = "${var.lambda_operate_ec2_file_name}.lambda_handler"
  runtime          = "python3.6"
  filename         = "${data.archive_file.operate_ec2.output_path}"
  source_code_hash = "${data.archive_file.operate_ec2.output_base64sha256}"
  role             = "${data.aws_iam_role.lambda_service_role.arn}"
  timeout          = 300

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    office     = "${var.tag_office}"
  }
}

resource "aws_lambda_permission" "allow_codepipeline_to_call_lambda" {
  statement_id  = "AllowExecutionFromCodepipeline"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.codepipeline.function_name}"
  principal     = "codepipeline.amazonaws.com"
}

# the following lambda is to disable/enable codepipeline, triggered by cloudwatch schedule
data "archive_file" "operate_codepipeline" {
  type        = "zip"
  source_file = "${path.module}/${local.src_dir}/${var.lambda_operate_codepipeline_file_name}.py"
  output_path = "${path.module}/${local.dest_dir}/${var.lambda_operate_codepipeline_file_name}_upload.zip"
}

resource "aws_lambda_function" "operate_codepipeline" {
  function_name    = "${var.lambda_operate_codepipeline_func_name}"
  handler          = "${var.lambda_operate_codepipeline_file_name}.lambda_handler"
  runtime          = "python3.6"
  filename         = "${data.archive_file.operate_codepipeline.output_path}"
  source_code_hash = "${data.archive_file.operate_codepipeline.output_base64sha256}"
  role             = "${data.aws_iam_role.lambda_service_role.arn}"
  timeout          = 30

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    office     = "${var.tag_office}"
  }

  environment {
    variables = {
      pipeline_name   = "${local.codepipeline_name}"
      stage_name      = "${local.stage_name_finr}"
      transition_type = "Inbound"
    }
  }
}

resource "aws_cloudwatch_event_rule" "disable_codepipeline_event" {
  name                = "fngn-analytics-disable-codepipeline-event"
  description         = "disable codepipeline event"
  schedule_expression = "${var.lambda_disable_codepipeline_time}"
}

resource "aws_cloudwatch_event_target" "disable_codepipeline_event_lambda_target" {
  target_id = "disable_codepipeline_event_lambda_target"
  rule      = "${aws_cloudwatch_event_rule.disable_codepipeline_event.name}"
  arn       = "${aws_lambda_function.operate_codepipeline.arn}"

  input = <<EOF
{
  "operate": "Disable"
}
EOF
}

resource "aws_cloudwatch_event_rule" "enable_codepipeline_event" {
  name                = "fngn-analytics-enable-codepipeline-event"
  description         = "enable codepipeline event"
  schedule_expression = "${var.lambda_enable_codepipeline_time}"
}

resource "aws_cloudwatch_event_target" "enable_codepipeline_event_lambda_target" {
  target_id = "enable_codepipeline_event_lambda_target"
  rule      = "${aws_cloudwatch_event_rule.enable_codepipeline_event.name}"
  arn       = "${aws_lambda_function.operate_codepipeline.arn}"

  input = <<EOF
{
  "operate": "Enable"
}
EOF
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_enable_codepipeline" {
  statement_id  = "AllowExecutionFromCloudWatchEnableCP"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.operate_codepipeline.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.enable_codepipeline_event.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_disable_codepipeline" {
  statement_id  = "AllowExecutionFromCloudWatchDisableCP"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.operate_codepipeline.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.disable_codepipeline_event.arn}"
}
