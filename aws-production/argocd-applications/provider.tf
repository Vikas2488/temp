terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.72.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.16.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks_state.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_state.outputs.cluster_certificate_authority_data)
  

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_state.outputs.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                    = data.terraform_remote_state.eks_state.outputs.cluster_endpoint
    cluster_ca_certificate  = base64decode(data.terraform_remote_state.eks_state.outputs.cluster_certificate_authority_data)
    
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_state.outputs.cluster_name]
    }
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
  apply_retry_count      = 5
  host                   = data.terraform_remote_state.eks_state.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_state.outputs.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_state.outputs.cluster_name]
  }
}