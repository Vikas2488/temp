################################################################################
# Output
################################################################################

output "route53_zone_ns" {
  value = module.domain_validation.route53_zone_ns
}

output "route53_zone_arn" {
  value = module.domain_validation.route53_zone_arn
}

output "route53_zone_id" {
  value = module.domain_validation.route53_zone_id
}

output "acm_certificate_arn" {
  value = module.domain_validation.acm_certificate_arn
}

output "acm_certificate_status" {
  value = module.domain_validation.acm_certificate_status
}