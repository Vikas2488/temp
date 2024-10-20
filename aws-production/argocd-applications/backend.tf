terraform {
  backend "local" {
    path = "../terraform_state/argocd_apps/terraform.tfstate"
  }
}