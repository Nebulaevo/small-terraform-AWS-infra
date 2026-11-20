terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "docker" {
  # Setting up docker provider for remote execution on the EC2 instance
  host     = "ssh://${var.remote_user}@${module.networking.ubuntu_instance_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

