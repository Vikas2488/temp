####################################################################################
## Helm release metric-server
####################################################################################
resource "helm_release" "metric-server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "6.9.3"
  
  set {
    name  = "apiService.create"
    value = "true"
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "250Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "300Mi"
  }
}

####################################################################################
## Helm release CRD for controller
####################################################################################
resource "helm_release" "aws-alb-controller-crds" {
  count      = var.deploy_aws_albv2_controller ? 1 : 0
  name       = "aws-load-balancer-controller-crds"
  repository = "https://mthoretton.github.io/aws-load-balancer-controller-crds/"
  chart      = "aws-load-balancer-controller-crds"
  version    = "1.3.3"
}

####################################################################################
## Helm release - controller
####################################################################################
resource "helm_release" "aws-alb-controller" {
  count      = var.deploy_aws_albv2_controller ? 1 : 0

  depends_on = [
    helm_release.aws-alb-controller-crds
  ]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.2"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.eks_state.outputs.cluster_name
  }

  set {
    name  = "SubnetsClusterTagCheck"
    value = false
  }

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "ingressClass"
    value = "albv2"
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc_state.outputs.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller-v2"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.service_account_role[0].arn
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "250Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "300Mi"
  }

}


####################################################################################
## Helm release cluster-autoscaler
####################################################################################

resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler" 
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  set {
    name  = "autoDiscovery.clusterName"
    value = data.terraform_remote_state.eks_state.outputs.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.autoscaler_iam_role.role_arn     
  }

  set {
    name  = "awsRegion"
    value = var.region     
  }
  
  set {
    name  = "tolerations[0].key"
    value = "price-type"
  }

  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }

  set {
    name  = "tolerations[0].value"
    value = "ondemand"  # Ensuring the value is a string
  }

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "300Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "400Mi"
  }
}

####################################################################################
## secrets-store-csi-driver-provider-aws
####################################################################################
resource "helm_release" "secret-store-csi-driver" {
  name              = "secrets-store-csi-driver-provider-aws"
  repository        = "local"
  chart             = "../../modules/helm_files/secrets-store-csi-driver-provider-aws"
  namespace         = "kube-system"
  version           = "0.3.4"
  cleanup_on_fail   = true
  recreate_pods     = false
}