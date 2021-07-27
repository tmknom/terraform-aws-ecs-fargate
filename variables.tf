variable "name" {
  type        = string
  description = "The name of ecs service."
}

variable "container_name" {
  type        = string
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)."
}

variable "container_port" {
  type        = string
  description = "The port on the container to associate with the load balancer."
}

variable "cluster" {
  type        = string
  description = "ARN of an ECS cluster."
}

variable "subnets" {
  type        = list(string)
  description = "The subnets associated with the task or service."
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the Load Balancer target group to associate with the service."
}

variable "vpc_id" {
  type        = string
  description = "VPC Id to associate with ECS Service."
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "desired_count" {
  default     = 0
  type        = string
  description = "The number of instances of the task definition to place and keep running."
}

variable "deployment_maximum_percent" {
  default     = 200
  type        = string
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

variable "deployment_minimum_healthy_percent" {
  default     = 100
  type        = string
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

variable "deployment_controller_type" {
  default     = "ECS"
  type        = string
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS."
}

variable "assign_public_ip" {
  default     = false
  type        = string
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false."
}

variable "health_check_grace_period_seconds" {
  default     = 60
  type        = string
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200."
}

variable "platform_version" {
  default     = "1.4.0"
  type        = string
  description = "The platform version on which to run your service."
}

variable "source_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "List of source CIDR blocks."
}

variable "cpu" {
  default     = "256"
  type        = string
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = "512"
  type        = string
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = list(string)
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}

variable "iam_path" {
  default     = "/"
  type        = string
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "enabled" {
  default     = true
  type        = string
  description = "Set to false to prevent the module from creating anything."
}

variable "create_ecs_task_execution_role" {
  default     = true
  type        = string
  description = "Specify true to indicate that ECS Task Execution IAM Role creation."
}

variable "ecs_task_execution_role_arn" {
  default     = ""
  type        = string
  description = "The ARN of the ECS Task Execution IAM Role."
}

variable "create_ecs_task_role" {
  default     = true
  type        = string
  description = "Specify true to indicate that ECS Task IAM Role creation."
}

variable "ecs_task_role_arn" {
  default     = ""
  type        = string
  description = "The ARN of the ECS Task IAM Role."
}
