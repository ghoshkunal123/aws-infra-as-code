#!/usr/bin/env python
import os
import sys
import boto3
import json
print('Loading function')

def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    target_instanceid = event['instanceid']
    tag_name='launcher'
    tag_value='Terraform-ANLY-2820-worker'

    ec2 = boto3.client('ec2')

    instances = []
    for reservation in ec2.describe_instances(Filters=[{'Name':'tag:' + tag_name,'Values':[tag_value]}])['Reservations']:
        for instance in reservation['Instances']:
            instanceid=instance['InstanceId']
            if target_instanceid != instanceid and target_instanceid != 'all':
                continue
            instances.append(instanceid)
            ec2.stop_instances(InstanceIds=[instanceid])
    print('stopping the following instances: {}'.format(instances))

# Manual invocation of the script (only used for testing)
if __name__ == "__main__":
    test = {}
    test["instanceid"] = "i-05ae43e692548ff47"
    handler(test, None)
