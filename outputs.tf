output "security_group_id" {
  value       = "${aws_security_group.default.id}"
  description = "The ID of the ECS Service security group."
}

output "security_group_arn" {
  value       = "${aws_security_group.default.arn}"
  description = "The ARN of the ECS Service security group."
}

output "security_group_vpc_id" {
  value       = "${aws_security_group.default.vpc_id}"
  description = "The VPC ID of the ECS Service security group."
}

output "security_group_owner_id" {
  value       = "${aws_security_group.default.owner_id}"
  description = "The owner ID of the ECS Service security group."
}

output "security_group_name" {
  value       = "${aws_security_group.default.name}"
  description = "The name of the ECS Service security group."
}

output "security_group_description" {
  value       = "${aws_security_group.default.description}"
  description = "The description of the ECS Service security group."
}

output "security_group_ingress" {
  value       = "${aws_security_group.default.ingress}"
  description = "The ingress rules of the ECS Service security group."
}

output "security_group_egress" {
  value       = "${aws_security_group.default.egress}"
  description = "The egress rules of the ECS Service security group."
}

output "ecs_task_definition_arn" {
  value       = "${aws_ecs_task_definition.default.arn}"
  description = "Full ARN of the Task Definition (including both family and revision)."
}

output "ecs_task_definition_family" {
  value       = "${aws_ecs_task_definition.default.family}"
  description = "The family of the Task Definition."
}

output "ecs_task_definition_revision" {
  value       = "${aws_ecs_task_definition.default.revision}"
  description = "The revision of the task in a particular family."
}

output "ecs_task_execution_role_arn" {
  value       = "${aws_iam_role.default.arn}"
  description = "The Amazon Resource Name (ARN) specifying the ecs task execution."
}

output "ecs_task_execution_role_create_date" {
  value       = "${aws_iam_role.default.create_date}"
  description = "The creation date of the ecs task execution."
}

output "ecs_task_execution_role_unique_id" {
  value       = "${aws_iam_role.default.unique_id}"
  description = "The stable and unique string identifying the ecs task execution."
}

output "ecs_task_execution_role_name" {
  value       = "${aws_iam_role.default.name}"
  description = "The name of the ecs task execution."
}

output "ecs_task_execution_role_description" {
  value       = "${aws_iam_role.default.description}"
  description = "The description of the ecs task execution."
}

output "ecs_task_execution_policy_id" {
  value       = "${aws_iam_policy.default.id}"
  description = "The ecs task execution policy's ID."
}

output "ecs_task_execution_policy_arn" {
  value       = "${aws_iam_policy.default.arn}"
  description = "The ARN assigned by AWS to this ecs task execution policy."
}

output "ecs_task_execution_policy_description" {
  value       = "${aws_iam_policy.default.description}"
  description = "The description of the ecs task execution policy."
}

output "ecs_task_execution_policy_name" {
  value       = "${aws_iam_policy.default.name}"
  description = "The name of the ecs task execution policy."
}

output "ecs_task_execution_policy_path" {
  value       = "${aws_iam_policy.default.path}"
  description = "The path of the ecs task execution policy in IAM."
}

output "ecs_task_execution_policy_document" {
  value       = "${aws_iam_policy.default.policy}"
  description = "The policy document of the ecs task execution policy."
}
