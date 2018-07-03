# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

module "shared_infra" {
  source                                       = "../../common_infra/shared_infra"
  git_repo_full_name                           = "de-datapipeline"
  git_repo_alias                               = "airflow"
  allowed_account_id                           = "483936848441"
  account_alias                                = "test"
  codedeploy_failure_sns_subscription_endpoint = "lhu@FinancialEngines.com"
}
