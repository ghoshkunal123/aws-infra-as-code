variable "aws_region" {}
variable "aws_profile" {}

#network: need to configure your own network
variable "vpc_id" {
  type = "map"
}

variable "subnet_private1_id" {
  type = "map"
}

variable "subnet_private2_id" {
  type = "map"
}

variable "route53_hosted_zone_id" {
  type = "map"
}

variable "rds_subnet_group_name" {
  type = "map"
}

variable "airflow_env_properties" {
  type = "map"
}

variable "finr_cidr_10" {}
variable "finr_cidr_172" {}
variable "finr_cidr_advisor_center_store" {}

#s3

#ec2: need to configure your own aws key pair
variable "ec2_key_name" {}

variable "ec2_private_key_name" {}

variable "ec2_user" {}
variable "ec2_password" {}
variable "ec2_instance_type" {}
variable "ec2_ami" {}
variable "ec2_worker_count" {}

#iam
variable "iam_instance_profile" {}

#rds
variable "rds_instance_class" {}

variable "rds_db_name" {}
variable "rds_user" {}
variable "rds_password" {}

#redshift

variable "rs_db_name" {}
variable "rs_master_user" {}
variable "rs_master_password" {}
variable "rs_node_type" {}
variable "rs_cluster_type" {}
variable "rs_number_of_nodes" {}
variable "rs_iam_role" {}

#rabbitmq
variable "rabbitmq_user" {}

variable "rabbitmq_password" {}

#alb
variable "alb_airflow_name" {}

variable "targetgroup_airflow_name" {}
variable "alb_flower_name" {}
variable "targetgroup_flower_name" {}

variable "alb_healthy_threshold" {}
variable "alb_unhealthy_threshold" {}
variable "alb_timeout" {}
variable "alb_interval" {}

#route53
variable "route53_airflow_domain_name" {}

variable "route53_flower_domain_name" {}

#tags
variable "tag_app" {}

variable "tag_Project" {}
variable "tag_Owner" {}
variable "tag_CostCenter" {}
variable "rds_tag_Name" {}
variable "rs_tag_Name" {}
variable "ec2_master_tag_Name" {}
variable "ec2_worker_tag_Name" {}
variable "ec2_tag_patch_group" {}

#ansible
variable "ansible_airflow_cfg_vars_file" {}

variable "ansible_airflow_directory" {}
