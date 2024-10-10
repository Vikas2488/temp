################################################################################
##  NameSpace on EKS
################################################################################

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }
    labels = {
      "istio-injection" = "enabled" 
    }
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "argocd_system" {
  metadata {
    annotations = {
      name = "argocd"
    }
    labels = {
      "istio-injection" = "enabled" 
    }
    name = "argocd"
  }
}

resource "kubernetes_namespace" "development" {
  metadata {
    annotations = {
      name = "development"
    }
    labels = {
      "istio-injection" = "enabled" 
    }
    name = "development"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {
    annotations = {
      name = "production"
    }
    labels = {
      "istio-injection" = "enabled" 
    }
    name = "production"
  }
}