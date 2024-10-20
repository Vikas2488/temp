################################################################################
# Common Module
################################################################################

module "common" {
  source        = "../../iac-terraform-modules/common"
  env           = var.env
  name          = var.name
  tags          = var.tags
}