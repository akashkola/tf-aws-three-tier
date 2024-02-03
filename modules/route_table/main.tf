resource "aws_route_table" "route_tables" {
  vpc_id   = var.vpc_id
  for_each = { for route_table in var.route_tables : route_table.name => route_table }

  dynamic "route" {
    for_each = { for route in each.value.routes : route.cidr_block => route }
    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = route.value.internet_gateway_id
      nat_gateway_id = route.value.nat_gateway_id
    }
  }
}


locals {
  subnets_associations = {
    for route_table in var.route_tables : route_table.name => {
      for subnet_id in route_table.associations : subnet_id => {
        route_table_id = aws_route_table.route_tables[route_table.name].id
        subnet_id      = subnet_id
      }
    }
  }
}

resource "aws_route_table_association" "route_table_associations" {
  for_each = local.subnets_associations

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}
