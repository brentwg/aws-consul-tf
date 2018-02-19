# ----------------
# Provider Section
# ----------------
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}



# --------
# Key Pair
# --------
module "key_pair" {
  source = "git::https://github.com/brentwg/terraform-aws-key-pair.git?ref=1.0"

  key_pair_name   = "${var.key_pair_name}"
  public_key_path = "${var.public_key_path}"
}


# --------------------------------
# Lookup Region Availability Zones
# --------------------------------
data "aws_availability_zones" "available" {}


# ------------------------------
# Lookup Domain Zone Information
# ------------------------------
data "aws_route53_zone" "my_domain" {
  name = "${var.domain_name}"
}


# ---------------------------------
# Lookup Domain SSl Certificate ARN
# ---------------------------------
data "aws_acm_certificate" "this" {
  domain   = "${var.domain_name}"
  statuses = ["ISSUED"]
}


# ---
# VPC
# ---
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v1.23.0"

  name                = "${var.vpc_name}"
  cidr                = "${var.vpc_cidr}"
  azs                 = "${data.aws_availability_zones.available.names}"
  private_subnets     = "${var.vpc_private_subnets}"
  public_subnets      = "${var.vpc_public_subnets}"

  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
  enable_dns_support   = "${var.vpc_enable_dns_support}"

  enable_nat_gateway           = "${var.vpc_enable_nat_gateway}"
  enable_s3_endpoint           = "${var.vpc_enable_s3_endpoint}"
  enable_dynamodb_endpoint     = "${var.vpc_enable_dynamodb_endpoint}"

  tags = {
    Name        = "${var.vpc_name}"
    Environment = "${var.environment}"
    Terraform   = "true"
  }

  private_subnet_tags = {
    SubnetType = "private"
  }

  public_subnet_tags = {
    SubnetType = "public"
  }
}
