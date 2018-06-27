resource "aws_security_group" "rstudio" {
  name        = "${var.tag_SG_Name_rstudio}"
  description = "used by analytics office rstudio ec2, terraform controlled"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
    Name       = "${var.tag_SG_Name_rstudio}"
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

# should be the same as allowLanDesk in vpc vpc-2205a647
resource "aws_security_group" "allowLanDesk" {
  name        = "${var.tag_SG_Name_allowLanDesk}"
  description = "used by analytics office rstudio ec2 to comm w. on prem LanDesk Server for windows patch install, terraform controlled"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
    Name       = "${var.tag_SG_Name_allowLanDesk}"
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 137
    to_port     = 137
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 139
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 4343
    to_port     = 4343
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 5007
    to_port     = 5007
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 9535
    to_port     = 9535
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 9593
    to_port     = 9595
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 9971
    to_port     = 9972
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 9982
    to_port     = 9982
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 12174
    to_port     = 12176
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 16992
    to_port     = 16994
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 33354
    to_port     = 33354
    protocol    = "tcp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 67
    to_port     = 69
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 1758
    to_port     = 1759
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 401
    to_port     = 401
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 9535
    to_port     = 9535
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 33354
    to_port     = 33355
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  ingress {
    from_port   = 38293
    to_port     = 38293
    protocol    = "udp"
    cidr_blocks = ["10.11.0.101/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# should be the same as fe-ad-communicatio in vpc vpc-2205a647
resource "aws_security_group" "fe-ad-comm" {
  name        = "${var.tag_SG_Name_fe-ad-comm}"
  description = "used by analytics office rstudio ec2 for FE AD domain join, terraform controlled"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_env}"
    Name       = "${var.tag_SG_Name_fe-ad-comm}"
  }

  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 138
    to_port     = 138
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 464
    to_port     = 464
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 464
    to_port     = 464
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 49152
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 49152
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 3268
    to_port     = 3269
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "udp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  ingress {
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = ["10.131.14.0/24", "10.131.15.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
