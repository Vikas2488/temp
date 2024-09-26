variable "env" {
  type        = string
  description = "env (e.g. `sandbox`, `production`)"
}

variable "name" {
  type        = string
  description = "Name of the variable"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "resource_version" {
  type = string
  default = "1"
  description = "Version of the resource."
}