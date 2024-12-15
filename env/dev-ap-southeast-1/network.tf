################################################################################
# VPC
################################################################################

module "eks-vpc" {
  source = "../../modules/network"
  vpcs = [
    {
      name                   = "eks-vpc"
      cidr_block             = "10.12.0.0/16"
      azs                    = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
      public_subnets         = ["10.12.80.0/20", "10.12.96.0/20", "10.12.112.0/20"]
      database_subnets       = ["10.12.48.0/20", "10.12.64.0/20"]
      private_subnets        = ["10.12.0.0/20", "10.12.16.0/20", "10.12.32.0/20"]
    }
  ]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  cluster_name = local.cluster_name
  env          = local.env
}
