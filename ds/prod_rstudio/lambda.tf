locals {
  src_dir         = "lambda_py"
  dest_dir        = "lambda_func"
  lambda_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.lambda_role_name}"
}

data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "${local.src_dir}/start_ec2.py"
  output_path = "${local.dest_dir}/start_ec2_upload.zip"
}

data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "${local.src_dir}/stop_ec2.py"
  output_path = "${local.dest_dir}/stop_ec2_upload.zip"
}

resource "aws_lambda_function" "start_ec2" {
  function_name    = "fngn-analytics-finr-rstudio-startEC2"
  handler          = "start_ec2.handler"
  runtime          = "python3.6"
  filename         = "${local.dest_dir}/start_ec2_upload.zip"
  source_code_hash = "${data.archive_file.start_ec2.output_base64sha256}"
  role             = "${local.lambda_role_arn}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
  }

  environment {
    variables = {
      ec2_tag_Name = "${var.tag_ec2_Name}"
    }
  }
}

resource "aws_lambda_function" "stop_ec2" {
  function_name    = "fngn-analytics-finr-rstudio-stopEC2"
  handler          = "stop_ec2.handler"
  runtime          = "python3.6"
  filename         = "${local.dest_dir}/stop_ec2_upload.zip"
  source_code_hash = "${data.archive_file.stop_ec2.output_base64sha256}"
  role             = "${local.lambda_role_arn}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
  }

  environment {
    variables = {
      ec2_tag_Name = "${var.tag_ec2_Name}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "start_ec2_event" {
  name                = "fngn-analytics-rstudio-startEC2-event"
  description         = "startEC2 event"
  schedule_expression = "${var.lambda_start_ec2_time}"
}

resource "aws_cloudwatch_event_rule" "stop_ec2_event" {
  name                = "fngn-analytics-rstudio-stopEC2-event"
  description         = "stopEC2 event"
  schedule_expression = "${var.lambda_stop_ec2_time}"
}

resource "aws_cloudwatch_event_target" "stop_ec2_event_lambda_target" {
  target_id = "stop_ec2_event_lambda_target"
  rule      = "${aws_cloudwatch_event_rule.stop_ec2_event.name}"
  arn       = "${aws_lambda_function.stop_ec2.arn}"

  input = <<EOF
{
  "instanceid": "all"
}
EOF
}

resource "aws_cloudwatch_event_target" "start_ec2_event_lambda_target" {
  target_id = "start_ec2_event_lambda_target"
  rule      = "${aws_cloudwatch_event_rule.start_ec2_event.name}"
  arn       = "${aws_lambda_function.start_ec2.arn}"

  input = <<EOF
{
  "instanceid": "all"
}
EOF
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_start_ec2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.start_ec2.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.start_ec2_event.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_stop_ec2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.stop_ec2.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.stop_ec2_event.arn}"
}
