#S3 code bucket
resource "aws_s3_bucket" "s3" {
  bucket = "${var.s3_bucket_name}"
  acl = "private"
  force_destroy = true
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm     = "AES256"
#      }
#    }
# }
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
  }
}
resource "aws_s3_bucket_policy" "s3" {
  bucket = "${aws_s3_bucket.s3.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "PutObjPolicy",
  "Statement": [
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
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
            "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
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
