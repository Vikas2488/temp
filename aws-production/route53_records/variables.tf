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

variable "domain_name" {
  description = "Domain name"
  type        = string
}