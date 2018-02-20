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
variable "server_rpc_port" {}
variable "serf_lan_port" {}
variable "serf_wan_port" {}
variable "client_rpc_port" {}
variable "http_api_port" {}
variable "dns_interface_port" {}
variable "bastion_security_group" {}
