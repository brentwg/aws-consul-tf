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
