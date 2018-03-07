#S3 code bucket

resource "aws_s3_bucket" "s3" {
  bucket        = "${lookup(var.s3_bucket_name, terraform.workspace)}"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    id      = "expire_after_7d"
    enabled = true
    expiration {
      days = 7
    }
  }

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    launcher   = "${var.tag_launcher}"
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = "${aws_s3_bucket.s3.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PutObjPolicy",
  "Statement": [
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*",
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                }
            }
        }
  ]
}
POLICY
}

output "s3_bucket" {
  value = "${aws_s3_bucket.s3.bucket}"
}
