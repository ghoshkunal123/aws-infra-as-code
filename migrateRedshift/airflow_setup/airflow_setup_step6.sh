#!/bin/bash
set -x
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# ----------- following is only for master
sudo systemctl enable airflow-webserver.service # Master
sudo systemctl enable airflow-scheduler.service # Master
sudo systemctl enable airflow-flower.service # Master
sudo service airflow-webserver start
sudo service airflow-flower start
#EOF
