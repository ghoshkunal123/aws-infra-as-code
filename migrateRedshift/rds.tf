resource "aws_db_instance" "db" {
  identifier            =  "${var.rds_identifier}"
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "9.6.2"
  instance_class        = "${var.rds_instance_class}"
  name                  = "${var.rds_name}"
  username              = "${var.rds_user}"
  password              = "${var.rds_password}"
  db_subnet_group_name  = "${var.rds_subnet_group_name}"
  vpc_security_group_ids = ["${aws_security_group.airflow_rds.id}"]
  backup_retention_period  = 0 # day
  multi_az              = false
  publicly_accessible   = false
  storage_type          = "gp2"
  storage_encrypted     = true
  skip_final_snapshot   = true
  maintenance_window    = "Sun:23:30-Mon:00:00"
  availability_zone     = "us-west-1a"
  copy_tags_to_snapshot = true
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.rds_tag_Name}"     
  }
}
