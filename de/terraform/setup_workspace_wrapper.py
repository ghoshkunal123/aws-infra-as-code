#!/usr/bin/env python
import os
import sys
import boto3
import pexpect
from shutil import copyfile
from subprocess import call
from subprocess import Popen,PIPE

#usage example: 
#./setup_workspace_wrapper.py finr /Users/lhu/Downloads/awsokta-1.1.12-all.jar lhu uAnalyticsDevOps
if len(sys.argv) != 5:
    print("wrong argument number")
    exit (1) 

ws_name,okta_jar,okta_user,aws_role = sys.argv[1:5]

if ws_name not in ['finr', 'test', 'prod']:
    print("wrong workspace")
    exit (2)

print("You want to switch to: %s" % (ws_name))

terraform_ws_command = "terraform workspace show"
output = os.popen(terraform_ws_command).read()
output = output.strip()
print (output)
if output == ws_name:
    print("You are already in %s" % (ws_name))  
    exit (0)

okta_cred_command = "java -jar %s -e %s -u %s -r %s" % (okta_jar, ws_name, okta_user, aws_role)
print (okta_cred_command)
os.system(okta_cred_command)

dest_file = 'backend.tf'
src_file = "%s.%s" % (dest_file, ws_name) 

print (src_file)
print (dest_file)
copyfile(src_file, dest_file)

terraform_ws_command = 'terraform init'
print (terraform_ws_command)
os.system(terraform_ws_command)

terraform_ws_command = "terraform workspace select %s" % (ws_name)
print (terraform_ws_command)
os.system(terraform_ws_command)

terraform_ws_command = "terraform workspace list"
print (terraform_ws_command)
os.system(terraform_ws_command)


