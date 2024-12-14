locals {
  cluster_name = "cluster-dev"
  env          = "dev"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = local.cluster_name
  cluster_version                         = "1.30"
  vpc_id                                  = module.eks-vpc.vpc_id
  subnet_ids                              = module.eks-vpc.subnet_ids
  cluster_endpoint_public_access          = true
  cluster_endpoint_private_access         = true
  enable_irsa                             = true
  cluster_enabled_log_types               = false
  create_cloudwatch_log_group             = false
  cluster_addons                          = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION  = "true"
          WARM_PREFIX_TARGET        = "1"
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

    ebs-csi-driver = {
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
  node_security_group_tags          = {
    "karpenter.sh/discovery" = var.cluster_name
  }
  eks_managed_node_groups                 = {
    worker-nonprod = {
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
        # route53 full access
        AmazonRoute53FullAccess = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonRoute53FullAccess"
        AmazonEKSClusterPolicy        = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
      }
      labels = {
        "lifecycle" = "OnDemand"
      }

      tags = {
        Terraform = "true"
        Env       = "nonprod"
        Name      = "eks-nonprod"
        Team      = "DevOps"
      }
      taints = {}
    }
  }
  tags                                    = var.tags
  
}
