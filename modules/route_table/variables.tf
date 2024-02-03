variable "route_tables" {
  type = list(object({
    name = string
    routes = list(object({
      cidr_block          = string
      internet_gateway_id = optional(string)
      nat_gateway_id      = optional(string)
    }))
    associations = list(string)
  }))

  description = "route tables with routes to create"
}

variable "vpc_id" {
  type        = string
  description = "id of the VPC"
}
