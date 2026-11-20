
module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  env          = var.env

  availability_zone = var.aws_availability_zone

  remote_user     = var.remote_user
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
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
  abs_project_root = abspath("../../..")

  abs_compose_file_path = "${local.abs_project_root}/compose.yml"
  abs_env_file_path     = "${local.abs_project_root}/.env"
}
