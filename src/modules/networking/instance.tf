data "aws_ami" "ubuntu_image" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ubuntu_authorisation_key" {
  key_name   = "${local.name_prefix}-ubuntu-authorisation-key"
  public_key = var.ssh_public_key
}

resource "terraform_data" "install_docker" {
  # re-run if the instance is replaced
  triggers_replace = [aws_instance.ubuntu_instance.id]

  connection {
    type        = "ssh"
    host        = aws_eip.ubuntu_instance.public_ip
    user        = var.remote_user
    private_key = var.ssh_private_key
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "cloud-init status --wait > /dev/null || true",
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io docker-compose-v2",
      "sudo usermod -aG docker ${var.remote_user}",
      "sudo systemctl enable --now docker",
    ]
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu_image.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet.id

  # setting up ssh for this instance
  key_name = aws_key_pair.ubuntu_authorisation_key.key_name

  tags = { Name = "${local.name_prefix}-instance" }

  lifecycle {
    # otherwise, new ami is a valid reason for terraform apply to delete / rebuild that instance
    ignore_changes = [ami]
  }
}

resource "aws_eip" "ubuntu_instance" {
  instance = aws_instance.ubuntu_instance.id
  domain   = "vpc"

  tags = { Name = "${local.name_prefix}-elastic-ip" }
}