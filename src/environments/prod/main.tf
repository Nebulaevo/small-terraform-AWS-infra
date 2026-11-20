
module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  env          = var.env

  availability_zone = var.aws_availability_zone

  remote_user     = var.remote_user
  ssh_public_key  = local.ssh_public_key
  ssh_private_key = local.ssh_private_key
  cidr_blocks     = var.cidr_blocks
}

module "docker" {
  source = "../../modules/docker"

  # networking needs to be initialised first
  depends_on = [module.networking]

  project_name          = var.project_name
  abs_compose_file_path = local.abs_compose_file_path
  abs_env_file_path     = local.abs_env_file_path
}

locals {
  # Using local key files in ./ssh_keys folder if no ssh keys were providen
  ssh_public_key  = var.ssh_public_key != null ? var.ssh_public_key : file("ssh_keys/key.pub")
  ssh_private_key = var.ssh_private_key != null ? var.ssh_private_key : file("ssh_keys/key")

  abs_compose_file_path = abspath("../../../compose.yml")
  abs_env_file_path     = abspath("../../../.env")
}

