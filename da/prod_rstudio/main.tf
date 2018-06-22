terraform {
  backend "s3" {
    bucket     = "com.fngn.prod.terraform.us-west-1"
    key        = "analytics_finr/aws-infra-as-code/da/rstudio/terraform.tfstate"
    region     = "us-west-1"
    encrypt    = true
    lock_table = "terraform-locks"

    #    dynamodb_table = "terraform-locks" #TBD: I do not have permission to write new item.
  }
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["fe-windows-server-2012R2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${data.aws_caller_identity.current.account_id}"]
}

data "template_file" "user_data" {
  template = "${file("analytics-rstudio-ec2user-data.txt.tpl")}"
}

#instance
resource "aws_instance" "rstudio" {
  ami                    = "${data.aws_ami.windows.id}"
  instance_type          = "${var.ec2_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.rstudio.id}"]
  subnet_id              = "${data.aws_subnet.private1.id}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${var.ec2_key_name}"
  ebs_optimized          = true

  #  monitoring             = true #TBD: comment it since I do not have permission for EC2:MonitorInstances
  #TBD: I do not know which code is to :
  # Running SSM agent, virus scanner installed (sentialone), pathing schedule set.
  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name       = "${var.tag_ec2_Name}"
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
  }

  #  lifecycle { #TDB: not sure whether I need it, so comment it
  #    ignore_changes = ["user_data", "tags"]
  #  }
  #
  #  root_block_device {
  #    volume_size           = "100"
  #    volume_type           = "gp2"
  #    delete_on_termination = false
  #  }
}

output "rstudio_ec2_ip" {
  value = "${aws_instance.rstudio.private_ip}"
}
