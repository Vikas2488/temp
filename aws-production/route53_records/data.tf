####################################################################################
## Remote State
####################################################################################

data "terraform_remote_state" "route53_acm_state" {
  backend = "local"

  config = {
    path = "../terraform_state/route53_acm_state/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_state" {
  backend = "local"

  config = {
    path = "../terraform_state/eks_state/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_utility_ingress_domain_state" {
  backend = "local"

  config = {
    path = "../terraform_state/eks_utility_ingress_domain_state/terraform.tfstate"
  }
}

####################################################################################
## Availability Zones
####################################################################################

data "aws_availability_zones" "available" {}

####################################################################################
## EKS Cluster Data
####################################################################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name            = data.terraform_remote_state.eks_state.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
    name          = data.terraform_remote_state.eks_state.outputs.cluster_name
}