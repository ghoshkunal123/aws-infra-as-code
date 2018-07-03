# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

locals {
  src_dir  = "lambda_py"
  dest_dir = "lambda_func/${var.account_alias}"
}

# the following lambda is to start/stop ec2, invoked by codepipeline
data "archive_file" "operate_ec2" {
  type        = "zip"
  source_file = "${path.module}/${local.src_dir}/${var.lambda_operate_ec2_file_name}.py"
  output_path = "${path.module}/${local.dest_dir}/${var.lambda_operate_ec2_file_name}_upload.zip"
}

resource "aws_lambda_function" "codepipeline_invoked" {
  function_name    = "${var.lambda_operate_ec2_func_name}"
  handler          = "${var.lambda_operate_ec2_file_name}.lambda_handler"
  runtime          = "python3.6"
  filename         = "${data.archive_file.operate_ec2.output_path}"
  source_code_hash = "${data.archive_file.operate_ec2.output_base64sha256}"
  role             = "${lookup(var.invoked_lambda_role_arn, var.account_alias)}"
  timeout          = 120

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    office     = "${var.tag_office}"
  }

  environment {
    variables = {
      account_alias = "${var.account_alias}"
    }
  }
}

resource "aws_lambda_permission" "allow_codepipeline_to_call_lambda" {
  statement_id  = "AllowExecutionFromCodepipeline"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.codepipeline_invoked.function_name}"
  principal     = "codepipeline.amazonaws.com"
}
