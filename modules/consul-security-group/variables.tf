# -------------
# Module Inputs
# -------------
variable "project_name" {}
variable "environment" {}

variable "sg_description" {
  description = "Security Group Description"
  default     = "Consul Security Group"
}

variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "ssh_port" {}
variable "bastion_security_group" {}
