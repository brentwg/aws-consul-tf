# -----------------
# Project Variables
# -----------------
variable "aws_access_key" {
  description = "AWS access key stored in pass"
}

variable "aws_secret_key" {
  description  = "AWS secret key stored in pass"
}

variable "region" {
  description = "AWS region"
}

variable "domain_name" {
  description = "Domain name for the project"
}


variable "project_name" {
  description = "The name of this project. Used for tagging and namespacing"
}

variable "environment" {
  description = "The programming environment - poc, dev, uat, prod, etc."
}

variable "cfn_bootstrap_url" {
  description = "Userdata script - AWS Cloudformation bootstrap URL"
  default     = "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz"
}

variable "bootstrap_packages" {
  description = "Userdata script - AWS Consul bootstrap required packages"
  default     = "python-setuptools"
}

variable "s3Bucket_name" {
  description = "Userdata script - AWS Quick Start bucket name"
  default     = "quickstart-reference"
}

variable "s3Bucket_prefix" {
  description = "Userdata script - AWS Quick Start bucket prefix"
  default     = "hashicorp/consul/latest/"
}

variable "s3Bucket_client_file" {
  description = "Userdata script - AWS Consul Client bootstrap file name"
  default     = "consul_client_bootstrap.sh"
}


# Key Pair
variable "key_pair_name" {
  description = "Name of the SSH key pair"
}

variable "public_key_path" {
  description = "File lookup peformed on the specified SSH public key"
}


# VPC
variable "vpc_name" {
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  description = "The VPC CIDR block"
}

variable "vpc_private_subnets" {
  description = "List of VPC private subnet CIDRs"
  type        = "list"
  default     = []
}

variable "vpc_public_subnets" {
  description = "List of VPC public subnet CIDRs"
  type        = "list"
  default     = []
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable private DNS hostnames in the VPC (true/false)"
  default     = false
}

variable "vpc_enable_dns_support" {
  description = "Enable private DNS support in the VPC (true/false)"
  default     = false
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway (true/false)"
  default     = false
}

variable "vpc_enable_s3_endpoint" {
  description = "Enable S3 endpoint (true/false)"
  default     = false
}

variable "vpc_enable_dynamodb_endpoint" {
  description = "enable dynamodb endpoint (true/false)"
  default     = false
}


# Bastion
variable "bastion_ssh_port" {
  description = "Port assigned for bastion SSH communication"
  default     = "22"
}

variable "bastion_external_subnet_range" {
  description = "List of subnets and/or IPs that can access the bastion"
  type        = "list"
  default     = []
}

variable "bastion_zone_ttl" {
  description = "Bastion zone record set cache time to live (seconds)"
  default     = ""
}

variable "bastion_image_id" {
  description = "Bastion AMI image ID"
  default     = ""
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  default     = ""
}

variable "bastion_key_name" {
  description = "Bastion SSH key pair name"
  default     = ""
}

variable "bastion_security_groups" {
  description = "Bastion security group list"
  type        = "list"
  default     = []
}

variable "bastion_ebs_optimized" {
  description = "Bastion EBS optimized (true/false)"
  default     = "false"
}

variable "bastion_enable_monitoring" {
  description = "Bastion enable detailed monitoring (true/false)"
  default     = "false"
}

variable "bastion_volume_type" {
  description = "Bastion root volume type"
  default     = ""
}

variable "bastion_volume_size" {
  description = "Bastion root volume size (GB)"
  default     = ""
}

variable "bastion_max_size" {
  description = "Bastion ASG maximum size"
  default     = "1"
}

variable "bastion_min_size" {
  description = "Bastion ASG minimum size"
  default     = "1"
}

variable "bastion_desired_capacity" {
  description = "Bastion ASG desired size"
  default     = "1"
}


# Consul Security Group
variable "server_rpc_port" {
  description = "This is used by servers to handle incoming requests from other agents (TCP only)"
  default     = "8300"
}

variable "serf_lan_port" {
  description = "This is used to handle gossip in the LAN - required by all agents (TCP and UDP)"
  default     = "8301"
}

variable "serf_wan_port" {
  description = "This is used by servers to gossip over the WAN to other servers (TCP and UDP)"
  default     = "8302"
}

variable "client_rpc_port" {
  description = "This is used by all agents to handle RPC from the CLI (TCP only)"
  default     = "8400"
}

variable "http_api_port" {
  description = "This is used by clients to talk to the HTTP API (TCP only)"
  default     = "8500"
}

variable "dns_interface_port" {
  description = "Used to resolve DNS queries (TCP and UDP)"
  default     = "8600"
}


# Consul Client ASG
variable "client_image_id" {
  description = "AWS AMI used for the Consul Client"
  default     = "ami-c62eaabe"
}

variable "client_instance_type" {
  description = "EC2 instance type used for the Consul client"
  default     = "t2.medium"
}

variable "client_asg_min_size" {
  description = "The minimum size of the auto scale group"
}
variable "client_asg_max_size" {
  description = "The maximum size of the auto scale group"
}

variable "client_asg_desired_capacity" {
  description = "The desired size of the auto scale group"
}
