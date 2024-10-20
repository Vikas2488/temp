resource "helm_release" "argocd-apps" {
  name       = "argocd-apps"
  depends_on = [
    helm_release.argocd-apps-project
  ]
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.0"
  namespace  = "argocd"
  values = [
    "${file("./helm-values/argocd-apps/argocd-apps-values.yaml")}"
  ]
}