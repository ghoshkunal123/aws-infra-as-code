resource "aws_instance" "master" {
  instance_type = "${lookup(var.ec2_instance_type, terraform.workspace)}"
  ami           = "${lookup(var.ec2_ami, terraform.workspace)}"

  key_name               = "${lookup(var.ec2_key_name, terraform.workspace)}"
  vpc_security_group_ids = ["${aws_security_group.airflow_master.id}"]

  subnet_id            = "${data.aws_subnet.private1.id}"
  iam_instance_profile = "${lookup(var.iam_instance_profile, terraform.workspace)}"
  user_data            = "${data.template_file.user_data.rendered}"
  ebs_optimized        = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    app           = "${var.tag_app}"
    Project       = "${var.tag_Project}"
    Owner         = "${var.tag_Owner}"
    CostCenter    = "${var.tag_CostCenter}"
    launcher      = "${var.tag_launcher}-master"
    env           = "${var.tag_office}-${terraform.workspace}"
    Name          = "${var.ec2_master_tag_Name}"
    "Patch Group" = "${var.ec2_tag_patch_group}"
    CodeDeploy    = "${var.ec2_tag_codedeploy}"
  }
}

resource "aws_instance" "worker" {
  count         = "${lookup(var.ec2_worker_count, terraform.workspace)}"
  instance_type = "${lookup(var.ec2_instance_type, terraform.workspace)}"
  ami           = "${lookup(var.ec2_ami, terraform.workspace)}"

  key_name               = "${lookup(var.ec2_key_name, terraform.workspace)}"
  vpc_security_group_ids = ["${aws_security_group.airflow_worker.id}"]
  subnet_id              = "${data.aws_subnet.private1.id}"
  iam_instance_profile   = "${lookup(var.iam_instance_profile, terraform.workspace)}"
  user_data              = "${data.template_file.user_data.rendered}"
  ebs_optimized          = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    app           = "${var.tag_app}"
    Project       = "${var.tag_Project}"
    Owner         = "${var.tag_Owner}"
    CostCenter    = "${var.tag_CostCenter}"
    launcher      = "${var.tag_launcher}-worker"
    env           = "${var.tag_office}-${terraform.workspace}"
    Name          = "${var.ec2_worker_tag_Name}_${count.index}"
    "Patch Group" = "${var.ec2_tag_patch_group}"
    CodeDeploy    = "${var.ec2_tag_codedeploy}"
  }
}

output "airflow_master_ip" {
  value = "${aws_instance.master.private_ip}"
}

output "airflow_worker_ip" {
  value = ["${aws_instance.worker.*.private_ip}"]
}

output "airflow_master_root_block_device" {
  value = "${aws_instance.master.root_block_device}"
}

output "airflow_master_ebs_block_device" {
  value = "${aws_instance.master.ebs_block_device}"
}

# this template implements user_data with file and arguments
data "template_file" "user_data" {
  template = "${file("templates/airflow_setup_adduser.sh.tfl")}"

  vars {
    ec2_user = "${var.ec2_user}"
    ec2_pw   = "${var.ec2_password}"
  }
}

# this template creates aws_hosts inventory used by ansible
data "template_file" "aws_hosts" {
  template   = "${file("templates/aws_hosts.cfg.tfl")}"
  depends_on = ["aws_instance.master", "aws_instance.worker"]

  vars {
    master_host   = "${format("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.master.private_ip)}"
    workers_hosts = "${join("\n", formatlist("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.worker.*.private_ip))}"
  }
}
