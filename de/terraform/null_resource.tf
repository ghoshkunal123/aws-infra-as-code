resource "null_resource" "ansible" {
  triggers {
    template_rendered = "${ data.template_file.aws_hosts.rendered }"
  }

  # this local-exec creates aws_hosts so that ansible knows who are masters and workers.
  provisioner "local-exec" {
    command = "echo '${ data.template_file.aws_hosts.rendered }' > ${var.ansible_airflow_directory}/aws_hosts"
  }

  provisioner "local-exec" {
    command = "if ${var.new_deployment};then sleep 60 && ansible-playbook -i ${var.ansible_airflow_directory}/aws_hosts -e ansible_python_interpreter=/usr/bin/python3 ${var.ansible_airflow_directory}/setup_ssh_authorized_key.yml -e \"user=etluser\";fi;"
  }

  provisioner "local-exec" {
    command = "aws redshift create-tags --resource-name arn:aws:redshift:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parametergroup:${aws_redshift_parameter_group.analytics.id} --tags Key=app,Value=${var.tag_app} Key=Project,Value=${var.tag_Project} Key=env,Value=${var.tag_office}-${terraform.workspace} Key=Owner,Value=${var.tag_Owner} Key=CostCenter,Value=${var.tag_CostCenter} Key=Name,Value=${aws_redshift_parameter_group.analytics.id}"
  }

  # this local-exec creates ansible airflow vars file, which will be used by ansible jinja2 to create airflow.cfg
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > ${var.ansible_airflow_directory}/${var.ansible_airflow_cfg_vars_file}
domain_name: ${lookup(var.route53_domain_name, terraform.workspace)}
s3_bucket_name: ${aws_s3_bucket.s3.bucket}
rds_user: ${var.rds_user}
rds_pw: ${var.rds_password}
rds_endpoint: ${aws_db_instance.rds.address}
rds_db_name: ${var.rds_db_name}
rabbitmq_user: ${var.rabbitmq_user}
rabbitmq_pw: ${var.rabbitmq_password}
rabbitmq_host: ${aws_instance.master.private_ip}
rs_host: ${aws_redshift_cluster.analytics.endpoint}
rs_db_name: ${var.rs_db_name}
rs_iam_role_arn: ${data.aws_iam_role.redshift.arn}
rs_pw: ${var.rs_pw}
env_name: ${lookup(var.airflow_env_properties, terraform.workspace)}
mssql_aux_db: ${lookup(var.mssql_aux_db, terraform.workspace)}
mssql_adv_db: ${lookup(var.mssql_adv_db, terraform.workspace)}
mssql_password: ${var.mssql_password}
mssql_adv_host: ${lookup(var.on-premise_mssqladvdb_dns, terraform.workspace)}
mssql_aux_host: ${lookup(var.on-premise_mssqlauxdb_dns, terraform.workspace)}
cron_schedule: ${lookup(var.cron_schedule, terraform.workspace)}
email_dist_list: ${lookup(var.email_dist_list, terraform.workspace)}
pagerduty_low_arn: ${data.aws_sns_topic.pageduty_low.arn}
pagerduty_high_arn: ${data.aws_sns_topic.pageduty_high.arn}
s3_datalake_enriched_bucket: ${lookup(var.s3_datalake_enriched_bucket, terraform.workspace)}
EOF
EOD
  }

  #remove redshift port because dataengineering wants to have rs_host not rs_endpoint
  provisioner "local-exec" {
    command = "sed -i -e 's/:5439//' ${var.ansible_airflow_directory}/${var.ansible_airflow_cfg_vars_file}"
  }

  # this local-exec encrypts the ansible airflow vars file to protect the sensitive information
  provisioner "local-exec" {
    command = "ansible-vault encrypt ${var.ansible_airflow_directory}/${var.ansible_airflow_cfg_vars_file} --ask-vault-pass"
  }

  # uncomment it if you want to let ansible configure airflow from terraform
  #    provisioner "local-exec" {
  #       command = "ansible-playbook -i ${var.ansible_airflow_directory}/aws_hosts ${var.ansible_airflow_directory}/airflow_setup.yml --ask-vault-pass"
  #    }
}
