# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1
resource "aws_route53_record" "argo-cd" {
  depends_on = [
    kubernetes_ingress_v1.aws-ingress-public
  ]
  zone_id = data.terraform_remote_state.route53_acm_state.outputs.route53_zone_id
  name    = "argo-cd"
  type    = "CNAME"
  ttl     = 300
  records = [kubernetes_ingress_v1.aws-ingress-public.status.0.load_balancer.0.ingress.0.hostname]
}