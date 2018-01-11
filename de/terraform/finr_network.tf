provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Select a VPC to launch our instances into
data "aws_vpc" "finr_vpc" {
  #    id = "vpc-d671b7b3"
  id = "${var.vpc_id}"
}

output "finr_vpc" {
  value = "${data.aws_vpc.finr_vpc.id}"
}

output "finr_vpc_cidr" {
  value = "${data.aws_vpc.finr_vpc.cidr_block}"
}

#subnet - public 
data "aws_subnet" "finr_public" {
  id = "subnet-36ca1053"
}

#subnet - private 1
data "aws_subnet" "finr_private1" {
  #    id = "subnet-0fca106a"
  id = "${var.subnet_private1_id}"
}

output "finr_subnet_private1_cidr" {
  value = "${data.aws_subnet.finr_private1.cidr_block}"
}

output "finr_subnet_private1_az" {
  value = "${data.aws_subnet.finr_private1.availability_zone}"
}

#subnet - private 2
data "aws_subnet" "finr_private2" {
  #    id = "subnet-e206d3ba"
  id = "${var.subnet_private2_id}"
}

output "finr_subnet_private2_cidr" {
  value = "${data.aws_subnet.finr_private2.cidr_block}"
}

output "finr_subnet_private2_az" {
  value = "${data.aws_subnet.finr_private2.availability_zone}"
}
