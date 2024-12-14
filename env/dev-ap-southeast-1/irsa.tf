locals {
  karpenter-ns         = "karpenter"
  k8s-karpenter-sva    = "karpenter"
  external-dns-ns      = "external-dns"
  k8s-external-dns-sva = "external-dns"
  k8s-loki-sva         = "loki"
  loki-ns              = "loki"
}


################################################################################
# karpenter policy
################################################################################
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.5.2"

  cluster_name = module.eks.cluster_name

  enable_irsa                     = true
  create_iam_role                 = true
  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["${local.karpenter-ns}:${local.k8s-karpenter-sva}"]

  node_iam_role_arn = module.eks.eks_managed_node_groups["worker-dev"].iam_role_arn
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEKSClusterPolicy       = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }

  tags = {
    Terraform = "true"
    Env       = local.env
  }
}

################################################################################
# External dns policy
################################################################################
module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name                     = "external-dns-${local.env}"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [""]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.external-dns-ns}:${local.k8s-external-dns-sva}"]
    }
  }
  tags = {
    Terraform = "true"
    Env       = local.env
  }
}

################################################################################
# Loki logs policy
################################################################################
resource "aws_iam_policy" "loki-logs-dev" {

  name        = "loki-logs-${local.env}"
  description = "Policy for Loki to access S3 buckets."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLoki",
        Effect = "Allow"
        Action = ["s3:*"]
        Resource = [
          "arn:aws:s3:::${module.loki-logs-dev.s3_bucket_id}/*",
          "arn:aws:s3:::${module.loki-logs-dev.s3_bucket_id}"
        ]
      }
    ]
  })
}

module "loki_logs_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = "loki-logs-${local.env}"
  role_policy_arns = {
    main = aws_iam_policy.loki-logs-dev.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.loki-ns}:${local.k8s-loki-sva}"]
    }
  }
  tags = {
    Terraform = "true"
    Env       = local.env
  }
}
