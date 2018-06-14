# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

resource "aws_sns_topic" "lambda_monitor_dataeng_failure" {
  count = "${lookup(var.enable_monitor_dataeng, terraform.workspace)}"
  name  = "${var.lambda_monitor_dataeng_failure_sns_topic_name}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.lambda_monitor_dataeng_failure_sns_subscription_endpoint}"
  }
}
