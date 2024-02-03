locals {
  s3_read_only_policy_arn   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ssm_managed_instance_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  ec2_assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  }

  subnets_config = [
    {
      name              = "Public-Subnet-AZ-1"
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-south-1a"
    },
    {
      name              = "Public-Subnet-AZ-2"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-south-1b"
    },
    {
      name                   = "Private-Subnet-AZ-1"
      cidr_block             = "10.0.2.0/24"
      availability_zone      = "ap-south-1a"
      public_nat_gw_required = true
    },
    {
      name                   = "Private-Subnet-AZ-2"
      cidr_block             = "10.0.3.0/24"
      availability_zone      = "ap-south-1b"
      public_nat_gw_required = true
    },
    {
      name              = "Private-DB-Subnet-AZ-1"
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-south-1a"
    },
    {
      name              = "Private-DB-Subnet-AZ-2"
      cidr_block        = "10.0.5.0/24"
      availability_zone = "ap-south-1b"
    },
  ]

  route_tables_config = [
    {
      name = "Public_Route_Table"
      routes = [
        {
          cidr_block          = "0.0.0.0/0"
          internet_gateway_id = module.vpc.internet_gateway_id
        }
      ]
      associations = [
        module.vpc.subnet_ids["Public-Subnet-AZ-1"],
        module.vpc.subnet_ids["Public-Subnet-AZ-2"],
      ]
    },
    {
      name = "Private_Route_Table_AZ1"
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway_ids["Private-Subnet-AZ-1"]
        }
      ]
      associations = [
        module.vpc.subnet_ids["Private-Subnet-AZ-1"],
      ]
    },
    {
      name = "Private_Route_Table_AZ2"
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway_ids["Private-Subnet-AZ-2"]
        }
      ]
      associations = [
        module.vpc.subnet_ids["Private-Subnet-AZ-2"],
      ]
    }
  ]

}
