provider "aws" {
  alias = "route53"
}

provider "aws" {
  alias = "acm"
}
module "chuong-click" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name            = "chuong.click"
  subject_alternative_names = [
    "chuong.click",
    "*.chuong.click"
  ]

  create_route53_records = false
  validation_method      = "DNS"

  validation_record_fqdns = module.chuong-click-record.validation_route53_record_fqdns

  tags = {
    Env       = local.env
    Terraform = "true"
  }
}

module "chuong-click-record" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  providers = {
    aws = aws.route53
  }

  create_certificate          = false
  create_route53_records_only = true
  validation_method = "DNS"
  distinct_domain_names = module.chuong-click.distinct_domain_names
  zone_id = module.zones.route53_zone_zone_id["chuong.click"]
  acm_certificate_domain_validation_options = module.chuong-click.acm_certificate_domain_validation_options
}
