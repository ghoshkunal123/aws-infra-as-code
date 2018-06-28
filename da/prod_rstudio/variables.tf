variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {
  default = "default"
}

# vpc = ANALYTICS
variable "vpc_id" {
  default = "vpc-5057ea37"
}

# ANALYTICS-subnet-private-us-west-1a 10.129.30.0/24
variable "subnet_private1_id" {
  default = "subnet-12df9d75"
}

# ANALYTICS-subnet-private-us-west-1c 10.129.31.0/24
variable "subnet_private2_id" {
  default = "subnet-df6ef184"
}

variable "cidr_10" {
  default = "10.0.0.0/8"
}

variable "cidr_172" {
  default = "172.24.0.0/22" #TDB: /22 or /24
}

variable "ec2_key_name" {
  default = "analytics-prod-devops-keypair"
}

variable "ec2_instance_type" {
  default = "m5.2xlarge"
}

variable "iam_instance_profile" {
  default = "iRStudioAnalyticsFinr"
}

# tags
variable "tag_app" {
  default = "analytics"
}

variable "tag_Project" {
  default = "ANLY-2018"
}

variable "tag_Owner" {
  default = "tyamada@FinancialEngines.com" #TBD: will confirm whether use Tak's email
}

variable "tag_CostCenter" {
  default = "270"
}

variable "tag_env" {
  default = "analytics-prod"
}

variable "tag_ec2_Name" {
  default = "fngn-datasci-rstudio"
}

variable "tag_SG_Name_rstudio" {
  default = "analytics-rstudio"
}

variable "tag_SG_Name_allowLanDesk" {
  default = "analytics-allowLanDesk"
}

variable "tag_SG_Name_fe-ad-comm" {
  default = "analytics-fe-ad-communication"
}

# lambda
variable "lambda_role_name" {
  default = "eLambdaExecutionAnalyticsFinr"
}

variable "lambda_start_ec2_time" {
  default = "cron(0 13 ? * * *)" #13 UTC = 6AM PT
}

variable "lambda_stop_ec2_time" {
  default = "cron(0 2 ? * * *)" #2AM UTC = 7PM PT
}

# user-data
variable "computer_name" {
  default = "anly-rstudio"
}

variable "dns_servers" {
  type = "map"

  default = {
    us-west-1 = "\"10.131.14.220\",\"10.131.15.221\""
    us-east-1 = "You need to set it"
  }
}
