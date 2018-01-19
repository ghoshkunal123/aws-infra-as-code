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
  #  id = "${lookup(var.vpc_id, terraform.workspace)}"
  #to be mapped with workspace
  name = "iAirFlowDev"
}

output "iam_arn" {
  value = "${data.aws_iam_role.airflow.arn}"
}
