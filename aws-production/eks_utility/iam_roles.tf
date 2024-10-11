####################################################################################
## ALBv2_iam_role oidc_assume_role
####################################################################################
data "aws_iam_policy_document" "eks_oidc_assume_role" {
  count      = var.deploy_aws_albv2_controller ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller-v2" # variablies this
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
      ]
      type = "Federated"
    }
  }
}

####################################################################################
## ALBv2 service_account_role
####################################################################################

resource "aws_iam_role" "service_account_role" {
  count      = var.deploy_aws_albv2_controller ? 1 : 0
  name        = "${data.terraform_remote_state.eks_state.outputs.cluster_name}-albv2-iam-role" # give proper name
  description = "Permissions required by the Kubernetes AWS ALB Ingress controller to do it's job."

  force_detach_policies = true

  assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role[0].json
  tags = {
    Name      = format("albv2-controller-%s", data.terraform_remote_state.eks_state.outputs.cluster_name)
    Terraform = true
  }
}

####################################################################################
## Autoscaler_iam_role iam-role
####################################################################################
module "autoscaler_iam_role" {
  source              = "../../modules/iam_roles"
  env                 = var.env
  name                = "autoscaler-role"
  assume_role_policy  = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "${data.terraform_remote_state.eks_state.outputs.oidc_provider_arn}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringEquals": {
              "${data.terraform_remote_state.eks_state.outputs.oidc_provider}:aud": "sts.amazonaws.com",
              "${data.terraform_remote_state.eks_state.outputs.oidc_provider}:sub": "system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"
            }
          }
        }
      ]
    }
  )
  tags = merge(
    local.global_tags,
    {
      "Purpose" : "Creating the cluster autoscaler IAM role for service accounts"
    }
  )
}