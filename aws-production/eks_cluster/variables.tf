variable "aws_region" {
  type =  string
}

variable "owner" {
  description = "Owner of the project"
  type        = string
}

variable "region" {
  description = "AWS Resource Region"
  type        = string
}

variable "env" {
  description = "AWS deployement"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

variable "deploy_aws_albv2_controller" {
  description = "If set to true, creates albv2 ingress controller"
  type        = bool
  default     = true
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
}