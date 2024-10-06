variable domain_name {
  type        = string
  description = "root domain name"
}

variable "validate_certificate" {
  description = "Flag to determine whether to validate the certificate or not"
  type        = bool
}