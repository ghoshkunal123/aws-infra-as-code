# this file is to obtain more information from the existing resources
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Select a VPC to launch our instances into
data "aws_vpc" "vpc" {
  id = "${lookup(var.vpc_id, terraform.workspace)}"
}

output "vpc" {
  value = "${data.aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

# Route53
data "aws_route53_zone" "primary" {
  name = "${lookup(var.route53_domain_name, terraform.workspace)}"
}

output "route53_zone_id" {
  value = "${data.aws_route53_zone.primary.zone_id}"
}

#subnet - private 1
data "aws_subnet" "private1" {
  id = "${lookup(var.subnet_private1_id, terraform.workspace)}"
}

output "subnet_private1_cidr" {
  value = "${data.aws_subnet.private1.cidr_block}"
}

output "subnet_private1_az" {
  value = "${data.aws_subnet.private1.availability_zone}"
}

#subnet - private 2
data "aws_subnet" "private2" {
  id = "${lookup(var.subnet_private2_id, terraform.workspace)}"
}

output "subnet_private2_cidr" {
  value = "${data.aws_subnet.private2.cidr_block}"
}


output "subnet_private2_az" {
  value = "${data.aws_subnet.private2.availability_zone}"
}

# IAM used by airflow master and workers
data "aws_iam_role" "airflow" {
  name = "${lookup(var.iam_instance_profile, terraform.workspace)}"
}

output "iam_arn" {
  value = "${data.aws_iam_role.airflow.arn}"
}

data "aws_iam_role" "redshift" {
  name = "${lookup(var.rs_iam_role, terraform.workspace)}"
}

output "iam_redshift_arn" {
  value = "${data.aws_iam_role.redshift.arn}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

data "aws_sns_topic" "pageduty_low" {
  name = "${var.sns_pageduty_low_topic}"
}

output "aws_sns_arn_pageduty_low" {
  value = "${data.aws_sns_topic.pageduty_low.arn}"
}

data "aws_sns_topic" "pageduty_high" {
  name = "${var.sns_pageduty_high_topic}"
}

output "aws_sns_arn_pageduty_high" {
  value = "${data.aws_sns_topic.pageduty_high.arn}"
}
