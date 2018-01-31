usage: 
0. configure variables.tf: 
make sure lambda_role is changed to lambda role of test account. the default one is the lambda role of finr account

1. to deploy lambda to test account:
(after you run okta to obtain temporary credential)
terraform plan
terraform apply

2. to invoke lambda to start/stop EC2:
(after you run okta to obtain  temporary credential)

2-1: to start all EC2: 
aws lambda invoke --function-name=fngn-fqa-abba-startEC2 --invocation-type=RequestResponse --payload '{"instanceid":"all"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode

2-2: to start a specific EC2 with <instance id>:
aws lambda invoke --function-name=fngn-fqa-abba-startEC2 --invocation-type=RequestResponse --payload '{"instanceid":"<instance id>"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode

2-3: to stop all EC2: 
aws lambda invoke --function-name=fngn-fqa-abba-stopEC2 --invocation-type=RequestResponse --payload '{"instanceid":"all"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode

2-2: to start a specific abba EC2 with <instance id>:
aws lambda invoke --function-name=fngn-fqa-abba-stopEC2 --invocation-type=RequestResponse --payload '{"instanceid":"<instance id>"}' --log-type=Tail /dev/null | jq -r '.LogResult' | base64 --decode
