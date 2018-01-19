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
