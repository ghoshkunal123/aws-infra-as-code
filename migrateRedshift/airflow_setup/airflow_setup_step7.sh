#!/bin/bash
set -x
#su ubuntu <<'EOF' # run as ubuntu user from 'EOF' to EOF
# ----------- following is only for worker
sudo systemctl enable airflow-worker.service
#EOF
