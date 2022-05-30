# -------------------------------------------------------------------
# VPC - VPN
# -------------------------------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]
  map_public_ip_on_launch = true

  default_security_group_egress = local.egress_all
  default_security_group_ingress = local.ingress_all

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}