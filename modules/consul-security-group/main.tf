# ---------------------
# Consul Security Group
# ---------------------
resource "aws_security_group" "this" {
  name        = "${var.project_name}_${var.environment}_consul_sg"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"

  # Bastion SSH Ingress Rule
  ingress {
    from_port       = "${var.ssh_port}"
    to_port         = "${var.ssh_port}"
    protocol        = "tcp"
    security_groups = ["${var.bastion_security_group}"]
    #description     = "Bastion SSH Ingress Rule"
  }

  # Server RPC (TCP) Ingress Rule
  ingress {
    from_port   = "${var.server_rpc_port}"
    to_port     = "${var.server_rpc_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Server RPC (TCP) Ingress Rule"
  }

  # Serf LAN (TCP) Ingress Rule
  ingress {
    from_port   = "${var.serf_lan_port}"
    to_port     = "${var.serf_lan_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Serf LAN (TCP) Ingress Rule"
  }

  # Serf LAN (UDP) Ingress Rule
  ingress {
    from_port   = "${var.serf_lan_port}"
    to_port     = "${var.serf_lan_port}"
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Serf LAN (UDP) Ingress Rule"
  }

  # Serf WAN (TCP) Ingress Rule
  ingress {
    from_port   = "${var.serf_wan_port}"
    to_port     = "${var.serf_wan_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Serf WAN (TCP) Ingress Rule"
  }

  # Serf WAN (UDP) Ingress Rule
  ingress {
    from_port   = "${var.serf_wan_port}"
    to_port     = "${var.serf_wan_port}"
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Serf WAN (UDP) Ingress Rule"
  }

  # Client RPC (TCP) Ingress Rule
  ingress {
    from_port   = "${var.client_rpc_port}"
    to_port     = "${var.client_rpc_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "Client RPC (TCP) Ingress Rule"
  }

  # HTTP API (TCP) Ingress Rule
  ingress {
    from_port   = "${var.http_api_port}"
    to_port     = "${var.http_api_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "HTTP API (TCP) Ingress Rule"
  }

  # DNS Interface (TCP) Ingress Rule
  ingress {
    from_port   = "${var.dns_interface_port}"
    to_port     = "${var.dns_interface_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "DNS Interface (TCP) Ingress Rule"
  }

  # DNS Interface (UDP) Ingress Rule
  ingress {
    from_port   = "${var.dns_interface_port}"
    to_port     = "${var.dns_interface_port}"
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #description = "DNS Interface (UDP) Ingress Rule"
  }

  # Default Egress Rule
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #description = "Default Egress Rule"
  }

  lifecycle {
    ignore_changes = ["name"]
  }

  tags {
    Name        = "${var.project_name}_${var.environment}_consul_sg"
    Project     = "${var.project_name}"
    Environment = "S{var.environment}"
    Terraform   = "true"
  }
}
