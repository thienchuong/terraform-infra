module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = var.bucket
  force_destroy            = var.force_destroy
  object_lock_enabled      = var.object_lock_enabled
  request_payer            = var.request_payer
  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership
  block_public_acls        = var.block_public_acls
  block_public_policy      = var.block_public_policy
  ignore_public_acls       = var.ignore_public_acls
  restrict_public_buckets  = var.restrict_public_buckets
  attach_policy            = var.attach_policy
  tags = var.tags
}
