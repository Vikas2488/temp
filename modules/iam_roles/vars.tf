variable "env" {
  type        = string
  description = "env (e.g. `non-prod`, `prod`)"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `utility-cluster`, `non-prod-cluster` or `prod-cluster`)"
}

variable "tags" {
  type        = map(string)
}

variable "assume_role_policy" {
  description = "The Role policy for the Principal you want to attach"
  type        = string
  default     = false
}

variable "custom_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "path" {
  description = "path to the role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Max Signed url max time"
  type        = number
  default     = 43200
}