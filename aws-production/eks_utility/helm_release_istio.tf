# ####################################################################################
# ## Helm release - istio_base
# ####################################################################################
resource "helm_release" "istio_base" {
  name             = "istio-base"
  chart            = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version          = "1.23.0"

}

# ####################################################################################
# ## Helm release - istiod
# ####################################################################################

resource "helm_release" "istiod" {
  name             = "istio"
  chart            = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.23.0"

  set {
    name  = "global.defaultResources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "global.defaultResources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "global.defaultResources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "global.defaultResources.limits.memory"
    value = "300Mi"
  }

  depends_on = [
    helm_release.istio_base
  ]
}

# ####################################################################################
# ## Helm release - istio-ingress-public
# ####################################################################################

resource "helm_release" "istio-ingress" {
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.23.0"

 
  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name = "service.ports[0].name"
    value = "http-status"
  }
  set {
    name = "service.ports[0].port"
    value = "15022"
  }
  set {
    name = "service.ports[0].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[0].targetPort"
    value = "15021"
  }
  set {
    name = "service.ports[0].nodePort"
    value = "32176"
  }
  set {
    name = "service.ports[1].name"
    value = "http2"
  }
  set {
    name = "service.ports[1].port"
    value = "80"
  }
  set {
    name = "service.ports[1].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[1].targetPort"
    value = "80"
  }
  set {
    name = "service.ports[2].name"
    value = "https"
  }
  set {
    name = "service.ports[2].port"
    value = "443"
  }
  set {
    name = "service.ports[2].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[2].targetPort"
    value = "443"
  }
  
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "resources.limits.memory"
    value = "1024Mi"
  }
}

resource "helm_release" "istio-ingress-private" {
  name             = "pri-istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.23.0"

 
  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name = "service.ports[0].name"
    value = "http-status"
  }
  set {
    name = "service.ports[0].port"
    value = "15023"
  }
  set {
    name = "service.ports[0].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[0].targetPort"
    value = "15021"
  }
  set {
    name = "service.ports[0].nodePort"
    value = "32763"
  }
  set {
    name = "service.ports[1].name"
    value = "http2"
  }
  set {
    name = "service.ports[1].port"
    value = "80"
  }
  set {
    name = "service.ports[1].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[1].targetPort"
    value = "80"
  }
  set {
    name = "service.ports[2].name"
    value = "https"
  }
  set {
    name = "service.ports[2].port"
    value = "443"
  }
  set {
    name = "service.ports[2].protocol"
    value = "TCP"
  }
  set {
    name = "service.ports[2].targetPort"
    value = "443"
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "resources.limits.memory"
    value = "1024Mi"
  }

}