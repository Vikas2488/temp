################################################################################
# IAM Role for Service Account (IRSA)
################################################################################

output "irsa_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role for service accounts"
  value       = try(module.karpenter.irsa_arn, null)
}

################################################################################
# Node Termination Queue
################################################################################

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = try(module.karpenter.queue_arn, null)
}

output "queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = try(module.karpenter.queue_name, null)
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = try(module.karpenter.queue_url, null)
}

################################################################################
# Karpenter controller IAM Role
################################################################################

output "karpenter_iam_role_name" {
  description = "The name of the controller IAM role"
  value       = module.karpenter.iam_role_name
}

output "karpenter_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the controller IAM role"
  value       = module.karpenter.iam_role_arn
}

output "karpenter_iam_role_unique_id" {
  description = "Stable and unique string identifying the controller IAM role"
  value       = module.karpenter.iam_role_unique_id
}