#!/bin/bash
# --------- this script has 9 argument:
# 1. airflow.cfg's fullpath
# 2. s3_bucket
# 3-5. rds_user, password, endpoint_host_name
# 6-9 rabbitmq_user, password, host, port
 
CONFIG=$1 #should be ~/airflow/airflow.cfg
function set_config(){ #Here I use # as delimitor
    sudo sed -i "s#^\($1\s*=\s*\).*\$#\1$2#" $CONFIG
}
#TBD: 
CONFIG=$1 #should be ~/airflow/airflow.cfg
s3_bucket=$2 #lisahu-finr-dataeng # $2
rds_user=$3 #etluser      # $3
rds_pw=$4 #Welcome123      # $4
rds_endpoint_host_name=$5 #tf-perf-rds.cszmnolqsfkv.us-west-1.rds.amazonaws.com # $5
rabbitmq_user=$6 #etluser     # $6
rabbitmq_pw=$7 #Welcome123     # $7
rabbitmq_host=$8 #my_ec2_host  # $8
rabbitmq_port=$9 #5672         # $9
rabbitmq_result_user=$rabbitmq_user
rabbitmq_result_pw=$rabbitmq_pw
rabbitmq_result_host=$rabbitmq_host
rabbitmq_result_port=$rabbitmq_port

set_config remote_base_log_folder s3://$s3_bucket/airflow/logs
set_config sql_alchemy_conn postgresql+psycopg2://$rds_user:$rds_pw@$rds_endpoint_host_name/airflow
set_config broker_url amqp://$rabbitmq_user:$rabbitmq_pw@$rabbitmq_host:$rabbitmq_port/
set_config celery_result_backend amqp://$rabbitmq_result_user:$rabbitmq_result_pw@$rabbitmq_result_host:$rabbitmq_result_port/
