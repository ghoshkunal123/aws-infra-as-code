resource "aws_redshift_subnet_group" "analytics" {
  name       = "${var.rs_subnet_group_name}"
  subnet_ids = ["${data.aws_subnet.private1.id}"]

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_office}-${terraform.workspace}"
    Name       = "${var.rs_tag_Name}"
  }
}

resource "aws_redshift_parameter_group" "analytics" {
  name   = "${var.rs_parameter_group_name}"
  family = "redshift-1.0"

  parameter {
    name  = "datestyle"
    value = "ISO,MDY"
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "extra_float_digits"
    value = "0"
  }

  parameter {
    name  = "max_cursor_result_set_size" #in fact, this parameter is deprecated
    value = "0"
  }

  parameter {
    name  = "query_group"
    value = "default"
  }

  parameter {
    name  = "require_ssl"
    value = "true"
  }

  parameter {
    name  = "search_path"
    value = "$user,public"
  }

  parameter {
    name  = "statement_timeout"
    value = "0"
  }

  parameter {
    name  = "use_fips_ssl"
    value = "false"
  }
}

resource "aws_redshift_cluster" "analytics" {
  cluster_identifier           = "${var.rs_cluster_identifier}"
  database_name                = "${var.rs_db_name}"
  master_username              = "${var.rs_master_user}"
  master_password              = "${var.rs_master_password}"
  node_type                    = "${var.rs_node_type}"
  cluster_type                 = "${var.rs_cluster_type}"
  number_of_nodes              = "${lookup(var.rs_number_of_nodes, terraform.workspace)}"
  preferred_maintenance_window = "Thu:11:30-Thu:12:00"
  cluster_parameter_group_name = "${aws_redshift_parameter_group.analytics.name}"
  availability_zone            = "us-west-1a"
  vpc_security_group_ids       = ["${aws_security_group.airflow_redshift.id}"]
  cluster_subnet_group_name    = "${aws_redshift_subnet_group.analytics.id}"

  lifecycle {
    prevent_destroy = true
  }

  publicly_accessible  = false
  encrypted            = true
  enhanced_vpc_routing = false
  skip_final_snapshot  = true
  iam_roles            = ["${data.aws_iam_role.redshift.arn}"]

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${var.tag_office}-${terraform.workspace}"
    Name       = "${var.rs_tag_Name}"
  }
}

output "redshift_endpoint" {
  value = "${aws_redshift_cluster.analytics.endpoint}"
}

output "redshift_param_group_id" {
  value = "${aws_redshift_parameter_group.analytics.id}"
}
