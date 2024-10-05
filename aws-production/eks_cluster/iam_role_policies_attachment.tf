################################################################################
##  EFS CSI Driver EKS role policy attachments 
################################################################################

data "aws_iam_policy" "efs_csi_driver" {
  name = "AmazonEFSCSIDriverPolicy"
}

module "efs_csi_driver_policy_role_attachment" {
  source                        = "../../modules/iam_role_policy_attachments"
  role_name                     = module.efs_csi_driver_role.role_name
  custom_role_policy_arns       = [
                                    data.aws_iam_policy.efs_csi_driver.arn
                                ]
}

################################################################################
##  EBS CSI Driver EKS role policy attachments 
################################################################################

data "aws_iam_policy" "ebs_csi_driver" {
  name = "AmazonEBSCSIDriverPolicy"
}

module "ebs_csi_driver_policy_role_attachment" {
  source                        = "../../modules/iam_role_policy_attachments"
  role_name                     = module.ebs_csi_driver_role.role_name
  custom_role_policy_arns       = [
                                    data.aws_iam_policy.ebs_csi_driver.arn
                                ]
}