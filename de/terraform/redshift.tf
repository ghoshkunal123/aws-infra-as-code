resource "aws_redshift_subnet_group" "analytics" {
  name       = "tf-redshift-us-west-1a"
  subnet_ids = ["${lookup(var.subnet_private1_id, terraform.workspace)}"]
}

resource "aws_redshift_cluster" "analytics" {
  cluster_identifier           = "tf-fngn-${terraform.workspace}-redshift-cluster"
  database_name                = "${var.rs_db_name}"
  master_username              = "${var.rs_master_user}"
  master_password              = "${var.rs_master_password}"
  node_type                    = "${var.rs_node_type}"
  cluster_type                 = "${var.rs_cluster_type}"
  number_of_nodes              = "${var.rs_number_of_nodes}"
  preferred_maintenance_window = "Thu:11:30-Thu:12:00"
  cluster_parameter_group_name = "de-parameter-group"
  availability_zone            = "us-west-1a"
  vpc_security_group_ids       = ["${aws_security_group.airflow_redshift.id}"]
  cluster_subnet_group_name    = "${aws_redshift_subnet_group.analytics.id}"

  publicly_accessible  = false
  encrypted            = true
  enhanced_vpc_routing = false
  skip_final_snapshot  = true
  iam_roles            = ["${var.rs_iam_role}"]

  tags = {
    app        = "${var.tag_app}"
    Project    = "${var.tag_Project}"
    Owner      = "${var.tag_Owner}"
    CostCenter = "${var.tag_CostCenter}"
    env        = "${terraform.workspace}"
    Name       = "${var.rs_tag_Name}"
  }
}
