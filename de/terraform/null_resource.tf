resource "null_resource" "ansible" {
  triggers {
    template_rendered = "${ data.template_file.aws_hosts.rendered }"
  }

  # this local-exec creates aws_hosts so that ansible knows who are masters and workers.
  provisioner "local-exec" {
    command = "echo '${ data.template_file.aws_hosts.rendered }' > ${var.ansible_airflow_directory}/aws_hosts"
  }

  provisioner "local-exec" {
    command = "sleep 60 && ansible-playbook -i ${var.ansible_airflow_directory}/aws_hosts -e ansible_python_interpreter=/usr/bin/python3 ${var.ansible_airflow_directory}/setup_ssh_authorized_key.yml -e \"user=etluser\""
  }

  # this local-exec creates ansible airflow vars file, which will be used by ansible jinja2 to create airflow.cfg
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > ${var.ansible_airflow_directory}/${var.ansible_airflow_cfg_vars_file}
s3_bucket_name: ${aws_s3_bucket.s3.bucket}
rds_user: ${var.rds_user}
rds_pw: ${var.rds_password}
rds_endpoint_address: ${aws_db_instance.rds.address}
rabbitmq_user: ${var.rabbitmq_user}
rabbitmq_pw: ${var.rabbitmq_password}
rabbitmq_host: ${aws_instance.master.private_ip}
rabbitmq_port: 5672
EOF
EOD
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
