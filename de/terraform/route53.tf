resource "aws_route53_record" "airflow" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.route53_airflow_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.airflow.dns_name}"
    zone_id                = "${aws_alb.airflow.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "flower" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.route53_flower_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.flower.dns_name}"
    zone_id                = "${aws_alb.flower.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mssqldb" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.route53_mssqldb_domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${lookup(var.on-promise_mssqldb_ip, terraform.workspace)}"]
}

resource "aws_route53_record" "mssqlauxdb" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.route53_mssqlauxdb_domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${lookup(var.on-promise_mssqlauxdb_ip, terraform.workspace)}"]
}

output "mssqldb_fqdn" {
  value = "${aws_route53_record.mssqldb.fqdn}"
}

output "mssqlauxdb_fqdn" {
  value = "${aws_route53_record.mssqlauxdb.fqdn}"
}
