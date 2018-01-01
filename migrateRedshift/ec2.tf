resource "aws_instance" "master1" {
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"

  key_name = "${var.ec2_key_name}"
#  vpc_security_group_ids = ["${var.aws_security_group_sshonly_id}", "${var.aws_security_group_Flower_Ports_id}", "${var.aws_security_group_Postgres_id}", "${var.aws_security_group_RabbitMQ_id}", "${var.aws_security_group_Airflow_Ports_id}"]
vpc_security_group_ids = ["${aws_security_group.airflow_ec2.id}"]

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
cat <<EOF > ${var.ansible_airflow_directory}${var.ansible_airflow_cfg_vars_file}
s3_bucket_name: ${var.s3_bucket_name}
rds_user: ${var.dbuser}
rds_pw: ${var.dbpassword}
rds_endpoint_host_name: ${var.rds_identifier}
rabbitmq_user: ${var.rabbitmq_user}
rabbitmq_pw: ${var.rabbitmq_password}
rabbitmq_host: ${aws_instance.master1.private_ip}
rabbitmq_port: 5672
EOF
EOD
  }
}
resource "aws_instance" "agent" {
  count                  = 2
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"
  
  key_name = "${var.ec2_key_name}"
#  vpc_security_group_ids = ["${var.aws_security_group_sshonly_id}", "${var.aws_security_group_Flower_Ports_id}", "${var.aws_security_group_Postgres_id}", "${var.aws_security_group_RabbitMQ_id}", "${var.aws_security_group_Airflow_Ports_id}"]
  vpc_security_group_ids = ["${aws_security_group.airflow_ec2.id}"]  
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
}
output "airflow_master_ip" {
    value = "${aws_instance.master1.private_ip}"
}
output "airflow_agent_ip" {
    value = ["${aws_instance.agent.*.private_ip}"]
}

# this template implements user_data with file and arguments
data "template_file" "user_data" {
      template = "${file("airflow_setup_adduser.sh.tfl")}"
      vars {
        ec2_user = "${var.ec2_user}"
        ec2_pw = "${var.ec2_pw}"
      }
}
# this template creates aws_hosts inventory used by ansible
data "template_file" "aws_hosts" {
    template = "${file("aws_hosts.cfg.tfl")}"
    depends_on = ["aws_instance.master1", "aws_instance.agent"]
    vars {
        master_host = "${format("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.master1.private_ip)}"
        workers_hosts = "${join("\n", formatlist("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.agent.*.private_ip))}"
    }
}
resource "null_resource" "aws_hosts" {
    triggers {
       template_rendered = "${ data.template_file.aws_hosts.rendered }"
    }
    provisioner "local-exec" {
       command = "echo '${ data.template_file.aws_hosts.rendered }' > ${var.ansible_airflow_directory}aws_hosts"
    }
}
