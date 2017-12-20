resource "aws_instance" "master" {
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"

  key_name = "${var.ec2_key_name}"
  vpc_security_group_ids = ["${var.aws_security_group_sshonly_id}", "${var.aws_security_group_Flower_Ports_id}", "${var.aws_security_group_Postgres_id}", "${var.aws_security_group_RabbitMQ_id}", "${var.aws_security_group_Airflow_Ports_id}"]

  subnet_id = "${var.subnet_private1_id}"
  iam_instance_profile = "${var.iam_instance_profile}"
  #user_data = "${file("airflow_setup_common_test.sh")}"

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
      "/tmp/airflow_setup_step1.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step2.sh ${var.rabbitmq_user} ${var.rabbitmq_password}  | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step3.sh /tmp/gitlab_private_token  | tee -a /tmp/airflow_log_file",
      "/tmp/modify_airflow_config.sh ~/airflow/airflow.cfg ${var.s3_bucket_name} ${var.dbuser} ${var.dbpassword} ${var.rds_identifier}.cszmnolqsfkv.us-west-1.rds.amazonaws.com ${var.rabbitmq_user} ${var.rabbitmq_password} ${aws_instance.master.id} 5672",    
      "/tmp/airflow_setup_step4.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step5.sh | tee -a /tmp/airflow_log_file",
      "/tmp/airflow_setup_step6.sh | tee -a /tmp/airflow_log_file"
    ]
  }
  
  connection {
    user = "${var.ec2_user}"
    private_key = "${file("${var.ec2_private_key_name}")}"
  }

  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.ec2_master_tag_Name}"
      "Patch Group" = "${var.ec2_tag_patch_group}"
  }
}
