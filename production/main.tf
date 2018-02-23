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
  source = "git::https://github.com/brentwg/terraform-aws-key-pair.git?ref=1.1"

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


# ----------------------
# Bastion Security Group
# ----------------------
module "bastion_security_group" {
  source = "../modules/bastion-security-group"

  project_name         = "${var.project_name}"
  environment           = "${var.environment}"
  vpc_id                = "${module.vpc.vpc_id}"
  vpc_cidr_block        = "${module.vpc.vpc_cidr_block}"
  ssh_port              = "${var.bastion_ssh_port}"
  external_subnet_range = "${var.bastion_external_subnet_range}"
}


# -------
# Bastion
# -------
module "bastion" {
  source = "git::https://github.com/brentwg/terraform-aws-bastion.git?ref=1.0"

  customer_name       = "${var.project_name}"
  environment         = "${var.environment}"

  # Route53
  bastion_zone_id     = "${data.aws_route53_zone.my_domain.zone_id}"
  bastion_domain_name = "bastion-${var.project_name}.${var.domain_name}"
  bastion_zone_ttl    = "${var.bastion_zone_ttl}"

  # Launch config
  bastion_region        = "${var.region}"      
  bastion_image_id      = "${var.bastion_image_id}"
  bastion_instance_type = "${var.bastion_instance_type}"
  bastion_key_name      = "${var.key_pair_name}"

  bastion_security_groups   = [
    "${module.bastion_security_group.bastion_security_group_id}"
  ]
  
  bastion_ebs_optimized     = "${var.bastion_ebs_optimized}"
  bastion_enable_monitoring = "${var.bastion_enable_monitoring}"
  bastion_volume_type       = "${var.bastion_volume_type}"
  bastion_volume_size       = "${var.bastion_volume_size}"

  # ASG
  bastion_max_size         = "${var.bastion_max_size}"
  bastion_min_size         = "${var.bastion_min_size}"
  bastion_desired_capacity = "${var.bastion_desired_capacity}"

  bastion_asg_subnets      = ["${module.vpc.public_subnets}"]
}


# -----------------
# Consul Client IAM 
# -----------------
module "consul_client_iam" {
  source = "../modules/consul-client-iam"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"
  #s3Bucket_arn = "${var.s3Bucket_name}/${var.s3Bucket_prefix}"
}


# -----------------
# Consul Server IAM
# -----------------
module "consul_server_iam" {
  source = "../modules/consul-server-iam"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"
}


# ---------------------
# Consul Security Group
# ---------------------
module "consul_security_group" {
  source = "../modules/consul-security-group"

  project_name           = "${var.project_name}"
  environment            = "${var.environment}"
  vpc_id                 = "${module.vpc.vpc_id}"
  vpc_cidr_block         = "${module.vpc.vpc_cidr_block}"
  ssh_port               = "${var.bastion_ssh_port}"
  server_rpc_port        = "${var.server_rpc_port}"
  serf_lan_port          = "${var.serf_lan_port}"
  serf_wan_port          = "${var.serf_wan_port}"
  client_rpc_port        = "${var.client_rpc_port}"
  http_api_port          = "${var.http_api_port}"
  dns_interface_port     = "${var.dns_interface_port}"
  bastion_security_group = "${module.bastion_security_group.bastion_security_group_id}"
}


# -----------------
# Consul Client ASG
# -----------------
data "template_file" "consul_client_userdata" {
  template = "${file("consul-client-userdata.sh")}"

  vars {
    CFN_BOOTSTRAP_URL     = "${var.cfn_bootstrap_url}"
    BOOTSTRAP_PACKAGES    = "${var.bootstrap_packages}"
    CONSUL_TAG_KEY        = "${var.consul_tag_key}"
    CONSUL_TAG_VALUE      = "${var.consul_tag_value}"
    S3BUCKET_NAME         = "${var.s3Bucket_name}"
    S3BUCKET_PREFIX       = "${var.s3Bucket_prefix}"
    CONSUL_BOOTSTRAP_FILE = "${var.s3Bucket_client_file}"  
  }
}

module "consul_client_asg" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling.git?ref=v2.1.0"

  name = "consul_client_instance"

  # Launch Configuration
  lc_name              = "${var.project_name}-${var.environment}-client-lc"
  image_id             = "${var.client_image_id}"
  instance_type        = "${var.client_instance_type}"
  iam_instance_profile = "${module.consul_client_iam.consul_client_profile_arn}"
  key_name             = "${var.key_pair_name}"

  security_groups = ["${module.consul_security_group.consul_security_group_id}"]

  associate_public_ip_address = "false"

  user_data = "${data.template_file.consul_client_userdata.rendered}"

  # Auto Scaling Group
  asg_name            = "${var.project_name}-${var.environment}-client-asg"
  vpc_zone_identifier = ["${module.vpc.private_subnets}"]
  min_size            = "${var.client_asg_min_size}"
  max_size            = "${var.client_asg_max_size}"
  desired_capacity    = "${var.client_asg_desired_capacity}"
  health_check_type   = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}_${var.environment}_asg"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "${var.consul_tag_key}"
      value               = "${var.consul_tag_value}"
      propagate_at_launch = true
    },
  ]
}


# -----------------
# Consul Server ASG
# -----------------
data "template_file" "consul_server_userdata" {
  template = "${file("consul-server-userdata.sh")}"

  vars {
    CFN_BOOTSTRAP_URL     = "${var.cfn_bootstrap_url}"
    BOOTSTRAP_PACKAGES    = "${var.bootstrap_packages}"
    CONSUL_EXPECT         = "${var.server_quorum_size}"
    CONSUL_TAG_KEY        = "${var.consul_tag_key}"
    CONSUL_TAG_VALUE      = "${var.consul_tag_value}"
    S3BUCKET_NAME         = "${var.s3Bucket_name}"
    S3BUCKET_PREFIX       = "${var.s3Bucket_prefix}"
    CONSUL_BOOTSTRAP_FILE = "${var.s3Bucket_server_file}"  
  }
}

module "consul_server_asg" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling.git?ref=v2.1.0"

  name = "consul_server_instance"

  # Launch Configuration
  lc_name              = "${var.project_name}-${var.environment}-server-lc"
  image_id             = "${var.server_image_id}"
  instance_type        = "${var.server_instance_type}"
  iam_instance_profile = "${module.consul_server_iam.consul_server_profile_arn}"
  key_name             = "${var.key_pair_name}"

  security_groups = ["${module.consul_security_group.consul_security_group_id}"]

  associate_public_ip_address = "false"

  user_data = "${data.template_file.consul_server_userdata.rendered}"

  # Auto Scaling Group
  asg_name            = "${var.project_name}-${var.environment}-server-asg"
  vpc_zone_identifier = ["${module.vpc.private_subnets}"]
  min_size            = "${var.server_asg_min_size}"
  max_size            = "${var.server_asg_max_size}"
  desired_capacity    = "${var.server_asg_desired_capacity}"
  health_check_type   = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}_${var.environment}_asg"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "${var.consul_tag_key}"
      value               = "${var.consul_tag_value}"
      propagate_at_launch = true
    },
  ]
}
