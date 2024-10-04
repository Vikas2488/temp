terraform {
  backend "local" {
    path = "../terraform_state/eks_state/terraform.tfstate"
  }
}