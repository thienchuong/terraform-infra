module "eks" {
  source                                  = "terraform-aws-modules/eks/aws"
  version                                 = "20.5.2"
  cluster_name                            = var.cluster_name
  cluster_version                         = var.cluster_version
  vpc_id                                  = var.vpc_id
  subnet_ids                              = var.subnet_ids
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  enable_irsa                             = var.enable_irsa
  cluster_enabled_log_types               = var.cluster_enabled_log_types
  create_cloudwatch_log_group             = var.create_cloudwatch_log_group
  cluster_addons                          = var.cluster_addons
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  node_security_group_tags                = var.node_security_group_tags
  eks_managed_node_groups                 = var.eks_managed_node_groups
  tags                                    = var.tags
}
