# -----------------
# Consul Client IAM
# -----------------

# Consul Client Role
resource "aws_iam_role" "consul_client_role" {
  name = "${var.project_name}_${var.environment}_consule_client_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Consul Client EC2 Policy
resource "aws_iam_role_policy" "consul_client_ec2_policy" {
  name = "${var.project_name}_${var.environment}_consule_client_ec2_policy"
  role = "${aws_iam_role.consul_client_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

# Consul Client S3 Policy
### TODO? ###

# Consul Client Profile
resource "aws_iam_instance_profile" "consul_client_profile" {
  name = "${var.project_name}_${var.environment}_consule_client_profile"
  role = "${aws_iam_role.consul_client_role.name}"
  path = "/"
}
