
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
  abs_env_file_path = local.abs_env_file_path
}

locals {
  abs_project_root = abspath("../../..")
  
  # Using local key files in ./secrets folder if no ssh keys were provided
  ssh_public_key  = var.ssh_public_key != null ? var.ssh_public_key : file("${local.abs_project_root}/src/secrets/ssh-key.pub")
  ssh_private_key = var.ssh_private_key != null ? var.ssh_private_key : file("${local.abs_project_root}/src/secrets/ssh-key")

  abs_compose_file_path = "${local.abs_project_root}/compose.yml"
  abs_env_file_path = "${local.abs_project_root}/.env"
}

