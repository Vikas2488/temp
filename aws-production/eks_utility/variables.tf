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

variable "domain_name" {
  type        = string
}
# ------------------------------------------------------------
# Reloader Settings
# ------------------------------------------------------------
# variable "reloader_namespace" {
#   type        = string
#   description = "reloader_namespace"
#   default     = "reloader"
# }

# variable "monitoring_namespace" {
#   type        = string
#   description = "monitoring_namespace"
#   default     = "monitoring"
# }


# ------------------------------------------------------------
# Jenkins Settings
# ------------------------------------------------------------
# variable "jenkins_admin_user" {
#   type        = string
#   description = "Admin user of the Jenkins Application."
#   default     = "admin"
# }

# variable "jenkins_admin_password" {
#   type        = string
#   description = "Admin password of the Jenkins Application."
#   default     = "password"
# }

# variable "loki_persistence_size" {
#   type    = string
#   default = "20Mi"
# }

# ------------------------------------------------------------
# ArgoCD Settings
# ------------------------------------------------------------

variable "argocd_version" {
  description = "Name of the EKS security group"
  type        = string
  default = "6.7.12"
}

# variable "chart_path" {
#   description = "Path to the local Helm chart directory"
#   type        = string
# }

# variable "release_name" {
#   description = "Name of the Helm release"
#   type        = string
# }

# variable "namespace" {
#   description = "Kubernetes namespace to deploy the chart"
#   type        = string
# }
# variable "argo_dns" {
#   description = "Provide dns name of argocd server"
#   type = string
# }