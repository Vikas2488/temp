output grafana_domain_name {
  value       = aws_route53_record.grafana.fqdn
}