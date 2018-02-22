# -----------------
# Consul Server IAM
# -----------------

# Consul Server Role
resource "aws_iam_role" "consul_server_role" {
  name = "${var.project_name}_${var.environment}_consule_server_role"

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

# Consul Server EC2 Policy
resource "aws_iam_role_policy" "consul_server_ec2_policy" {
  name = "${var.project_name}_${var.environment}_consule_server_ec2_policy"
  role = "${aws_iam_role.consul_server_role.id}"

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

# Consul Server S3 Policy
### TODO? ###

# Consul Server Profile
resource "aws_iam_instance_profile" "consul_server_profile" {
  name = "${var.project_name}_${var.environment}_consule_server_profile"
  role = "${aws_iam_role.consul_server_role.name}"
  path = "/"
}