resource "aws_security_group" "airflow_ec2" {
  name        = "tf_securityg_airflow_ec2"
  description = "Used by airflow master and workers instances"
  vpc_id      = "${data.aws_vpc.finr_vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "tf_securityg_airflow"
  }

  #ssh-only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}"]
  }

  #Flower_Ports
  ingress {
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}"]
  }

  #postgres
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}"]
  }

  #RabbitMQ
  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}"]
  }

  #RabbitMQ
  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}"]
  }

  #Airflow_Ports
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}"]
  }

  #Airflow_Ports
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "airflow_alb" {
  name        = "tf_securityg_airflow_alb"
  description = "Used by airflow alb"
  vpc_id      = "${data.aws_vpc.finr_vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "tf_https"
  }

  #http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${var.finr_cidr_advisor_center_store}"]
  }

  #https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${var.finr_cidr_advisor_center_store}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "airflow_rds" {
  name        = "tf_securityg_airflow_rds"
  description = "Used by airflow rds"
  vpc_id      = "${data.aws_vpc.finr_vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "tf_PostgrePort"
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    #    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${var.finr_cidr_sn1}", "${var.finr_cidr_sn2}"]
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${data.aws_subnet.finr_private1.cidr_block}", "${data.aws_subnet.finr_private2.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "airflow_redshift" {
  name        = "tf_securityg_airflow_redshift"
  description = "Used by airflow redshift"
  vpc_id      = "${data.aws_vpc.finr_vpc.id}"

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "tf_RedshiftPort"
  }

  ingress {
    from_port = 5439
    to_port   = 5439
    protocol  = "tcp"

    #    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${var.finr_cidr_sn1}"]
    cidr_blocks = ["${var.finr_cidr_10}", "${var.finr_cidr_172}", "${data.aws_subnet.finr_private1.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
