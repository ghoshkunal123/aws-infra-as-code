aws_profile             = "default"
aws_region              = "us-west-1"

#network like vpc. subnet, cidr, etc. "you need to configure your own network
vpc_id = {
        dev  = "vpc-d671b7b3"
        test = "you need to set"
        prod = "you need to set"
}
subnet_private1_id      = {
        dev  = "subnet-0fca106a"
        test = "you need to set"
        prod = "you need to set"
}
subnet_private2_id      = {
        dev  = "subnet-e206d3ba"
        test = "you need to set"
        prod = "you need to set"
}
route53_hosted_zone_id = {
       dev = "Z308WL0Y3G1YGT"
       test = "you need to set"
       prod = "you need to set"
}
rds_subnet_group_name    = {
       dev = "default-vpc-d671b7b3"
       test = "you need to set"
       prod = "you need to set"
}
# here I map dev/test/prod to DEV/TST/PRD, because in de-datapipeline->Airflow->env.properties, DEV/TST/PRD is used instead of dev/test/prod
airflow_env_properties = {
       dev = "DEV"
       test = "TST"
       prod = "PRD"
}

finr_cidr_10  = "10.0.0.0/8"
finr_cidr_172  = "172.24.0.0/22"
finr_cidr_advisor_center_store = "172.21.0.0/16"

#ec2 key pair: you need to configure your own ec2 key pair
ec2_key_name                = "finr_devops_keypair"
ec2_private_key_name    = "/Users/lhu/Documents/projects/aws_key_credential/finr_devops_keypair.pem"

#ansible
ansible_airflow_directory = "../ansible"
ansible_airflow_cfg_vars_file = "group_vars/airflow_cfg_vars.yml"

#iam
iam_instance_profile  = "iAirFlowDev" 

# ec2
#ec2_instance_type       = "m4.large"
ec2_instance_type       = "t2.micro"
ec2_ami                 = "ami-e3797b83" #this is an encrypted AMI created by @lhu based on public unencrypted AMI
ec2_user                = "etluser"
ec2_worker_count  = "2"

# rds
rds_instance_class       = "db.t2.large"
rds_db_name                  = "airflow"
rds_user                  = "etluser"

# redshift
rs_db_name              = "analytics"
rs_master_user          = "admin"
rs_node_type            = "ds2.xlarge"
rs_cluster_type         = "multi-node"
rs_number_of_nodes      = 2
rs_iam_role            = "arn:aws:iam::224919220385:role/eRedshiftFinrAdmin"

#rabbitmq
rabbitmq_user           = "etluser"

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
route53_flower_domain_name = "tf-de-flower"
route53_airflow_domain_name = "tf-de-airflow"

#tags: TBD: not sure whether need these tags in test/prod env or not
tag_app             = "de"
tag_Project         = "ANLY-2018"
tag_Owner           = "feidataengineering@financialengines.com"
tag_CostCenter      = "270"
rds_tag_Name            = "tf-rds-airflow"
rs_tag_Name            = "tf-dw-airflow"
ec2_master_tag_Name = "tf-airflow-master"
ec2_worker_tag_Name = "tf-airflow-worker"
ec2_tag_patch_group = "ANLY-2717-Ubuntu"
