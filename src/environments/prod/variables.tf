
# REQUIRED

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type = string

  sensitive = true # prevents logging
  ephemeral = true # prevents storage (including in state)
}

# OPTIONAL

variable "project_name" {
  type    = string
  default = "demo"
}

variable "env" {
  type    = string
  default = "prod"
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

  # Prod CIDR settings 
  # (should not overlap with dev networks)
  default = {
    vpc : "10.20.0.0/16"
    subnet : "10.20.1.0/24"
  }
}