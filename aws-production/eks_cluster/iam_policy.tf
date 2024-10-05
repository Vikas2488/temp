################################################################################
##  Additional_node_policy
################################################################################
module "node_additional_policy" {
  source       = "../../modules/iam_policy"
  name         = "${local.name}-additional"
  env          = var.env
  tags = merge(
    local.global_tags,
    {
      "Purpose" : "node-additional in EKS"
    }
  )
  iam_policy_doc_json = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:Describe*",
          ],
          "Resource": "*"
        }
      ]
    }
  )
}