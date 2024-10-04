
################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.23.0"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true
  cluster_version                 = var.cluster_version
  iam_role_use_name_prefix        = false

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # External encryption key
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }

  iam_role_additional_policies = {
    additional = module.node_additional_policy.arn
  }

  vpc_id                   = data.terraform_remote_state.vpc_state.outputs.vpc_id
  subnet_ids               = [data.terraform_remote_state.vpc_state.outputs.private_subnet_1_id, data.terraform_remote_state.vpc_state.outputs.private_subnet_2_id]
  control_plane_subnet_ids = [data.terraform_remote_state.vpc_state.outputs.private_subnet_1_id, data.terraform_remote_state.vpc_state.outputs.private_subnet_2_id]

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
    ingress_https = {
      description                = "Allow HTTPS traffic"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      cidr_blocks                 = ["0.0.0.0/0"]
  }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_nodes_ephemeral_ports_tcp = {
      description                 = "Istio port to access kubernetes Api"
      protocol                    = "tcp"
      from_port                   = 15017
      to_port                     = 15017
      type                        = "ingress"
      cidr_blocks                 = ["0.0.0.0/0"]
    }
  }
  node_security_group_description = "eks additional security group"
  node_security_group_name        = "eks-additional-security-group"
  node_security_group_tags        = merge(local.tags,{
    "karpenter.sh/discovery" = local.name
  })



  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  # create_cluster_primary_security_group_tags = true
  
  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    karpenter = {
      instance_types = ["t3a.small"]

      min_size     = 2
      max_size     = 4
      desired_size = 2

      taints = {
        # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
        # The pods that do not tolerate this taint should run on nodes created by Karpenter
        addons = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        },
      }
    }
  }

  tags = merge(local.tags)
}