
# REQUIRED

variable "ssh_public_key" {
  type      = string
  default   = null
}

variable "ssh_private_key" {
  type      = string

  sensitive = true # prevents logging
  ephemeral = true # prevents storage (including in state)

  default   = null
}

# OPTIONAL

variable "project_name" {
  type    = string
  default = "demo"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_availability_zone" {
  type    = string
  default = "eu-north-1a"
}

variable "remote_user" {
  type    = string
  default = "ubuntu"
}

variable "cidr_blocks" {
  type = object({
    vpc : string
    subnet : string
  })

  # Dev CIDR settings 
  # (should not overlap with prod networks)
  default = {
    vpc : "10.10.0.0/16"
    subnet : "10.10.1.0/24"
  }
}