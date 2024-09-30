###################################################################################
#### local variables
####################################################################################

locals {
  name  = var.name
  env           = var.env
  owner         = var.owner
  global_tags   = {
    Environment = local.env
    Creator     = local.owner
    Product     = local.name
    Terraform   = true
    service-cost-tag = "vpc-cost"
  }
}
###################################################################################
#### local variables
####################################################################################

locals {
    name        = "${replace(module.common.id, "_", "-")}"
    region      = var.region
    tags        = local.global_tags

}
###################################################################################
#### local variables vpc
####################################################################################

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}