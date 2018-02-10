#!/usr/bin/env python
import os
import sys
import boto3
import json
import time

def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    target_tag_group = event['tag_group']
    allowed_tag_groups = ['abba5', 'abba6', 'abba7', 'abba8']
    if target_tag_group not in allowed_tag_groups:
        print ("You do not have permission to modify %s" % (target_tag_group))
        return

    tag_name='Name'
    tag_value= '*' + target_tag_group + '*'
    print ("will stop all instances with %s" % (tag_value))

    ec2 = boto3.resource('ec2')
    instanceids = []

    instances = ec2.instances.filter(Filters=[{'Name': 'tag:' + tag_name, 'Values': [tag_value]}])
    for instance in instances:
        instanceid=instance.id
        instanceids.append(instanceid)

    print('stopping the following instances id: {}'.format(instanceids))
    if len(instanceids) > 0:
        turnOff = ec2.instances.filter(InstanceIds=instanceids).stop()

    for instanceid in instanceids:
        instance = ec2.Instance(instanceid)
        instance.wait_until_stopped()
        print("instance " + instanceid + "is stopped now!")

# Manual invocation of the script (only used for testing)
if __name__ == "__main__":
    # Test data
    test = {}
    test["instanceid"] = "i-05ae43e692548ff47"
    # Test function
    handler(test, None)
