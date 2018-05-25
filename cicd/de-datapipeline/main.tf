module "de-datapipeline" {
  source                                          = "../common_infra"
  git_repo_full_name                              = "de-datapipeline"
  git_repo_alias                                  = "airflow"
  codepipeline_s3_objectkey                       = "DataEngineering/de-datapipeline/master/de-datapipeline.zip"
  codepipeline_approval_ext_link                  = "https://gitlab.feicore.io/DataEngineering/de-datapipeline"
  codepipeline_approval_sns_subscription_endpoint = "lhu@FinancialEngines.com"
  codedeploy_failure_sns_subscription_endpoint    = "lhu@FinancialEngines.com"
  cloudwatch_triggered_s3_object                  = "arn:aws:s3:::git-to-amazon-s3-outputbucket-1xatxah3q3bzb/DataEngineering/de-datapipeline/master/de-datapipeline.zip"
}
