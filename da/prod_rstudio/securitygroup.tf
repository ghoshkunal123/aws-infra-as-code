resource "aws_security_group" "rstudio" {
  name        = "analytics-rstudio-securitygroup"
  description = "used by analytics office rstudio ec2, terraform controlled"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
    Name       = "${var.tag_SG_Name}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_10}", "${var.cidr_172}"]
  }

  #rdp
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_10}", "${var.cidr_172}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
