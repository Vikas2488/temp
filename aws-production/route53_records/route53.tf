# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1
resource "aws_route53_record" "grafana" {
  zone_id = data.terraform_remote_state.route53_acm_state.outputs.route53_zone_id
  name    = "grafana"
  type    = "CNAME"
  ttl     = 300
  records = [data.terraform_remote_state.eks_utility_ingress_domain_state.outputs.load_balancer_hostname]
}