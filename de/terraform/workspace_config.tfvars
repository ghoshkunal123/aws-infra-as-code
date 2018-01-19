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
# pls set your own ec2 key pair
ec2_key_name = {
       dev = "finr_devops_keypair"
       test = "you need to set"
       prod = "you need to set"
}

# ec2 iam role
iam_instance_profile  =  {
       dev = "iAirFlowDev"
       test = "you need to set"
       prod = "you need to set"
}
# redshift iam role
rs_iam_role      = {
       dev = "eRedshiftFinrAdmin"
       test = "you need to set"
       prod = "you need to set"
}
# AMI used by EC2
ec2_ami  = {
       dev = "ami-e3797b83" #this is an encrypted AMI created by @lhu based on public unencrypted ubuntu 16.4 AMI"
       test = "you need to create/use an encrypted AMI baked from ubuntu 16.4"
       prod = "you need to create/use an encrypted AMI baked from ubuntu 16.4"
}
s3_bucket_name = {
# cannot create an s3 called com-fngn-finr-dataeng because it has already existed. 
# so I name this s3 as com-fngn-finr-tf-dataeng
       dev = "com-fngn-finr-tf-dataeng"
       test = "com-fngn-test-dataeng"
       prod = "com-fngn-prod-dataeng"
}
