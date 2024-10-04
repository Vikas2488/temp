module "eks_aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.23.0"
  
  depends_on = [module.eks]

  manage_aws_auth_configmap = true
  
}