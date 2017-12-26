#!/bin/bash
set -x
#exec &>> /tmp/airflow_setup_logfile.txt
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# --------- this script has no arguments
# ---------- Upgrade OS
lsb_release -a #verify ubuntu 16.04
sudo -H apt-get update
# note from lhu: I run below command before upgrade in order to avoid grub config prompt
# see: https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo -H apt-get -y upgrade

# ---------- install required python packages
sudo -H update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1
sudo -H apt -y install python3-pip
sudo -H update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
sudo -H pip install --upgrade pip #ensure pip 9.0.1
sudo -H apt -y install unixodbc-dev
sudo -H pip install pyodbc #4.0.17
sudo -H pip install psycopg2 #2.7.3.1
sudo -H pip install pandas #0.20.3
sudo -H pip install boto3 #1.4.7
sudo -H pip install awscli #1.11.168
sudo -H pip install flask-bcrypt #0.12.2

# --------- install airflow
sudo -H pip install "airflow[s3, celery]" #airflow = 1.8.0, celery = 4.1.0, s3 = 0.1.11
airflow initdb
#NOTE: When you run this the first time, it will generate a sqlite file (airflow.db) in the AIRFLOW_HOME directory for the Airflow Metastore.
# Since we are using postgres as metastore delete the file ~/airflow/airflow.db
rm -f ~/airflow/airflow.db

# ---------- install SSM agent at 64-bit ubuntu server 16
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
#EOF
