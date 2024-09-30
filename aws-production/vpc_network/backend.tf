terraform {
  backend "local" {
    path = "../terraform_state/vpc_state/terraform.tfstate"
  }
}