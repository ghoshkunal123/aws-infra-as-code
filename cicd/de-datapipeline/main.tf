# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

module "de-datapipeline" {
  source                                           = "../common_infra"
  git_repo_full_name                               = "de-datapipeline"
  git_repo_alias                                   = "airflow"
  codepipeline_s3_objectkey                        = "DataEngineering/de-datapipeline/master/de-datapipeline.zip"
  codepipeline_approval_ext_link                   = "https://gitlab.feicore.io/DataEngineering/de-datapipeline"
  codepipeline_approval_sns_subscription_endpoint1 = "lhu@FinancialEngines.com"
  codepipeline_approval_sns_subscription_endpoint2 = "skathane@FinancialEngines.com"
  codedeploy_failure_sns_subscription_endpoint     = "lhu@FinancialEngines.com"
  cloudwatch_triggered_s3_object                   = "arn:aws:s3:::git-to-amazon-s3-outputbucket-1xatxah3q3bzb/DataEngineering/de-datapipeline/master/de-datapipeline.zip"
  lambda_enable_codepipeline_time                  = "cron(00 19 ? * * *)"                                                                                                 #12:00PM PST DST = 19:00 UTC
  lambda_disable_codepipeline_time                 = "cron(00 7 ? * * *)"                                                                                                  #12:00AM PST DST = 7:00 UTC
}

module "shared_infra" {
  source                                       = "../common_infra/shared_infra"
  git_repo_full_name                           = "de-datapipeline"
  git_repo_alias                               = "airflow"
  allowed_account_id                           = "224919220385"
  account_alias                                = "finr"
  codedeploy_failure_sns_subscription_endpoint = "lhu@FinancialEngines.com"
}
