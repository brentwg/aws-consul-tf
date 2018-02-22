# --------------
# Module Outputs
# --------------

# Role Outputs
output "consul_server_role_id" {
  value = "${aws_iam_role.consul_server_role.id}"
}

output "consul_server_role_name" {
  value = "${aws_iam_role.consul_server_role.name}"
}

output "consul_server_role_arn" {
  value = "${aws_iam_role.consul_server_role.arn}"
}

# Profile Outputs
output "consul_server_profile_arn" {
  value = "${aws_iam_instance_profile.consul_server_profile.arn}"
}

output "consul_server_profile_name" {
  value = "${aws_iam_instance_profile.consul_server_profile.name}"
}