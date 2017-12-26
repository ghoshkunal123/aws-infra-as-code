# this template implements user_data with file and arguments 
data "template_file" "user_data" {
      template = "${file("airflow_setup/airflow_setup_adduser.sh.tfl")}"
      vars {
        ec2_user = "${var.ec2_user}"
        ec2_pw = "${var.ec2_pw}"
      }
}
resource "aws_instance" "master1" {
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"

  key_name = "${var.ec2_key_name}"
  vpc_security_group_ids = ["${var.aws_security_group_sshonly_id}", "${var.aws_security_group_Flower_Ports_id}", "${var.aws_security_group_Postgres_id}", "${var.aws_security_group_RabbitMQ_id}", "${var.aws_security_group_Airflow_Ports_id}"]

  subnet_id = "${var.subnet_private1_id}"
  iam_instance_profile = "${var.iam_instance_profile}"
  user_data = "${data.template_file.user_data.rendered}"
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.ec2_master_tag_Name}"
      "Patch Group" = "${var.ec2_tag_patch_group}"
  }
  provisioner "local-exec" {
      command = <<EOD
cat <<EOF > aws_hosts
[master]
${aws_instance.master1.private_ip}
EOF
EOD
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step1.sh"
    destination = "/tmp/airflow_setup_step1.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step2.sh"
    destination = "/tmp/airflow_setup_step2.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step3.sh"
    destination = "/tmp/airflow_setup_step3.sh"
  }
  #lisahu: to be changed
  provisioner "file" {
    source      = "${var.gitlab_private_token}"
    destination = "/tmp/gitlab_private_token"
  }
  provisioner "file" {
    source      = "airflow_setup/modify_airflow_config.sh"
    destination = "/tmp/modify_airflow_config.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step4.sh"
    destination = "/tmp/airflow_setup_step4.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step5.sh"
    destination = "/tmp/airflow_setup_step5.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step6.sh"
    destination = "/tmp/airflow_setup_step6.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/airflow_setup_step1.sh",
      "chmod +x /tmp/airflow_setup_step2.sh",
      "chmod +x /tmp/airflow_setup_step3.sh",
      "chmod +x /tmp/modify_airflow_config.sh",
      "chmod +x /tmp/airflow_setup_step4.sh",
      "chmod +x /tmp/airflow_setup_step5.sh",
      "chmod +x /tmp/airflow_setup_step6.sh",
      "/tmp/airflow_setup_step1.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step2.sh ${var.rabbitmq_user} ${var.rabbitmq_password}  | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step3.sh /tmp/gitlab_private_token  | tee -a /tmp/airflow_log_file",
      "/tmp/modify_airflow_config.sh ~/airflow/airflow.cfg ${var.s3_bucket_name} ${var.dbuser} ${var.dbpassword} ${var.rds_identifier}.cszmnolqsfkv.us-west-1.rds.amazonaws.com ${var.rabbitmq_user} ${var.rabbitmq_password} ${aws_instance.master1.private_ip} 5672",
      "/tmp/airflow_setup_step4.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step5.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step6.sh | tee -a /tmp/airflow_log_file"
    ]
  }

  connection {
    user = "${var.ec2_user}"
    password = "${var.ec2_pw}"
    #private_key = "${file("${var.ec2_private_key_name}")}"
  }
}
resource "aws_instance" "agent" {
  count                  = 2
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"
  
  key_name = "${var.ec2_key_name}"
  vpc_security_group_ids = ["${var.aws_security_group_sshonly_id}", "${var.aws_security_group_Flower_Ports_id}", "${var.aws_security_group_Postgres_id}", "${var.aws_security_group_RabbitMQ_id}", "${var.aws_security_group_Airflow_Ports_id}"]
  
  subnet_id = "${var.subnet_private1_id}"
  iam_instance_profile = "${var.iam_instance_profile}"
  user_data = "${data.template_file.user_data.rendered}"
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.ec2_agent_tag_Name}_${count.index}"
      "Patch Group" = "${var.ec2_tag_patch_group}"
  }
  provisioner "local-exec" {
      command = <<EOD
cat <<EOF >> aws_hosts
[agents]
${aws_instance.agent.0.private_ip}
EOF
EOD
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step1.sh"
    destination = "/tmp/airflow_setup_step1.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step3.sh"
    destination = "/tmp/airflow_setup_step3.sh"
  }
  #lisahu: to be changed
  provisioner "file" {
    source      = "${var.gitlab_private_token}"
    destination = "/tmp/gitlab_private_token"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step5.sh"
    destination = "/tmp/airflow_setup_step5.sh"
  }
  provisioner "file" {
    source      = "airflow_setup/airflow_setup_step7.sh"
    destination = "/tmp/airflow_setup_step7.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/airflow_setup_step1.sh",
      "chmod +x /tmp/airflow_setup_step3.sh",
      "chmod +x /tmp/airflow_setup_step5.sh",
      "chmod +x /tmp/airflow_setup_step7.sh",
      "/tmp/airflow_setup_step1.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step3.sh /tmp/gitlab_private_token  | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step5.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step7.sh | tee -a /tmp/airflow_log_file"
    ]
  }

  connection {
    user = "${var.ec2_user}"
    password = "${var.ec2_pw}"
    #private_key = "${file("${var.ec2_private_key_name}")}"
  }

}
output "airflow_master_ip" {
    value = "${aws_instance.master1.private_ip}"
}

output "airflow_agent_ip" {
    value = ["${aws_instance.agent.*.private_ip}"]
}
