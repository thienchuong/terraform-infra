# public hosted zone
module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.11.0"

  zones = {
    "chuong.click" = {
      comment = "chuong.click public hosted zone"
      tags = {
        Env       = local.env
        Terraform = "true"
      }
    }
  }
  tags = {
    Terraform = "true"
    Env       = local.env
  }
}

# verify owner of domain chuong.click
resource "aws_route53_record" "chuong-click" {
  name    = "${module.chuong-click.distinct_domain_names}"
  records = ["${module.chuong-click.validation_route53_record_fqdns}"]
  ttl     = "300"
  type    = "CNAME"
  zone_id = module.zones.route53_zone_zone_id["chuong.click"]
}
