variable "name" {
  type        = "string"
  description = "The name of ecs service."
}

variable "ecs_task_execution_policy" {
  type        = "string"
  description = "The ecs task execution policy document. This is a JSON formatted string."
}

variable "ecs_task_execution_path" {
  default     = "/"
  type        = "string"
  description = "Path in which to create the ecs task execution role and the ecs task execution policy."
}

variable "ecs_task_execution_description" {
  default     = "Managed by Terraform"
  type        = "string"
  description = "The description of the ecs task execution role and the ecs task execution policy."
}
