####################################################################################
## Helm release karpenter
####################################################################################

resource "helm_release" "karpenter_crd" {
  name             = "karpenter-crd"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  namespace        = "karpenter"
  version          = "1.0.6" # https://gallery.ecr.aws/karpenter/karpenter
  cleanup_on_fail  = true
  create_namespace = true
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  namespace        = "karpenter"
  version          = "1.0.6" 
  cleanup_on_fail  = true
  create_namespace = true
  recreate_pods    = true

  values = [
    <<-EOT
    settings:
      clusterName: ${data.terraform_remote_state.eks_state.outputs.cluster_name}
      clusterEndpoint: ${data.terraform_remote_state.eks_state.outputs.cluster_endpoint}
      interruptionQueueName: ${module.karpenter.queue_name}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter.iam_role_arn} 
    EOT
  ]

  set {
    name  = "controller.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "1024Mi"
  }

  set {
    name  = "webhook.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "webhook.resources.requests.memory"
    value = "200Mi"
  }

  set {
    name  = "webhook.resources.limits.cpu"
    value = "250m"
  }

  set {
    name  = "webhook.resources.limits.memory"
    value = "300Mi"
  }
  depends_on = [
    module.karpenter,
    helm_release.karpenter_crd
  ]
}