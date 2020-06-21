provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
}

##############################################################################################################################
###############################################  VPC   ###############################################################
###############################################################################################################################


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "${var.environment}-vpc"
  cidr                 = var.cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.subnet_list
  public_subnets       = var.subnet_private_list
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
