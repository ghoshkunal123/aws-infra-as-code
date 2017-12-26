aws_profile             = "default"
aws_region              = "us-west-1"

s3_bucket_name          = "lisahu-finr-dataeng"

vpc_id                  = "vpc-d671b7b3" 
subnet_private1_id      = "subnet-0fca106a"
subnet_private2_id      = "subnet-e206d3ba"
aws_security_group_sshonly_id =  "sg-bc7afbd9"
aws_security_group_Flower_Ports_id =  "sg-531dd835"
aws_security_group_Postgres_id =  "sg-0ffb0669"
aws_security_group_RabbitMQ_id =  "sg-14f90272"
aws_security_group_Airflow_Ports_id =  "sg-add1c8ca"
aws_security_group_http_https_id = "sg-6a01f30d"
iam_instance_profile  = "iAirFlowDev" 

tag_app             = "de"
tag_Project         = "ANLY-2018"
tag_Owner           = "feidataengineering@financialengines.com"
tag_CostCenter      = "270"
tag_env             = "perf"
rds_tag_Name            = "rds-airflow"
rs_tag_Name            = "finr-dw-perf"
ec2_master_tag_Name = "tf-airflow-master"
ec2_agent_tag_Name = "tf-airflow-agent"
ec2_tag_patch_group = "ANLY-2717-Ubuntu"

# ec2 setting
ec2_key_name                = "lisahu_ec2_key"
#ec2_instance_type       = "m4.large"
ec2_instance_type       = "t2.micro"
ec2_ami                 = "ami-45ead225"
ec2_private_key_name    = "/Users/lhu/Documents/projects/aws_key_credential/lisahu_ec2_key.pem" 
ec2_user                = "etluser"

gitlab_private_token    = "/Users/lhu/Documents/projects/aws_key_credential/lhu_gitlab_private_token.txt" #I created it in gitlab and c&p here
# rds setting
rds_identifier          = "tf-perf-rds"
rds_vpc_security_group_id  = "sg-9f5399f9"
db_subnet_group_name    = "default-vpc-d671b7b3"
db_instance_class       = "db.t2.large"
dbname                  = "airflow"
dbuser                  = "etluser"
dbpassword              = "Welcome123"

# redshif setting
rs_cluster_name         = "tf-perf-cluster"
rs_db_name              = "analytics"
rs_master_user          = "etluser"
rs_master_password      = "Welcome123"
rs_node_type            = "ds2.xlarge"
rs_cluster_type         = "multi-node"
rs_number_of_nodes      = 4
rs_vpc_security_group_id  = "sg-6b09d00c"
rs_iam_role            = "arn:aws:iam::224919220385:role/eRedshiftFinrAdmin"

#rabbitmq setting
rabbitmq_user           = "etluser"
rabbitmq_password       = "Welcome123"

#elb
alb_airflow_name        = "tf2-airflow-alb"
targetgroup_airflow_name        = "tf2-airflow-tg"
alb_flower_name        = "tf2-flower-alb"
targetgroup_flower_name        = "tf2-flower-tg"
#route 53
domain_name             = "fefinr.io"

elb_healthy_threshold   = "5"
elb_unhealthy_threshold = "2"
elb_timeout             = "5"
elb_interval            = "30"

route53_hosted_zone_id = "Z308WL0Y3G1YGT"
route53_flower_domain_name = "tf-flower"
route53_airflow_domain_name = "tf-airflow"
