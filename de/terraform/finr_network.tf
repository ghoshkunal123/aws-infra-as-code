provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Select a VPC to launch our instances into
data "aws_vpc" "finr_vpc" {
  id = "${lookup(var.vpc_id, terraform.workspace)}"
}

output "finr_vpc" {
  value = "${data.aws_vpc.finr_vpc.id}"
}

output "finr_vpc_cidr" {
  value = "${data.aws_vpc.finr_vpc.cidr_block}"
}

#subnet - private 1
data "aws_subnet" "finr_private1" {
   id = "${lookup(var.subnet_private1_id, terraform.workspace)}"
}

output "finr_subnet_private1_cidr" {
  value = "${data.aws_subnet.finr_private1.cidr_block}"
}

output "finr_subnet_private1_az" {
  value = "${data.aws_subnet.finr_private1.availability_zone}"
}

#subnet - private 2
data "aws_subnet" "finr_private2" {
   id = "${lookup(var.subnet_private2_id, terraform.workspace)}"
}

output "finr_subnet_private2_cidr" {
  value = "${data.aws_subnet.finr_private2.cidr_block}"
}

output "finr_subnet_private2_az" {
  value = "${data.aws_subnet.finr_private2.availability_zone}"
}
