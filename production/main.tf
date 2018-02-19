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


