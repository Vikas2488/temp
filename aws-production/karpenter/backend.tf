terraform {
  backend "local" {
    path = "../terraform_state/karpenter_state/terraform.tfstate"
  }
}