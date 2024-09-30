################################################################################
# Common Module
################################################################################

module "common" {
  source        = "../../iac-terraform-modules/common"
  name  = var.product_name
  env           = var.env
  name          = var.name
  tags          = var.tags
}