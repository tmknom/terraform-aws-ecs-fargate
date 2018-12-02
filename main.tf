# Terraform module which creates ECS Fargate resources on AWS.
#
# NOTE: The volume parameter of ECS Task Definition is not supported for this module.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted.html

# Security Group for ECS Service
#
# NOTE: At this time you cannot use a Security Group with in-line rules
#       in conjunction with any Security Group Rule resources.
#       Doing so will cause a conflict of rule settings and will overwrite rules.
#
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "default" {
  name   = "${local.security_group_name}"
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(map("Name", local.security_group_name), var.tags)}"
}

locals {
  security_group_name = "${var.name}-ecs-fargate"
}

# https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = "${var.container_port}"
  to_port           = "${var.container_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.ingress_cidr_blocks}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

# ECS Task Definitions
#
# The following parameters are not valid in Fargate:
# - ipc_mode
# - pid_mode
# - placement_constraints
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html

# https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html
resource "aws_ecs_task_definition" "default" {
  # A unique name for your task definition.
  family = "${var.name}"

  # The ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "${aws_iam_role.default.arn}"

  # A list of container definitions in JSON format that describe the different containers that make up your task.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions
  container_definitions = "${var.container_definitions}"

  # The number of CPU units used by the task.
  # It can be expressed as an integer using CPU units, for example 1024, or as a string using vCPUs, for example 1 vCPU or 1 vcpu.
  # String values are converted to an integer indicating the CPU units when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  cpu = "${var.cpu}"

  # The amount of memory (in MiB) used by the task.
  # It can be expressed as an integer using MiB, for example 1024, or as a string using GB, for example 1GB or 1 GB.
  # String values are converted to an integer indicating the MiB when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  memory = "${var.memory}"

  # The launch type that the task is using.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#requires_compatibilities
  requires_compatibilities = ["${var.requires_compatibilities}"]

  # Fargate infrastructure support the awsvpc network mode.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#network_mode
  network_mode = "awsvpc"

  # A mapping of tags to assign to the resource.
  tags = "${merge(map("Name", var.name), var.tags)}"
}

# ECS Task Execution IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = "${local.iam_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  path               = "${var.ecs_task_execution_path}"
  description        = "${var.ecs_task_execution_description}"
  tags               = "${merge(map("Name", local.iam_name), var.tags)}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "default" {
  name        = "${local.iam_name}"
  policy      = "${var.ecs_task_execution_policy}"
  path        = "${var.ecs_task_execution_path}"
  description = "${var.ecs_task_execution_description}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

locals {
  iam_name = "${var.name}-ecs-task-execution"
}
