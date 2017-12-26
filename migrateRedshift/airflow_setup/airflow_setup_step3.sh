#!/bin/bash
set -x
#exec &>> /tmp/airflow_setup_logfile.txt
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# --------- this script has 1 argument: gitlab_private_token
###############following is for common again
gitlab_private_token=`cat $1`
# ----------- get code from gitlab
keypair_file=~/.ssh/id_rsa
keypair_pub_file=$keypair_file.pub
cd ~
mkdir workspace
cd workspace
ssh-keygen -t rsa -C "lhu@financialengines.com" -b 4096 -q -N "" -f $keypair_file

# ---------- copy the public key to gitlab
curl -X POST -F "private_token=$gitlab_private_token" -F "title=tf_$HOSTNAME" -F "key=$(cat $keypair_pub_file)" "https://gitlab.feicore.io/api/v3/user/keys"

ssh-keyscan gitlab.feicore.io >> ~/.ssh/known_hosts
git clone git@gitlab.feicore.io:DataEngineering/de-datapipeline.git
cp ~/workspace/de-datapipeline/Airflow/airflow.cfg ~/airflow/

# -----------next step is to modify airflow.conf
#EOF
