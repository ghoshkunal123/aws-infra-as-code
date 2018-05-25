module "de-datapipeline" {
  source                                       = "../../common_infra/test"
  git_repo_full_name                           = "de-datapipeline"
  git_repo_alias                               = "airflow"
  codedeploy_failure_sns_subscription_endpoint = "lhu@FinancialEngines.com"
}
