variable "cidr_block" {
  type        = string
  description = "cidr block of the VPC"
}

variable "vpc_name" {
  type        = string
  description = "name of the VPC"
}

variable "subnets" {
  type = list(object({
    name                   = string
    cidr_block             = string
    availability_zone      = string
    public_nat_gw_required = optional(bool)
  }))

  description = "subnets to create in VPC"
}
