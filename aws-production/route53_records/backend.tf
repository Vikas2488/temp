terraform {
  backend "local" {
    path = "../terraform_state/route53_records_state/terraform.tfstate"
  }
}