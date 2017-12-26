#!/bin/bash
set -x
#exec &>> /tmp/airflow_setup_logfile.txt
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
###############following is for master only
sudo apt -y install postgresql-client
airflow initdb
#EOF
