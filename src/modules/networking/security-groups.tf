
# Defines access rules for the EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow TLS inbound traffic on ports 22 and 80. And allows all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = { Name = "${local.name_prefix}-security-group" }
}

# Allow incomming traffic on 22/tcp
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ip_v4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  tags = { Name = "${local.name_prefix}-allow-ssh-ip-v4" }
}

# Allow incomming traffic on 80/tcp
resource "aws_vpc_security_group_ingress_rule" "allow_web_ip_v4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  tags = { Name = "${local.name_prefix}-allow-web-ip-v4" }
}

# Allow all outbount traffic
resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = { Name = "${local.name_prefix}-allow-outbound-traffic" }
}