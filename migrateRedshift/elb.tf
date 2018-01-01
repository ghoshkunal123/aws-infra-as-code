resource "aws_alb" "airflow" {
  name = "${var.alb_airflow_name}" 
  subnets = ["${var.subnet_private1_id}", "${var.subnet_private2_id}"]
  security_groups = ["${var.aws_security_group_http_https_id}"]
  internal = true
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.alb_airflow_name}"
  }
}
 resource "aws_alb_listener" "airflow_http" {
     load_balancer_arn = "${aws_alb.airflow.arn}"
     port = "80"
     protocol = "HTTP"

     default_action {
         target_group_arn = "${aws_alb_target_group.airflow.arn}"
         type = "forward"
     }
 }

resource "aws_alb_target_group" "airflow" {
  name     = "${var.targetgroup_airflow_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
#  target_type = "instance" #default, do not need to set
  health_check {
    healthy_threshold = "${var.elb_healthy_threshold}"
    unhealthy_threshold = "${var.elb_unhealthy_threshold}"
    timeout = "${var.elb_timeout}"
    path = "/static/pin_100.png"
    interval = "${var.elb_interval}"
  }
}
resource "aws_alb_target_group_attachment" "airflow" {
    target_group_arn = "${aws_alb_target_group.airflow.arn}"
    target_id        = "${aws_instance.master1.id}"
    port             = 8080
}
resource "aws_alb" "flower" {
  name = "${var.alb_flower_name}"
  subnets = ["${var.subnet_private1_id}", "${var.subnet_private2_id}"]
  security_groups = ["${var.aws_security_group_http_https_id}"]
  internal = true
  tags = {
      app = "${var.tag_app}"
      Project = "${var.tag_Project}"
      Owner = "${var.tag_Owner}"
      CostCenter = "${var.tag_CostCenter}"
      env = "${var.tag_env}"
      Name = "${var.alb_flower_name}"
  }
}
resource "aws_alb_listener" "flower_http" {
     load_balancer_arn = "${aws_alb.flower.arn}"
     port = "80"
     protocol = "HTTP"

     default_action {
         target_group_arn = "${aws_alb_target_group.flower.arn}"
         type = "forward"
     }
}

resource "aws_alb_target_group" "flower" {
  name     = "${var.targetgroup_flower_name}"
  port     =5555 
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    healthy_threshold = "${var.elb_healthy_threshold}"
    unhealthy_threshold = "${var.elb_unhealthy_threshold}"
    timeout = "${var.elb_timeout}"
    path = "/"
    interval = "${var.elb_interval}"
  }
}
resource "aws_alb_target_group_attachment" "flower" {
    target_group_arn = "${aws_alb_target_group.flower.arn}"
    target_id        = "${aws_instance.master1.id}"
    port             = 5555
}