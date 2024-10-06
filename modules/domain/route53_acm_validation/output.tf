output "acm_certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "acm_certificate_status" {
  value = aws_acm_certificate.this.status
}

output "route53_zone_ns" {
  value = aws_route53_zone.this.name_servers
}

output "route53_zone_arn" {
  value = aws_route53_zone.this.arn
}

output "route53_zone_id" {
  value = aws_route53_zone.this.zone_id
}