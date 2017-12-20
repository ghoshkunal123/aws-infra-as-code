variable "aws_region" {}
variable "aws_profile" {}

variable "s3_bucket_name" {}
variable "ec2_key_name" {}
variable "ec2_user" {}
variable "ec2_private_key_name" {}
variable "ec2_instance_type" {}
variable "ec2_ami" {}
variable "vpc_id" {}
variable "subnet_private1_id" {}
variable "subnet_private2_id" {}
variable "aws_security_group_sshonly_id" {}
variable "aws_security_group_Flower_Ports_id" {}
variable "aws_security_group_Postgres_id" {}
variable "aws_security_group_RabbitMQ_id" {}
variable "aws_security_group_Airflow_Ports_id" {}
variable "aws_security_group_http_https_id" {}
variable "iam_instance_profile" {}
variable "gitlab_private_token" {}

variable "rds_vpc_security_group_id" {}
variable "db_subnet_group_name" {}
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "rds_identifier" {}
variable "tag_app" {}
variable "tag_Project" {}
variable "tag_Owner" {}
variable "tag_CostCenter" {}
variable "tag_env" {}
variable "rds_tag_Name" {} 
variable "rs_tag_Name" {}
variable "ec2_master_tag_Name" {}
variable "ec2_agent1_tag_Name" {}
variable "ec2_agent2_tag_Name" {}
variable "ec2_tag_patch_group" {}

variable "rs_cluster_name" {}
variable "rs_db_name" {}
variable "rs_master_user" {}
variable "rs_master_password" {}
variable "rs_node_type" {}
variable "rs_cluster_type" {}
variable "rs_number_of_nodes" {}
variable "rs_iam_role" {}
variable "rs_vpc_security_group_id" {}

variable "rabbitmq_user" {}
variable "rabbitmq_password" {}

variable "elb_airflow_name" {}
variable "targetgroup_airflow_name" {}
variable "domain_name" {}

variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}
