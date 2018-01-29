#!/usr/bin/env python
import os
import sys
import boto3

# You specify the instance id to start that ec2,
# or you can type 'all' to start all the ec2 with tags launcher=Terraform-ANLY-2820
#for example:
#./stop_ec2.py all
#./stop_ec2.py i-0194ca6895a87ac26

target_instanceid = sys.argv[1]
tag_name='launcher'
tag_value='Terraform-ANLY-2820'

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
