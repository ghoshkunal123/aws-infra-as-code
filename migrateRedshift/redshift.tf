resource "aws_redshift_subnet_group" "perf" {
  name       = "tf-perf-us-west-1a"
  subnet_ids = ["${var.subnet_private1_id}"]
}
resource "aws_redshift_cluster" "perf" {
  cluster_identifier = "${var.rs_cluster_name}"
  database_name      = "${var.dbname}"
  master_username    = "${var.rs_master_user}" 
  master_password    = "${var.rs_master_password}"
  node_type          = "${var.rs_node_type}"
  cluster_type       = "${var.rs_cluster_type}"
  number_of_nodes    = "${var.rs_number_of_nodes}" 
  preferred_maintenance_window  = "Thu:11:30-Thu:12:00" 
  cluster_parameter_group_name  = "de-parameter-group"
  availability_zone  = "us-west-1a"
  vpc_security_group_ids = ["${var.rs_vpc_security_group_id}"]
  cluster_subnet_group_name = "${aws_redshift_subnet_group.perf.id}"

  publicly_accessible = false
  encrypted          = true
  enhanced_vpc_routing  = false
  skip_final_snapshot  = true
  iam_roles          = ["${var.rs_iam_role}"] 
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.rs_tag_Name}"    
  }
}