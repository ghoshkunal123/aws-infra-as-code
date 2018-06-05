# Copyright 2018
# Author: Lisa Hu
# Department: Data Engineering @ Analytics Office

from __future__ import print_function
from boto3.session import Session

import json
import urllib
import boto3
import zipfile
import tempfile
import botocore
import traceback

import os
import sys
import time
import datetime


print('Loading function')

code_pipeline = boto3.client('codepipeline')


def get_user_params(job_data):
    try:
        print ("job_data = %s" % (job_data))
        # Get the user parameters which contain the stack, artifact and file settings
        user_parameters = job_data['actionConfiguration']['configuration']['UserParameters']
        print ("user_parameters  = %s" % (user_parameters))
        decoded_parameters = json.loads(user_parameters)
        print ("decoded_parameters  = %s" % (decoded_parameters))
        
    except Exception as e:
        # We're expecting the user parameters to be encoded as JSON
        # so we can pass multiple values. If the JSON can't be decoded
        # then fail the job with a helpful message.
        raise Exception('UserParameters could not be decoded as JSON')
    
    if 'Operation' not in decoded_parameters:
        # Validate that the stack is provided, otherwise fail the job
        # with a helpful message.
        raise Exception('Your UserParameters JSON must include the Operation')
    
    if 'TagKey' not in decoded_parameters:
        # Validate that the artifact name is provided, otherwise fail the job
        # with a helpful message.
        raise Exception('Your UserParameters JSON must include the TagKey')
    
    if 'TagValue' not in decoded_parameters:
        # Validate that the template file is provided, otherwise fail the job
        # with a helpful message.
        raise Exception('Your UserParameters JSON must include the template TagValue')
    
    return decoded_parameters

def put_job_failure(job, message):
    """Notify CodePipeline of a failed job
    
    Args:
        job: The CodePipeline job ID
        message: A message to be logged relating to the job status
        
    Raises:
        Exception: Any exception thrown by .put_job_failure_result()
    
    """
    print('Putting job failure')
    print(message)
    code_pipeline.put_job_failure_result(jobId=job, failureDetails={'message': message, 'type': 'JobFailed'})
 
def put_job_success(job, message):
    """Notify CodePipeline of a successful job
    
    Args:
        job: The CodePipeline job ID
        message: A message to be logged relating to the job status
        
    Raises:
        Exception: Any exception thrown by .put_job_success_result()
    
    """
    print('Putting job success')
    print(message)
    code_pipeline.put_job_success_result(jobId=job)
    
def start_ec2(tag_key, tag_value):

    ec2 = boto3.resource('ec2')
    instanceids = []

    instances = ec2.instances.filter(Filters=[{'Name': 'tag:' + tag_key, 'Values': [tag_value]}])
    for instance in instances:
        instanceid=instance.id
        instanceids.append(instanceid)

    print('starting the following instances id: {}'.format(instanceids))
    before_start = datetime.datetime.now()
    if len(instanceids) > 0:
        turnOn = ec2.instances.filter(InstanceIds=instanceids).start()

    for instanceid in instanceids:
        instance = ec2.Instance(instanceid)
        instance.wait_until_running()
        print("instance " + instanceid + "is running now!")
    
    after_start = datetime.datetime.now()
    elapsedTime = after_start - before_start
    minutes, seconds = divmod(elapsedTime.seconds, 60)
    print ("elapsedTime is %d minutes and %d second" % (minutes, seconds))

def stop_ec2(tag_key, tag_value):
    ec2 = boto3.resource('ec2')
    instanceids = []

    instances = ec2.instances.filter(Filters=[{'Name': 'tag:' + tag_key, 'Values': [tag_value]}])
    for instance in instances:
        instanceid=instance.id
        instanceids.append(instanceid)

    print('stopping the following instances id: {}'.format(instanceids))
    before_start = datetime.datetime.now()
    if len(instanceids) > 0:
        turnOff = ec2.instances.filter(InstanceIds=instanceids).stop()

    for instanceid in instanceids:
        instance = ec2.Instance(instanceid)
        instance.wait_until_stopped()
        print("instance " + instanceid + "is stopped now!")
        
    after_start = datetime.datetime.now()
    elapsedTime = after_start - before_start
    minutes, seconds = divmod(elapsedTime.seconds, 60)
    print ("elapsedTime is %d minutes and %d second" % (minutes, seconds))

def lambda_handler(event, context):

    try:
     # Extract the Job ID
        print("here is event:")
        print (event)
        print (event['CodePipeline.job'])
        job_id = event['CodePipeline.job']['id']
        print ("job_id= %s" % (job_id))

        job_data = event['CodePipeline.job']['data']
        print ("job_data = %s" % (job_data))
        params = get_user_params(job_data)
        
        value1 = params['Operation']
        value2 = params['TagKey']
        value3 = params['TagValue']
        
        print("value1 = " + value1)
        print("value2 = " + value2)
        print("value3 = " + value3)

        if value1 not in ["StartEC2", "StopEC2"]:
            raise ValueError('value1 is not StartEC2 or StopEC2')
        
        if value1 == "StartEC2":
            start_ec2(value2, value3)
        else:
            stop_ec2(value2, value3)
            
        put_job_success(job_id, 'Function success')
    except Exception as e:
        # If any other exceptions which we didn't expect are raised
        # then fail the job and log the exception message.
        print('Function failed due to exception.') 
        print(e)
        traceback.print_exc()
        put_job_failure(job_id, 'Function exception: ' + str(e))
      
    print('Function complete.')   
    return "Complete."
