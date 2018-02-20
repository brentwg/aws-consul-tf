# ---------------------
# Consul Security Group
# ---------------------
resource "aws_security_group" "this" {
  name        = "${var.environment}_consul_sg"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"

  # Bastion SSH Ingress Rule
  ingress {
    from_port       = "${var.ssh_port}"
    to_port         = "${var.ssh_port}"
    protocol        = "tcp"
    security_groups = ["${var.bastion_security_group}"]
  }

  # Default Internal Traffic Ingress Rule
  ingress {
    from_port       = "0"
    to_port         = "65535"
    protocol        = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  lifecycle {
    ignore_changes = ["name"]
  }

  tags {
    Name        = "${var.environment}_consul_sg"
    Environment = "S{var.environment}"
    Terraform   = "true"
  }
}
