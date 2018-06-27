# this file is to obtain more information from the existing resources
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"

  allowed_account_ids = [
    "584917584607",
  ]
}

# Select a VPC to launch our instances into
data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

output "vpc" {
  value = "${data.aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

#subnet - private 1
data "aws_subnet" "private1" {
  id = "${var.subnet_private1_id}"
}

output "subnet_private1_cidr" {
  value = "${data.aws_subnet.private1.cidr_block}"
}

output "subnet_private1_az" {
  value = "${data.aws_subnet.private1.availability_zone}"
}

# IAM used by rstudio ec2
data "aws_iam_role" "rstudio" {
  name = "${var.iam_instance_profile}"
}

output "iam_arn" {
  value = "${data.aws_iam_role.rstudio.arn}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}
