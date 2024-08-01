resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.gw_name
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.avail_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.public_subnet_name[count.index]
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/task4-cluster" = "owned"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}
