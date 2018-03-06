#network like vpc. subnet, cidr, etc. "you need to configure your own network
vpc_id = {
        finr  = "vpc-d671b7b3"
        dev   = "you need to set"
        test = "vpc-56bf7531"
        prod = "you need to set"
}
route53_domain_name = {
       finr = "fefinr.io."
       dev = "you need to set"
       test = "feitest.io."
       prod = "you need to set"
}
subnet_private1_id      = {
        finr  = "subnet-0fca106a"
        dev  = "you need to set"
        test = "subnet-6ffc4334"
        prod = "you need to set"
}
subnet_private2_id      = {
        finr  = "subnet-e206d3ba"
        dev  = "you need to set"
        test = "subnet-28630e4f"
        prod = "you need to set"
}

# here I map dev/test/prod to DEV/TST/PRD, because in de-datapipeline->Airflow->env.properties, DEV/TST/PRD is used instead of dev/test/prod
airflow_env_properties = {
       #temprary map finr to "DEV" will change after ANLY-3011 is completed.
       finr = "DEV"
       dev = "DEV"
       test = "TST"
       prod = "PRD"
}
# pls set your own ec2 key pair
ec2_key_name = {
       finr = "finr_devops_keypair"
       dev = "you need to set"
       test = "analytics-test-devops-keypair"
       prod = "you need to set"
}

ec2_instance_type = {
       finr = "m4.large"
       dev = "you need to set"
       test = "m4.large"
       prod = "you need to set"
}

ec2_worker_count = {
       finr = "2"
       dev = "you need to set"
       test = "2"
       prod = "2"
}

# ec2 iam role
iam_instance_profile  =  {
       finr = "iAirFlowDev"
       dev = "you need to set"
       test = "iAirflowAnalyticsFinr"
       prod = "you need to set"
}

# redshift iam role
rs_iam_role      = {
       finr = "eRedshiftFinrAdmin"
       dev = "you need to set"
       test = "eRedshiftAnalyticsFinr"
       prod = "you need to set"
}
rs_number_of_nodes = {
       finr = "6"
       dev = "you need to set"
       test = "2"
       prod = "8"
}
# AMI used by EC2
ec2_ami  = {
       finr = "ami-e3797b83" #this is an encrypted AMI created by @lhu based on public unencrypted ubuntu 16.4 AMI"
       dev = "you need to create/use an encrypted AMI baked from ubuntu 16.4"
       test = "ami-02306362" #this is an encrypted AMI created by @dchou based on public unencrypted ubuntu 16.4 AMI"
       prod = "you need to create/use an encrypted AMI baked from ubuntu 16.4"
}

# This is the S3 bucket to store data engineering airflow data and used by redshift
s3_bucket_name = {
# cannot create an s3 called com-fngn-finr-dataeng because it has already existed.
# so I name this s3 as com-fngn-finr-de
       finr = "com-fngn-finr-de"
       dev = "com-fngn-dev-dataeng"
       test = "com-fngn-test-dataeng"
       prod = "com-fngn-prod-dataeng"
}

alb_airflow_certificate_arn = {
       finr = "arn:aws:acm:us-west-1:224919220385:certificate/251d7808-1377-43f5-8081-17a37dea6f93"
       dev = "you need to set"
       test = "arn:aws:acm:us-west-1:483936848441:certificate/302ba21b-0bfe-4753-b3c6-9beeccfb0738"
       prod = "you need to set"
}

alb_flower_certificate_arn = {
       finr = "arn:aws:acm:us-west-1:224919220385:certificate/c50c6cb9-432c-4e69-9541-5b9452fa310b"
       dev = "you need to set"
       test = "arn:aws:acm:us-west-1:483936848441:certificate/728e666f-296a-4343-a9dc-4581d34935d1"
       prod = "you need to set"
}
lambda_role = {
       finr = "arn:aws:iam::224919220385:role/eLambdaExecutionFinrAdmin"
       dev = "you need to set"
       test = "arn:aws:iam::483936848441:role/eLambdaExecutionAnalyticsFinr"
       prod = "you need to set"
}
on-promise_mssqldb_ip = {
       finr = "10.80.0.65" # I do not know what to set here. They will not test it in FINR
       dev = "you need to set"
       test = "10.80.0.65"
       prod = "10.80.0.100"
}

on-promise_mssqlauxdb_ip = {
       finr = "10.80.0.65" # I do not know what to set here. They will not test it in FINR
       dev = "you need to set"
       test = "10.80.0.46"
       prod = "10.80.0.52"
}

mssql_aux_db = {
       finr = "prodcopy_corp_aux"
       dev = "you need to set"
       test = "aux"
       prod = "aux"
}
mssql_adv_db = {
       finr = "prodcopy2"
       dev = "you need to set"
       test = "feitest_copy"
       prod = "stage_advisor"
}
#passed to ansible
cron_schedule = {
       finr = "00 08 * * *"
       dev = "you need to set"
       test = "00 06 * * *"
       prod = "00 02 * * *"
}

lambda_start_ec2_time = {
       finr = "16" #start at 16 UTC = 8AM PST
       dev = "you need to set"
       test = "16"
       prod = "you need to set"
}

lambda_stop_ec2_time = {
       finr = "4" #stop at 4 UTC= 8PM PST
       dev = "you need to set"
       test = "4"
       prod = "you need to set"
}
