#!/usr/bin/env python
import os
import sys
import boto3
import json
print('Loading function')

def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    target_instanceid = event['instanceid']
    tag_name='lambda'
    tag_value='fqa-abba'

    ec2 = boto3.client('ec2')

    instances = []
    for reservation in ec2.describe_instances(Filters=[{'Name':'tag:' + tag_name,'Values':[tag_value]}])['Reservations']:
        for instance in reservation['Instances']:
            instanceid=instance['InstanceId']
            if target_instanceid != instanceid and target_instanceid != 'all':
                continue
            instances.append(instanceid)
            ec2.start_instances(InstanceIds=[instanceid])
    print('starting the following instances: {}'.format(instances))
