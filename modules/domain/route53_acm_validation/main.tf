resource "aws_route53_zone" "this" {
  name = var.domain_name
}


resource "aws_acm_certificate" "this" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "this" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.this.zone_id
  ttl = 300
}

resource "aws_acm_certificate_validation" "this" {
  count = var.validate_certificate ? 1 : 0
  certificate_arn           = aws_acm_certificate.this.arn
  validation_record_fqdns   = [aws_route53_record.this.fqdn]
}



