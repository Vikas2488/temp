data "terraform_remote_state" "vpc_state" {
  backend = "local"

  config = {
    path = "../terraform_state/vpc_state/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_ami" "eks_default" {
  most_recent     = true
  owners          = ["amazon"]
  filter {
    name          = "name"
    values        = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}

data "aws_eks_cluster" "cluster" {
  name            = local.name
  depends_on      = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
    name          = module.eks.cluster_name
}