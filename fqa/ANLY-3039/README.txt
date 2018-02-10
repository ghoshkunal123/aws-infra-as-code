usage: 
0. configure variables.tf: 
make sure lambda_role is changed to lambda role of test account. the default one is the lambda role of finr account

1. to deploy lambda to test account:
(after you run okta to obtain temporary credential)
terraform init -var 'lambda_role=something'
terraform plan -var 'lambda_role=something'
terraform apply -var 'lambda_role=something'

2. to invoke lambda to start/stop EC2:
(after you run okta to obtain  temporary credential)

2-1: to start all EC2 of abba5 group: 
aws lambda invoke --function-name=fngn-fqa-abba-startEC2 --invocation-type=RequestResponse --payload '{"instanceid":"abba5"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode

2-3: to stop all EC2 of abba6 group: 
aws lambda invoke --function-name=fngn-fqa-abba-stopEC2 --invocation-type=RequestResponse --payload '{"instanceid":"abba6"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode
