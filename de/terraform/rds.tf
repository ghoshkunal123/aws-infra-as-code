resource "aws_db_instance" "rds" {
  identifier              = "${var.rds_identifier}"
  allocated_storage       = 20
  engine                  = "postgres"
#  engine_version          = "9.6.2"
  instance_class          = "${var.rds_instance_class}"
  name                    = "${var.rds_db_name}"
  username                = "${var.rds_user}"
  password                = "${var.rds_password}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  vpc_security_group_ids  = ["${aws_security_group.airflow_rds.id}"]
  backup_retention_period = 0                                        # day
  multi_az                = false
  publicly_accessible     = false
  storage_type            = "gp2"
  storage_encrypted       = true
  skip_final_snapshot     = true
  maintenance_window      = "Sun:23:30-Mon:00:00"
  availability_zone       = "us-west-1a"
  copy_tags_to_snapshot   = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    launcher   = "${var.tag_launcher}"
    env        = "${terraform.workspace}"
    Name       = "${var.rds_tag_Name}"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "fngn-dataeng-rds-${data.aws_vpc.vpc.id}"
  subnet_ids = ["${data.aws_subnet.private1.id}", "${data.aws_subnet.private2.id}"]

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    launcher   = "${var.tag_launcher}"
    env        = "${terraform.workspace}"
    Name       = "${var.rds_tag_Name}"
  }
}

output "rds_address" {
  value = ["${aws_db_instance.rds.address}"]
}
