module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                   = var.vpcs[0].name
  cidr                   = var.vpcs[0].cidr_block
  azs                    = var.vpcs[0].azs
  public_subnets         = var.vpcs[0].public_subnets
  database_subnets       = var.vpcs[0].database_subnets
  private_subnets        = var.vpcs[0].private_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Terraform"                                 = true
    "Environment"                               = "${var.env}"
  }

  # route table tags
  public_route_table_tags = merge(
    {
      "Terraform" = true
      "Name"      = "${var.cluster_name}-public-route"
    }
  )

  private_route_table_tags = merge(
    {
      "Terraform" = true
      "Name"      = "${var.cluster_name}-private-route"
    }
  )

  database_route_table_tags = merge(
    {
      "Terraform" = true
      "Name"      = "${var.cluster_name}-database-route"
    }
  )
  # subnet tags
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    "Terraform"                                 = "true"
    "Environment"                               = "${var.env}"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    "Terraform"                                 = "true"
    "Environment"                               = "${var.env}"
  }
  database_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
    "Terraform"                                 = "true"
    "Environment"                               = "${var.env}"
    "Name"                                      = "database-subnet"
  }
}
