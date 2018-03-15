#network like vpc. subnet, cidr, etc. "you need to configure your own network
vpc_id = {
        finr  = "vpc-d671b7b3"
        dev   = "you need to set"
        test = "vpc-56bf7531"
        prod = "vpc-5057ea37"
}
route53_domain_name = {
       finr = "fefinr.io."
       dev = "you need to set"
       test = "feitest.io."
       prod = "financialengines.io."
}
subnet_private1_id      = {
        finr  = "subnet-0fca106a"
        dev  = "you need to set"
        test = "subnet-6ffc4334"
        prod = "subnet-12df9d75"
}
subnet_private2_id      = {
        finr  = "subnet-e206d3ba"
        dev  = "you need to set"
        test = "subnet-28630e4f"
        prod = "subnet-df6ef184"
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
       prod = "analytics-prod-devops-keypair"
}

ec2_instance_type = {
       finr = "m4.large"
       dev = "you need to set"
       test = "m4.large"
       prod = "m4.large"
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
       prod = "iAirflowAnalyticsFinr"
}

# redshift iam role
rs_iam_role      = {
       finr = "eRedshiftFinrAdmin"
       dev = "you need to set"
       test = "eRedshiftAnalyticsFinr"
       prod = "eRedshiftAnalyticsFinr"
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
       prod = "ami-eaeccd8a" #the description said it is gp2 encrypted, need to confirm with @dchou, need to test
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
       finr = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/251d7808-1377-43f5-8081-17a37dea6f93"
       dev = "you need to set"
       test = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/302ba21b-0bfe-4753-b3c6-9beeccfb0738"
       prod = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/4ce2e2fb-25ed-4e05-b0ef-eb9588c233d2"
}

alb_flower_certificate_arn = {
       finr = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/c50c6cb9-432c-4e69-9541-5b9452fa310b"
       dev = "you need to set"
       test = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/728e666f-296a-4343-a9dc-4581d34935d1"
       prod = "arn:aws:acm:us-west-1:${data.aws_caller_identity.current.account_id}:certificate/233f63d6-4d88-4038-975e-38ed28161b91"
}
lambda_role = {
       finr = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eLambdaExecutionFinrAdmin"
       dev = "you need to set"
       test = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eLambdaExecutionAnalyticsFinr"
       prod = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eLambdaExecutionAnalyticsFinr"
}
on-promise_mssqladvdb_ip = {
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
       finr = "15" #start at 15 UTC = 8AM PST DST time
       dev = "you need to set"
       test = "15"
       prod = "15"
}

lambda_stop_ec2_time = {
       finr = "3" #stop at 3 UTC= 8PM PST DST time
       dev = "you need to set"
       test = "3"
       prod = "3"
}

email_dist_list = {
      finr = "feidataengineering@financialengines.com"
      dev = "you need to set"
      test = "feidataengineering@financialengines.com"
      prod = "feidataengineering@financialengines.com, feidataengineering@fngn.pagerduty.com"
}
