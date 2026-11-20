resource "aws_vpc" "my_vpc" {
  cidr_block           = lookup(var.cidr_blocks, "vpc")
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${local.name_prefix}-vpc" }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = lookup(var.cidr_blocks, "subnet")
  availability_zone = var.availability_zone

  tags = { Name = "${local.name_prefix}-subnet" }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = { Name = "${local.name_prefix}-internet-gateway" }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = { Name = "${local.name_prefix}-route-table" }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}