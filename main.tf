# Terraform module which creates ECS Fargate resources on AWS.
#
# NOTE: The volume parameter of ECS Task Definition is not supported for this module.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted.html

# ECS Service
#
# The Fargate launch type allows you to run your containerized applications
# without the need to provision and manage the backend infrastructure.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_parameters.html

# https://www.terraform.io/docs/providers/aws/r/ecs_service.html
resource "aws_ecs_service" "default" {
  # The name of your service. Up to 255 letters (uppercase and lowercase), numbers, hyphens, and underscores are allowed.
  # Service names must be unique within a cluster, but you can have similarly named services
  # in multiple clusters within a region or across multiple regions.
  name = "${var.name}"

  # The family and revision (family:revision) or full ARN of the task definition to run in your service.
  # If a revision is not specified, the latest ACTIVE revision is used.
  task_definition = "${aws_ecs_task_definition.default.arn}"

  # The short name or full Amazon Resource Name (ARN) of the cluster on which to run your service.
  # If you do not specify a cluster, the default cluster is assumed.
  cluster = "${var.cluster}"

  # The number of instantiations of the specified task definition to place and keep running on your cluster.
  desired_count = "${var.desired_count}"

  # The maximumPercent parameter represents an upper limit on the number of your service's tasks
  # that are allowed in the RUNNING or PENDING state during a deployment,
  # as a percentage of the desiredCount (rounded down to the nearest integer).
  deployment_maximum_percent = "${var.deployment_maximum_percent}"

  # The minimumHealthyPercent represents a lower limit on the number of your service's tasks
  # that must remain in the RUNNING state during a deployment,
  # as a percentage of the desiredCount (rounded up to the nearest integer).
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  deployment_controller {
    # The deployment controller type to use. Valid values: CODE_DEPLOY, ECS.
    type = "${var.deployment_controller_type}"
  }

  # The network configuration for the service. This parameter is required for task definitions
  # that use the awsvpc network mode to receive their own Elastic Network Interface.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html
  network_configuration {
    subnets         = ["${var.subnets}"]
    security_groups = ["${aws_security_group.default.id}"]

    # Whether the task's elastic network interface receives a public IP address.
    assign_public_ip = "${var.assign_public_ip}"
  }

  # The launch type on which to run your service.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_types.html
  launch_type = "FARGATE"

  # Note that Fargate tasks do support only the REPLICA scheduling strategy.
  #
  # The replica scheduling strategy places and maintains the desired number of tasks across your cluster.
  # By default, the service scheduler spreads tasks across Availability Zones.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html#service_scheduler_replica
  scheduling_strategy = "REPLICA"
}

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
