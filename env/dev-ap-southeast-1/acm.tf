module "chuong-click" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name            = "chuong.click"
  create_route53_records = false
  validation_method      = "DNS"

  subject_alternative_names = [
    "chuong.click",
    "*.chuong.click"
  ]

  wait_for_validation = false

  tags = {
    Environment = "${local.env}"
    Terraform   = "true"
  }
}
