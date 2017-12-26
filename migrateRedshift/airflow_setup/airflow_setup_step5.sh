#!/bin/bash
set -x
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# ----------- following is master and worker
cd ~/airflow
mkdir dags
mkdir logs
mkdir run #to store the pid of the airflow server
sudo chmod 777 run
cp ~/workspace/de-datapipeline/Airflow/dags/* dags #Copy the python code for DAG to ${AIRFLOW_HOME}/dags directory
# now create few directories for our python framework
cd /mnt
sudo mkdir etl
cd etl
sudo mkdir data
sudo mkdir tmp
# ---------- Microsoft SQL Server  ODBC driver
sudo su <<'EOF'
#sudo sudd
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
#exit
EOF
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get -y install msodbcsql
sudo ACCEPT_EULA=Y apt-get -y install mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# ---------- Setting up Systemd to Run Airflow: need to do after airflow.conf is modified
sudo cp ~/workspace/de-datapipeline/Airflow/airflow-*.service /etc/systemd/system
sudo mkdir -p /etc/sysconfig
sudo cp ~/workspace/de-datapipeline/Airflow/airflow /etc/sysconfig
#EOF
