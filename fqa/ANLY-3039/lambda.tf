locals {
  src_dir  = "lambda_py"
  dest_dir = "lambda_func"
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
  function_name    = "fngn-analytics-fqa-startEC2"
  handler          = "start_ec2.handler"
  runtime          = "python3.6"
  filename         = "${local.dest_dir}/start_ec2_upload.zip"
  source_code_hash = "${data.archive_file.start_ec2.output_base64sha256}"
  role             = "${var.lambda_role}"
  timeout          = 300
}

resource "aws_lambda_function" "stop_ec2" {
  function_name    = "fngn-analytics-fqa-stopEC2"
  handler          = "stop_ec2.handler"
  runtime          = "python3.6"
  filename         = "${local.dest_dir}/stop_ec2_upload.zip"
  source_code_hash = "${data.archive_file.stop_ec2.output_base64sha256}"
  role             = "${var.lambda_role}"
  timeout          = 300
}
