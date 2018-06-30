#!/usr/bin/env python
import os
import sys
import boto3
import json
print('Loading function')


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    target_operation = event['operate']
    if target_operation not in ["Disable", "Enable"]:
        raise ValueError('target_operation is not Disable or Enable')

    client = boto3.client('codepipeline')

    if target_operation == "Disable":
        response = client.disable_stage_transition(
            pipelineName = os.environ['pipeline_name'],
            stageName = os.environ['stage_name'],
            transitionType = os.environ['transition_type'],
            reason = 'Disable codepipeline when airflow EC2 is working'
        )
    else: # must be Enable
        response = client.enable_stage_transition(
            pipelineName = os.environ['pipeline_name'],
            stageName = os.environ['stage_name'],
            transitionType = os.environ['transition_type']
        )

# Manual invocation of the script (only used for testing)
if __name__ == "__main__":
    test = {}
    test["operate"] = "Disable"
    lambda_handler(test, None)
