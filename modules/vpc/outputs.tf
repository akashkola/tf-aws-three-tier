output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = { for subnet in var.subnets : subnet.name => aws_subnet.subnets[subnet.name].id }
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "nat_gateway_ids" {
  value = { for subnet in var.subnets : subnet.name => aws_nat_gateway.nat_gateways[subnet.name].id if subnet.public_nat_gw_required == true }
}
