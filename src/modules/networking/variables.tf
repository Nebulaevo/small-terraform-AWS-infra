
# REQUIRED

variable "remote_user" {
  type = string
}

variable "cidr_blocks" {
  type = object({
    vpc : string
    subnet : string
  })
}

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

variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "kalypso"
}

variable "availability_zone" {
  type    = string
  default = "eu-north-1a"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}