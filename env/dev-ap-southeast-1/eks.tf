locals {
  cluster_name = "cluster-dev"
  env          = "dev"
  account_id   = data.aws_caller_identity.current.account_id
}

module "eks" {
  source = "../../modules/eks"

  cluster_name                             = local.cluster_name
  cluster_version                          = "1.30"
  vpc_id                                   = module.eks-vpc.vpc_id
  subnet_ids                               = module.eks-vpc.private_subnets
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true
  cluster_enabled_log_types                = []
  create_cloudwatch_log_group              = false
  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
        "enableNetworkPolicy" : "true",
      })
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  cluster_security_group_additional_rules = {
    ingress_nodes_karpenter_ports_tcp = {
      description                = "Karpenter readiness"
      protocol                   = "tcp"
      from_port                  = 8443
      to_port                    = 8443
      type                       = "ingress"
      source_node_security_group = true
    }
  }
  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }
  eks_managed_node_groups = {
    worker-dev = {
      bootstrap_extra_args = "--container-runtime containerd --kubelet-extra-args '--max-pods=110'"
      desired_size         = 2
      max_size             = 2
      min_size             = 1
      instance_types       = ["t3.large"]
      ami_type             = "AL2_x86_64"
      capacity_type        = "SPOT"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 1000
            throughput            = 150
            ecrypted              = true
            delete_on_termination = true
          }
        }
      }

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEKSClusterPolicy       = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
      }
      labels = {}

      tags = {
        Terraform = "true"
        Env       = local.env
        Team      = "DevOps"
      }
      taints = {}
    }
  }
  tags = {
    Terraform = "true"
    Env       = local.env
    Team      = "DevOps"
  }
}


# eks authen
module "eks-aws-auth" {
  source                    = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version                   = "~> 20.0"
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.karpenter.node_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    },
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::267583709295:user/tony"
      username = "tony"
      groups   = ["system:masters"]
    },
  ]
}
