resource "aws_instance" "master" {
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"

  key_name = "${var.ec2_key_name}"
  vpc_security_group_ids = ["${aws_security_group.airflow_ec2.id}"]

  subnet_id = "${data.aws_subnet.finr_private1.id}"
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
}
resource "aws_instance" "worker" {
  count                  = "${var.ec2_worker_count}"
  instance_type = "${var.ec2_instance_type}"
  ami = "${var.ec2_ami}"
  
  key_name = "${var.ec2_key_name}"
  vpc_security_group_ids = ["${aws_security_group.airflow_ec2.id}"]  
  subnet_id = "${data.aws_subnet.finr_private1.id}"
  iam_instance_profile = "${var.iam_instance_profile}"
  user_data = "${data.template_file.user_data.rendered}"
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.ec2_worker_tag_Name}_${count.index}"
      "Patch Group" = "${var.ec2_tag_patch_group}"
  }
}
output "airflow_master_ip" {
    value = "${aws_instance.master.private_ip}"
}
output "airflow_worker_ip" {
    value = ["${aws_instance.worker.*.private_ip}"]
}

# this template implements user_data with file and arguments
data "template_file" "user_data" {
      template = "${file("templates/airflow_setup_adduser.sh.tfl")}"
      vars {
        ec2_user = "${var.ec2_user}"
        ec2_pw = "${var.ec2_password}"
      }
}
# this template creates aws_hosts inventory used by ansible
data "template_file" "aws_hosts" {
    template = "${file("templates/aws_hosts.cfg.tfl")}"
    depends_on = ["aws_instance.master", "aws_instance.worker"]
    vars {
        master_host = "${format("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.master.private_ip)}"
        workers_hosts = "${join("\n", formatlist("%s ansible_python_interpreter=/usr/bin/python3", aws_instance.worker.*.private_ip))}"
    }
}
