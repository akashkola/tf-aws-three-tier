
module "bucket" {
  source = "./modules/s3"

  bucket_name = "my-three-tier-aws-workshop-akash"
}

module "iam_role" {
  source = "./modules/iam_role"

  role_name          = "Ec2RoleS3ReadOnlyAndSSMS"
  assume_role_policy = local.ec2_assume_role_policy
  policy_arns = [
    local.s3_read_only_policy_arn,
    local.ssm_managed_instance_core
  ]
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name   = "three-tier-webapp-vpc"
  cidr_block = "10.0.0.0/16"
  subnets    = local.subnets_config
}

module "route_tables" {
  source = "./modules/route_table"

  vpc_id       = module.vpc.vpc_id
  route_tables = local.route_tables_config
}
