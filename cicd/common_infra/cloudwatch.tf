resource "aws_cloudwatch_event_rule" "trigger_codepipeline_de" {
  name        = "trigger-codepipeline-de"
  description = "Event to trigger codepipeline-de upon S3 change"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "resources": {
      "ARN": [
        "${var.cloudwatch_triggered_s3_object}"
      ]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = "${aws_cloudwatch_event_rule.trigger_codepipeline_de.name}"
  target_id = "trigger_codepipeline_de"
  arn       = "${aws_codepipeline.de.arn}"
  role_arn  = "arn:aws:iam::224919220385:role/service-role/eCloudwatchStartCodepipeline"
}
