output "role_arn" {
  description = "The ARN of IAM Role"
  value       = aws_iam_role.iam_role.arn
}

output "unique_id" {
  description = "The ARN Unique ID of IAM Role"
  value       = aws_iam_role.iam_role.unique_id
}

output "role_name" {
  description = "The name of the role."
  value       = aws_iam_role.iam_role.name
}