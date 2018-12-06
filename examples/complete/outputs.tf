output "ecs_service_id" {
  value = "${module.ecs_fargate.ecs_service_id}"
}

output "ecs_service_name" {
  value = "${module.ecs_fargate.ecs_service_name}"
}

output "ecs_service_cluster" {
  value = "${module.ecs_fargate.ecs_service_cluster}"
}

output "ecs_service_iam_role" {
  value = "${module.ecs_fargate.ecs_service_iam_role}"
}

output "ecs_service_desired_count" {
  value = "${module.ecs_fargate.ecs_service_desired_count}"
}

output "security_group_id" {
  value = "${module.ecs_fargate.security_group_id}"
}

output "security_group_arn" {
  value = "${module.ecs_fargate.security_group_arn}"
}

output "security_group_vpc_id" {
  value = "${module.ecs_fargate.security_group_vpc_id}"
}

output "security_group_owner_id" {
  value = "${module.ecs_fargate.security_group_owner_id}"
}

output "security_group_name" {
  value = "${module.ecs_fargate.security_group_name}"
}

output "security_group_description" {
  value = "${module.ecs_fargate.security_group_description}"
}

output "security_group_ingress" {
  value = "${module.ecs_fargate.security_group_ingress}"
}

output "security_group_egress" {
  value = "${module.ecs_fargate.security_group_egress}"
}

output "ecs_task_definition_arn" {
  value = "${module.ecs_fargate.ecs_task_definition_arn}"
}

output "ecs_task_definition_family" {
  value = "${module.ecs_fargate.ecs_task_definition_family}"
}

output "ecs_task_definition_revision" {
  value = "${module.ecs_fargate.ecs_task_definition_revision}"
}

output "ecs_task_execution_role_arn" {
  value = "${module.ecs_fargate.ecs_task_execution_role_arn}"
}

output "ecs_task_execution_role_create_date" {
  value = "${module.ecs_fargate.ecs_task_execution_role_create_date}"
}

output "ecs_task_execution_role_unique_id" {
  value = "${module.ecs_fargate.ecs_task_execution_role_unique_id}"
}

output "ecs_task_execution_role_name" {
  value = "${module.ecs_fargate.ecs_task_execution_role_name}"
}

output "ecs_task_execution_role_description" {
  value = "${module.ecs_fargate.ecs_task_execution_role_description}"
}

output "ecs_task_execution_policy_id" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_id}"
}

output "ecs_task_execution_policy_arn" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_arn}"
}

output "ecs_task_execution_policy_description" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_description}"
}

output "ecs_task_execution_policy_name" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_name}"
}

output "ecs_task_execution_policy_path" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_path}"
}

output "ecs_task_execution_policy_document" {
  value = "${module.ecs_fargate.ecs_task_execution_policy_document}"
}
