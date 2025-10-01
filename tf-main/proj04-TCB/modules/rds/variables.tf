########################
# General information
########################

variable "project_name" {
  type        = string
  description = "The project name. Used to name the RDS instance and add relevant tags."
}

########################
# DB configuration
########################

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance class used to create the RDS instance. Requires a free-tier instance class."

  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "Only db.t3.micro is allowed due to free tier access."
  }
}

variable "storage_size" {
  type        = number
  default     = 10
  description = "The amount of storage to allocate to the RDS instance. Should be between 5GB and 10GB."

  validation {
    condition     = var.storage_size >= 5 && var.storage_size <= 10
    error_message = "DB storage must be between 5GB and 10 GB"
  }
}

variable "engine" {
  type        = string
  default     = "postgres-latest"
  description = "Which engine to use for the RDS instance. Currently only postgres is supported."

  validation {
    condition     = contains(["postgres-latest", "postgres-14"], var.engine)
    error_message = "DB engine must be postgres-latest or postgres-14"
  }
}

########################
# DB credentials
########################

variable "credentials" {
  type = object({
    username = string
    password = string
  })

  sensitive   = true
  description = "The root username and password for the RDS instance creation."

  validation {
    condition = (
      length(var.credentials.password) >= 8 &&
      can(regex("[a-z]", var.credentials.password)) &&
      can(regex("[A-Z]", var.credentials.password)) &&
      can(regex("[0-9]", var.credentials.password)) &&
      can(regex("[!#$%&*+\\-.:;<=>?\\[\\]^_{|}~(),']", var.credentials.password)) &&
      !can(regex("[@/\"\\\\\\s]", var.credentials.password))
    )
    error_message = <<-EOT
    Password must comply with the following format:

    1. Contain at least 1 uppercase letter
    2. Contain at least 1 lowercase letter
    3. Contain at least 1 digit
    4. Be at least 15 characters long
    5. Contain at least 1 special character from the following: ! # $ % & * + - . : ; < = > ? [ ] ^ _ { | } ~ ( ) , '
    6. Must not contain the following characters: @ / " \ (space)
    EOT
  }
}

########################
# DB network
########################

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs to deploy the RDS instance in."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the RDS instance."
}