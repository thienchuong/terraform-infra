module "chuong-click" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name            = "chuong.click"
  zone_id = module.zones.route53_zone_zone_id["chuong.click"]
  create_route53_records = false
  validation_method      = "DNS"

  subject_alternative_names = [
    "chuong.click",
    "*.chuong.click"
  ]

  wait_for_validation = true

  tags = {
    Env       = local.env
    Terraform = "true"
  }
}
