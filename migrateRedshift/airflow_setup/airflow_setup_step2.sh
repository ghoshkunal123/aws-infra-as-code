#!/bin/bash
set -x
#exec &>> /tmp/airflow_setup_logfile.txt
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# --------- this script has 2 arguments: rabbitmq_user rabbitmq_password
###########following is only for master
rabbitmq_user=$1
rabbitmq_password=$2

# ------------- Setting up RabbitMQ
cd /tmp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get -y install erlang erlang-nox
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install rabbitmq-server
sudo rabbitmqctl add_user $rabbitmq_user $rabbitmq_password
sudo rabbitmqctl set_user_tags $rabbitmq_user administrator
sudo rabbitmqctl set_permissions -p / $rabbitmq_user ".*" ".*" ".*"
sudo rabbitmq-plugins enable rabbitmq_management
#EOF
