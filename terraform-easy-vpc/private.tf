resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(
    var.vpc_cidr_block,
    var.subnet_mask_length - tonumber(regex("[0-9]+$", var.vpc_cidr_block)),
    count.index + 100
  )
  ipv6_cidr_block = cidrsubnet(
    aws_vpc.main.ipv6_cidr_block,
    8,
    parseint(replace(data.aws_availability_zones.available.names[count.index], "/^.+?([a-z])$/", "1$1"), 16)
  )

  availability_zone = data.aws_availability_zones.available.names[count.index]

  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = false

  tags = {
    Name = "subnet-private-${var.app}-${var.env}-${replace(data.aws_availability_zones.available.names[count.index], "/^.+?([a-z])$/", "$1")}"
  }
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.private[0].id

  tags = {
    Name = "nat-gw-${var.app}-${var.env}"
  }
}

resource "aws_eip" "nat_gw" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-gw-${var.app}-${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rtb-private-${var.app}-${var.env}"
  }
}
