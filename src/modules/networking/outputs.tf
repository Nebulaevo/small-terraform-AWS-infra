output "ubuntu_instance_ip" {
  value = aws_eip.ubuntu_instance.public_ip

  # wait for the instance setup before outputing the IP
  # (allow to prevent "docker" provider from starting config and trying to connect to host before necessary installs run)
  depends_on = [terraform_data.install_docker]
}