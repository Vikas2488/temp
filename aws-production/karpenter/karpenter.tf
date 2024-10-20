###############################################################################
## Karpenter Module
###############################################################################

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.24.0"
  iam_role_use_name_prefix      = true
  enable_irsa                   = true
  cluster_name                  = data.terraform_remote_state.eks_state.outputs.cluster_name
  irsa_oidc_provider_arn        = data.terraform_remote_state.eks_state.outputs.oidc_provider_arn
  enable_pod_identity             = true
  create_pod_identity_association = true
  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags                          = local.tags
  enable_spot_termination       = true
}
