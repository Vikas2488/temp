# Domain Module
module "domain_validation" {
  source  = "../../modules/domain/route53_acm_validation"
  domain_name        = var.domain_name
  validate_certificate = var.validate_certificate
}