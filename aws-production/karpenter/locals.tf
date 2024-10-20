###################################################################################
#### local variables
####################################################################################
locals {
  env           = var.env
  owner         = var.owner
  global_tags   = {
    Environment = local.env
    Creator     = local.owner
    Terraform   = true
  }
}

locals {
    name        = "${replace(module.common.id, "_", "-")}"
    region      = var.region
    tags        = local.global_tags
}