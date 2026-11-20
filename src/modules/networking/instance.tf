# Defines specs of an AMI image
# (returns an AMI matching those specs)
data "aws_ami" "ubuntu_image" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (ensures we get an official AMI)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Defines SSH key pair
# (requires unique name)
resource "aws_key_pair" "ubuntu_authorisation_key" {
  key_name   = "${local.name_prefix}-ubuntu-authorisation-key"
  public_key = var.ssh_public_key
}

# Elastic IP 
# (static IP between instance restarts)
resource "aws_eip" "ubuntu_instance" {
  instance = aws_instance.ubuntu_instance.id
  domain   = "vpc"

  tags = { Name = "${local.name_prefix}-elastic-ip" }
}

# Executes instruction remotely
resource "terraform_data" "install_docker" {
  # re-run if the instance is replaced
  triggers_replace = [aws_instance.ubuntu_instance.id]

  # Setup SSH connection to the instance
  connection {
    type        = "ssh"
    host        = aws_eip.ubuntu_instance.public_ip
    user        = var.remote_user
    private_key = var.ssh_private_key
    timeout     = "5m"
  }

  # Define instructions
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

# Provisions us an EC2 instance
resource "aws_instance" "ubuntu_instance" {
  # Type & Image
  ami           = data.aws_ami.ubuntu_image.id
  instance_type = var.instance_type

  # Network settings
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet.id

  # SSH Setup
  key_name = aws_key_pair.ubuntu_authorisation_key.key_name

  lifecycle {
    # Makes sure terraform doesn invalidate & tries to delete / rebuild 
    # our instance anytime a newer matching AMI is found
    ignore_changes = [ami]
  }

  tags = { Name = "${local.name_prefix}-instance" }
}
