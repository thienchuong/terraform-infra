output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "The Amazon Resource Name (ARN) of the OIDC Identity Provider for the cluster"
  value       = module.eks.oidc_provider_arn
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with your cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_managed_node_groups" {
  description = "List of managed node groups"
  value       = module.eks.eks_managed_node_groups
}
