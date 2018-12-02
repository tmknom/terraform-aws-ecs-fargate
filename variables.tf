variable "name" {
  type        = "string"
  description = "The name of ecs service."
}

variable "vpc_id" {
  type        = "string"
  description = "VPC Id to associate with ECS Service."
}

variable "container_definitions" {
  type        = "string"
  description = "A list of valid container definitions provided as a single valid JSON document. "
}

variable "ecs_task_execution_policy" {
  type        = "string"
  description = "The ecs task execution policy document. This is a JSON formatted string."
}

variable "container_port" {
  default     = 80
  type        = "string"
  description = "The container port."
}

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = "list"
  description = "List of Ingress CIDR blocks."
}

variable "cpu" {
  default     = "256"
  type        = "string"
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = "512"
  type        = "string"
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = "list"
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
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

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
