resource "aws_ebs_volume" "airflow_master" {
  availability_zone = "{var.aws_region}"
  size              = 100

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "${var.ebs_master_tag_Name}"
  }
}

resource "aws_volume_attachment" "ebs_attach_master" {
  device_name = "/dev/sda1"
  volume_id   = "${aws_ebs_volume.airflow_master.id}"
  instance_id = "${aws_instance.master.id}"
}
