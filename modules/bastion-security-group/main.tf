# ----------------------
# Bastion Security Group
# ----------------------
resource "aws_security_group" "this" {
  name        = "${var.project_name}_${var.environment}_bastion_sg"
  description = "Bastion Security Group"
  vpc_id      = "${var.vpc_id}"

  # Bastion Default Internet Ingress Rule
  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.external_subnet_range}"]
    description = "Bastion Default Internet Ingress Rule"
  }

  # Bastion Default VPC Ingress Rule
  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    description = "Bastion Default VPC Ingress Rule"
  }

  # Default Egress Rule
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default Egress Rule"
  }

  lifecycle {
    ignore_changes = ["name"]
  }

  tags {
    Name        = "${var.project_name}_${var.environment}_bastion_sg"
    Project     = "${var.project_name}"
    Environment = "S{var.environment}"
    Terraform   = "true"
  }
}
