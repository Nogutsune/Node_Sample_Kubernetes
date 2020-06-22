
variable environment {
  default = "insider"
}

locals {
  cluster_name = "insider"
}

data "aws_availability_zones" "available" {}

variable cidr_block {
  default = "10.0.0.0/16"
}

variable enable_dns_hostnames {
  default = true
}

variable subnet_list {
  type = "list"

  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable subnet_private_list {
  type = "list"

  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable enable_nat_gateway {
  default = true
}

variable single_nat_gateway {
  default = true
}

variable ami_id {
  default = "ami-0ee0652ac0722f0e3"
}

variable instance_type {
  default = "t3.small"
}

variable keypair_name {
  default = "test_key_pair"
}
