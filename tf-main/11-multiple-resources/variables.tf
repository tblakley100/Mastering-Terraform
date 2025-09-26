variable "subnet_config" {
  description = "Configuration for subnets to be created. Each key represents the subnet name and the value contains the subnet configuration."
  type = map(object({
    cidr_block = string
  }))

  # Ensure that all provided CIDR blocks are valid.
  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is not valid. Please ensure all CIDR blocks follow the format 'x.x.x.x/y'."
  }
}

variable "ec2_instance_config_list" {
  description = "List of EC2 instance configurations. Each object defines an instance with its type, AMI, and optional subnet assignment."
  type = list(object({
    instance_type = string
    ami           = string
    subnet_name   = optional(string, "default")
  }))
  default = []


  # Ensure that only t2.micro is used
  validation {
    condition = alltrue([
      for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)
    ])
    error_message = "Only t2.micro instances are allowed for cost optimization."
  }

  # Ensure that only ubuntu and nginx images are used.
  validation {
    condition = alltrue([
      for config in var.ec2_instance_config_list : contains(["nginx", "ubuntu"], config.ami)
    ])
    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }
}

variable "ec2_instance_config_map" {
  description = "Map of EC2 instance configurations where keys are instance names and values contain instance configuration. Provides named instances for easier reference."
  type = map(object({
    instance_type = string
    ami           = string
    subnet_name   = optional(string, "default")
  }))


  # Ensure that only t2.micro is used
  validation {
    condition = alltrue([
      for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)
    ])
    error_message = "Only t2.micro instances are allowed for cost optimization."
  }

  # Ensure that only ubuntu and nginx images are used.
  validation {
    condition = alltrue([
      for config in values(var.ec2_instance_config_map) : contains(["nginx", "ubuntu"], config.ami)
    ])
    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }
}