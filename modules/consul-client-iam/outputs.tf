# --------------
# Module Outputs
# --------------

# Role Outputs
output "consul_client_role_id" {
  value = "${aws_iam_role.consul_client_role.id}"
}

output "consul_client_role_name" {
  value = "${aws_iam_role.consul_client_role.name}"
}

output "consul_client_role_arn" {
  value = "${aws_iam_role.consul_client_role.arn}"
}

# Profile Outputs
output "consul_client_profile_arn" {
  value = "${aws_iam_instance_profile.consul_client_profile.arn}"
}

output "consul_client_profile_name" {
  value = "${aws_iam_instance_profile.consul_client_profile.name}"
}
