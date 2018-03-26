variable "aws_region" {}
variable "aws_profile" {}

#network
variable "vpc_id" {
  type = "map"
}

variable "subnet_private1_id" {
  type = "map"
}

variable "subnet_private2_id" {
  type = "map"
}

variable "airflow_env_properties" {
  type = "map"
}

variable "finr_cidr_10" {} #ethernet subnet
variable "finr_cidr_172" {} #wireless subnet at sunnyvale
variable "finr_cidr_advisor_center_store" {}
variable "finr_cidr_172_phx" {} #wireless subnet at phoenix

#s3
variable "s3_bucket_name" {
  type = "map"
}

#ec2
variable "ec2_key_name" {
  type = "map"
}

variable "ec2_user" {}
variable "ec2_password" {}

variable "ec2_instance_type" {
  type = "map"
}

variable "ec2_worker_count" {
  type = "map"
}

variable "ec2_ami" {
  type = "map"
}

#iam
variable "iam_instance_profile" {
  type = "map"
}

#rds
variable "rds_instance_class" {}

variable "rds_identifier" {}
variable "rds_db_name" {}
variable "rds_user" {}
variable "rds_password" {}

#redshift
variable "rs_db_name" {}

variable "rs_cluster_identifier" {}
variable "rs_master_user" {}
variable "rs_master_password" {}
variable "rs_node_type" {}
variable "rs_cluster_type" {}

variable "rs_number_of_nodes" {
  type = "map"
}

variable "rs_subnet_group_name" {}
variable "rs_parameter_group_name" {}

variable "rs_iam_role" {
  type = "map"
}

variable "rs_pw" {} #ec2 etl_user need it to login as etl_user of Redshift, it is different from redshift master user

#rabbitmq
variable "rabbitmq_user" {}

variable "rabbitmq_password" {}

#alb
variable "alb_airflow_name" {}

variable "targetgroup_airflow_name" {}
variable "alb_flower_name" {}
variable "targetgroup_flower_name" {}

variable "alb_airflow_certificate_arn" {
  type = "map"
}

variable "alb_flower_certificate_arn" {
  type = "map"
}

variable "alb_healthy_threshold" {}
variable "alb_unhealthy_threshold" {}
variable "alb_timeout" {}
variable "alb_interval" {}

#route53
variable "route53_domain_name" {
  type = "map"
}

variable "route53_airflow_domain_name" {}
variable "route53_flower_domain_name" {}
variable "route53_mssqladvdb_domain_name" {}
variable "route53_mssqlauxdb_domain_name" {}

variable "on-promise_mssqladvdb_ip" {
  type = "map"
}

variable "on-promise_mssqlauxdb_ip" {
  type = "map"
}

#tags
variable "tag_app" {}

variable "tag_Project" {}
variable "tag_Owner" {}
variable "tag_CostCenter" {}
variable "tag_launcher" {} #whether the resource is launched by Terraform or console, etc.
variable "tag_office" {}
variable "rds_tag_Name" {}
variable "rs_tag_Name" {}
variable "ec2_master_tag_Name" {}
variable "ec2_worker_tag_Name" {}
variable "ec2_tag_patch_group" {}

#ansible
variable "ansible_airflow_cfg_vars_file" {}

variable "ansible_airflow_directory" {}

variable "lambda_role" {
  type = "map"
}

variable "mssql_aux_db" {
  type = "map"
}

variable "mssql_adv_db" {
  type = "map"
}

variable "cron_schedule" {
  type = "map"
}

variable "mssql_password" {}

variable "new_deployment" {
  default = "false"
}

variable "lambda_start_ec2_time" {
  type = "map"
}

variable "lambda_stop_ec2_time" {
  type = "map"
}

variable "email_dist_list" {
  type = "map"
}

variable "rds_multi_az" {
  type = "map"
}
