
# REQUIRED

# EC2 instance user
variable "remote_user" {
  type = string
}

# Network and subnetwork CIDR
# (subnet must be a subnetwork of vpc)
variable "cidr_blocks" {
  type = object({
    vpc : string
    subnet : string
  })
}

# Where lives the subnet
variable "availability_zone" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type = string

  sensitive = true # prevents logging
  ephemeral = true # prevents storage (including in state)
}

# OPTIONAL

# dev / prod
variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "kalypso"
}

# EC2 instance type
variable "instance_type" {
  type    = string
  default = "t3.micro"
}