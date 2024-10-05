####################################################################################
## efs-csi-driver iam-role
####################################################################################

module "efs_csi_driver_role" {
  source       = "../../modules/iam_roles"  
  env          = var.env
  name         = "efs-csi"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "${module.eks.oidc_provider_arn}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringEquals": {
              "${module.eks.oidc_provider}:aud": "sts.amazonaws.com",
              "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
            }
          }
        }
      ]
    }
  )
  tags = merge(
    local.global_tags,
    {
      "Purpose" : "Creating the EBS CSI driver IAM role for service accounts"
    }
  )
}

####################################################################################
## ebs-csi-driver iam-role
####################################################################################

module "ebs_csi_driver_role" {
  source       = "../../modules/iam_roles"  
  env          = var.env
  name         = "ebs-csi"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "${module.eks.oidc_provider_arn}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringEquals": {
              "${module.eks.oidc_provider}:aud": "sts.amazonaws.com",
              "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            }
          }
        }
      ]
    }
  )
  tags = merge(
    local.global_tags,
    {
      "Purpose" : "Creating the EBS CSI driver IAM role for service accounts"
    }
  )
}