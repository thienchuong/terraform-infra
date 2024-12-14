module "loki-logs-dev" {
  source = "../../modules/s3"

  bucket                   = "loki-${local.env}-${local.account_id}"
  force_destroy            = "false"
  object_lock_enabled      = "false"
  request_payer            = "BucketOwner"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
  attach_policy            = false

  tags = {
    Terraform = "true"
    App       = "loki"
    Env       = local.env
    Team      = "DevOps"
    Name      = "loki-logs-${local.env}"
  }
}
