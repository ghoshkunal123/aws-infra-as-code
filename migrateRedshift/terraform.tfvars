aws_profile             = "default"
aws_region              = "us-west-1"

#network like vpc. subnet, cidr, etc. you need to configure your own network
vpc_id                  = "vpc-d671b7b3" 
subnet_private1_id      = "subnet-0fca106a"
subnet_private2_id      = "subnet-e206d3ba"
finr_cidr_10  = "10.0.0.0/8"
finr_cidr_172  = "172.24.0.0/22"
route53_hosted_zone_id = "Z308WL0Y3G1YGT"

#ec2 key pair: you need to configure your own ec2 key pair
ec2_key_name                = "lisahu_ec2_key"
ec2_private_key_name    = "/Users/lhu/Documents/projects/aws_key_credential/lisahu_ec2_key.pem" 

#s3
s3_bucket_name          = "lisahu-finr-dataeng"

#iam
iam_instance_profile  = "iAirFlowDev" 

# ec2
#ec2_instance_type       = "m4.large"
ec2_instance_type       = "t2.micro"
ec2_ami                 = "ami-45ead225"
ec2_user                = "etluser"
ec2_worker_count  = "2"

# rds
rds_identifier          = "tf-perf-rds"
rds_vpc_security_group_id  = "sg-9f5399f9"
rds_subnet_group_name    = "default-vpc-d671b7b3"
rds_instance_class       = "db.t2.large"
rds_name                  = "airflow"
rds_user                  = "etluser"
rds_password              = "Welcome123"

# redshift
rs_cluster_name         = "tf-perf-cluster"
rs_db_name              = "analytics"
rs_master_user          = "etluser"
rs_master_password      = "Welcome123"
rs_node_type            = "ds2.xlarge"
rs_cluster_type         = "multi-node"
rs_number_of_nodes      = 4
rs_vpc_security_group_id  = "sg-6b09d00c"
rs_iam_role            = "arn:aws:iam::224919220385:role/eRedshiftFinrAdmin"

#rabbitmq
rabbitmq_user           = "etluser"
rabbitmq_password       = "Welcome123"

#alb
alb_airflow_name        = "tf-airflow-alb"
targetgroup_airflow_name        = "tf-airflow-tg"
alb_flower_name        = "tf-flower-alb"
targetgroup_flower_name        = "tf-flower-tg"
alb_healthy_threshold   = "5"
alb_unhealthy_threshold = "2"
alb_timeout             = "5"
alb_interval            = "30"

#route53
route53_flower_domain_name = "tf-flower"
route53_airflow_domain_name = "tf-airflow"

#tags
tag_app             = "de"
tag_Project         = "ANLY-2018"
tag_Owner           = "feidataengineering@financialengines.com"
tag_CostCenter      = "270"
tag_env             = "perf"
rds_tag_Name            = "rds-airflow"
rs_tag_Name            = "finr-dw-perf"
ec2_master_tag_Name = "tf-airflow-master"
ec2_worker_tag_Name = "tf-airflow-worker"
ec2_tag_patch_group = "ANLY-2717-Ubuntu"

#ansible
ansible_airflow_directory = "/Users/lhu/Documents/source_code/ansible/"
ansible_airflow_cfg_vars_file = "vars/airflow_cfg_vars.yml"
