variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }

}

variable "subnet_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))

  validation {
    condition     = alltrue([for subnet in var.subnet_config : can(cidrnetmask(subnet.cidr_block))])
    error_message = "Each subnet config option must contain a valid CIDR block."
  }
}