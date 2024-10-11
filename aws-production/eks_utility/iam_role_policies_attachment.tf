################################################################################
##  ALBv2 iam role policy attachments
################################################################################

module "albv2_controller_attach_to_instance_role_attachment" {
  source                        = "../../modules/iam_role_policy_attachments"
  role_name                     = aws_iam_role.service_account_role[0].name
  custom_role_policy_arns       = [
                                    module.albv2_controller_policy.arn
                                  ]
}

################################################################################
##  Autoscaler iam role policy attachments
################################################################################

module "autoscaler_role_policy_attachment" {
  source                        = "../../modules/iam_role_policy_attachments"
  role_name                     = module.autoscaler_iam_role.role_name
  custom_role_policy_arns       = [
                                    aws_iam_policy.eks_cluster_autoscaler.arn
                                  ]
}