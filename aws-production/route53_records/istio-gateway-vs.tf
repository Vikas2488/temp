################################
##### Kube Prometheus Stack #################################
################################

resource "helm_release" "kube-prometheus-stack-istio" {
  name      = "kube-prometheus-stack-istio"
  namespace = "observability"
  chart = "../../helm-charts/istio-vs-gateway"
  set {
    name  = "service.namespace"
    value = "observability"
  }
  set {
    name  = "service.dns"
    value = "grafana.${var.domain_name}"
  }
  set {
    name  = "service.gateway.name"
    value = "http-gateway-kps"
  }
  set {
    name  = "service.destination.name"
    value = "kube-prometheus-stack-grafana"
  }
  set {
    name  = "service.virtualservice"
    value = "kps-vs"
  }
}