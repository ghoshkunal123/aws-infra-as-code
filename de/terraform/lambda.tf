resource "null_resource" "lambda" {
  triggers {
    # TBD: do not know what to trigger run again
    template_rendered = "${ data.template_file.aws_hosts.rendered }"
  }

  # this local-exec creates *_upload.zip to be used by the below lambda resources.
  provisioner "local-exec" {
    command = "mkdir -p lambda_func && cd lambda_py && zip ../lambda_func/stop_ec2_upload.zip stop_ec2.py && cd .."
  }

  provisioner "local-exec" {
    command = "mkdir -p lamnda_func && cd lambda_py && zip ../lambda_func/start_ec2_upload.zip start_ec2.py && cd .."
  }
}

resource "aws_lambda_function" "stop_ec2" {
  depends_on       = ["null_resource.lambda"]
  function_name    = "fngn-analytics-dataeng-stopEC2"
  handler          = "stop_ec2.handler"
  runtime          = "python3.6"
  filename         = "lambda_func/stop_ec2_upload.zip"
  source_code_hash = "${base64sha256(file("lambda_func/stop_ec2_upload.zip"))}"
  role             = "${lookup(var.lambda_role, terraform.workspace)}"
}

resource "aws_lambda_function" "start_ec2" {
  function_name    = "fngn-analytics-dataeng-startEC2"
  handler          = "start_ec2.handler"
  runtime          = "python3.6"
  filename         = "lambda_func/start_ec2_upload.zip"
  source_code_hash = "${base64sha256(file("lambda_func/start_ec2_upload.zip"))}"
  role             = "${lookup(var.lambda_role, terraform.workspace)}"
}

resource "aws_cloudwatch_event_rule" "start_ec2_event" {
  name                = "fngn-analytics-dataeng-startEC2-event"
  description         = "startEC2 event"
  schedule_expression = "cron(30 7 ? * * *)"
}

resource "aws_cloudwatch_event_rule" "stop_ec2_event" {
  name                = "fngn-analytics-dataeng-stopEC2-event"
  description         = "stopEC2 event"
  schedule_expression = "cron(15 7 ? * * *)"
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
