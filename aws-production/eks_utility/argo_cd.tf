resource "helm_release" "argocd" {
  name       = "argocd"
  depends_on = [
    kubernetes_namespace.argocd_system
  ]
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = "argocd"
  values = [
    "${file("./helm-values/argo-values.yaml")}"
  ]
}

resource "helm_release" "argo-istio" {
  name      = "argo-istio"
  namespace = "argocd"
  chart = "../../helm-charts/argo-istio"
  set {
    name  = "service.dns"
    value = "argo-cd.${var.domain_name}"
  }
}