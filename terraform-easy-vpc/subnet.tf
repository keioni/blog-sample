resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "vpc-${var.app}-${var.env}"
  }
}

resource "aws_subnet" "main" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(
    var.vpc_cidr_block,
    var.subnet_mask_length - tonumber(regex("[0-9]+$", var.vpc_cidr_block)),
    count.index
  )
  ipv6_cidr_block = cidrsubnet(
    aws_vpc.main.ipv6_cidr_block,
    8,
    parseint(replace(data.aws_availability_zones.available.names[count.index], "/^.+?([a-z])$/", "0$1"), 16)
  )

  availability_zone = data.aws_availability_zones.available.names[count.index]

  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true


  tags = {
    Name = "subnet-${var.app}-${var.env}-${replace(data.aws_availability_zones.available.names[count.index], "/^.+?([a-z])$/", "$1")}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.app}-${var.env}"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rtb-${var.app}-${var.env}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }
}
