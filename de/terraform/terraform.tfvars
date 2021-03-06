aws_profile             = "default"
aws_region              = "us-west-1"

finr_cidr_10  = "10.0.0.0/8"
finr_cidr_172  = "172.24.0.0/22"
finr_cidr_advisor_center_store = "172.21.0.0/16"
finr_cidr_172_fe = "172.16.0.0/12"
finr_cidr_192 = "192.168.0.0/16"

#ansible
ansible_airflow_directory = "../ansible"
ansible_airflow_cfg_vars_file = "group_vars/airflow_cfg_vars.yml"

# ec2
ec2_user                = "etluser"

# rds
rds_identifier           = "fngn-dataeng-airflow"
rds_instance_class       = "db.t2.large"
rds_db_name                  = "airflow"
rds_user                  = "etluser"

# redshift
rs_cluster_identifier   = "fngn-dataeng-edw"
rs_db_name              = "analytics"
rs_master_user          = "admin"
rs_node_type            = "ds2.xlarge"
rs_cluster_type         = "multi-node"
rs_subnet_group_name   = "fngn-dataeng-redshift-sn-private1"
rs_parameter_group_name  = "analytics-finr-redshift-parameter-group"

#rabbitmq
rabbitmq_user           = "etluser"

#alb
alb_airflow_name        = "fngn-dataeng-airflow-alb"
targetgroup_airflow_name        = "fngn-dataeng-airflow-tg"
alb_flower_name        = "fngn-dataeng-flower-alb"
targetgroup_flower_name        = "fngn-dataeng-flower-tg"

alb_healthy_threshold   = "5"
alb_unhealthy_threshold = "2"
alb_timeout             = "5"
alb_interval            = "30"

#route53
route53_flower_domain_name = "flower"
route53_airflow_domain_name = "airflow"
route53_mssqladvdb_domain_name = "mssqladvdb-dataeng"
route53_mssqlauxdb_domain_name = "mssqlauxdb-dataeng"

tag_app             = "de"
tag_Project         = "ANLY-2018"
tag_Owner           = "feidataengineering@financialengines.com"
tag_CostCenter      = "270"
tag_launcher       = "Terraform-ANLY-2820"
tag_office          = "analytics"

rds_tag_Name            = "fngn-dataeng-airflow"
rs_tag_Name            = "fngn-dataeng-redshift"
ec2_master_tag_Name = "fngn-dataeng-airflow-master"
ec2_worker_tag_Name = "fngn-dataeng-airflow-worker"
ec2_tag_patch_group = "ANLY-2717-Ubuntu"
ec2_tag_codedeploy = "de-datapipeline"

#lambda
lambda_monitor_dataeng_time = "cron(6 00 ? * * *)" #11:00PM PST DST = 6:00AM UTC

#sns
lambda_monitor_dataeng_failure_sns_topic_name = "analytics-monitor-dataeng-failure"
lambda_monitor_dataeng_failure_sns_subscription_endpoint = "lhu@FinancialEngines.com"
