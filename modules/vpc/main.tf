resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" : var.vpc_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" : "IGW-${aws_vpc.vpc.tags_all["Name"]}"
  }
}

resource "aws_subnet" "subnets" {
  for_each          = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    "Name" : "subnet-${each.value.name}-${upper(each.value.availability_zone)}"
  }
}

resource "aws_eip" "eips" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if subnet.public_nat_gw_required == true }

  tags = {
    "Name" : "EIP-${upper(each.value.availability_zone)}"
  }
}

resource "aws_nat_gateway" "nat_gateways" {
  for_each      = { for subnet in var.subnets : subnet.name => subnet if subnet.public_nat_gw_required == true }
  subnet_id     = aws_subnet.subnets[each.key].id
  allocation_id = aws_eip.eips[each.key].id

  tags = {
    "Name" : "NAT-GW-${upper(each.value.availability_zone)}"
  }
}
