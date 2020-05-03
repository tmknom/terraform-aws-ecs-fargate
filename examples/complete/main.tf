module "ecs_fargate" {
  source           = "../../"
  name             = "example"
  container_name   = local.container_name
  container_port   = local.container_port
  cluster          = aws_ecs_cluster.example.arn
  subnets          = module.vpc.public_subnet_ids
  target_group_arn = module.alb.alb_target_group_arn
  vpc_id           = module.vpc.vpc_id

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])

  desired_count                      = 2
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller_type         = "ECS"
  assign_public_ip                   = true
  health_check_grace_period_seconds  = 10
  platform_version                   = "LATEST"
  source_cidr_blocks                 = ["0.0.0.0/0"]
  cpu                                = 256
  memory                             = 512
  requires_compatibilities           = ["FARGATE"]
  iam_path                           = "/service_role/"
  description                        = "This is example"
  enabled                            = true

  create_ecs_task_execution_role = false
  ecs_task_execution_role_arn    = aws_iam_role.default.arn

  tags = {
    Environment = "prod"
  }
}

resource "aws_iam_role" "default" {
  name               = "ecs-task-execution-for-ecs-fargate"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
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

resource "aws_iam_policy" "default" {
  name   = aws_iam_role.default.name
  policy = data.aws_iam_policy.ecs_task_execution.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  container_name = "example"
  container_port = tonumber(module.alb.alb_target_group_port)
}

resource "aws_ecs_cluster" "example" {
  name = "default"
}

module "alb" {
  source                     = "git::https://github.com/tmknom/terraform-aws-alb.git?ref=tags/2.1.0"
  name                       = "ecs-fargate"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnet_ids
  access_logs_bucket         = module.s3_lb_log.s3_bucket_id
  enable_https_listener      = false
  enable_http_listener       = true
  enable_deletion_protection = false
}

module "s3_lb_log" {
  source                = "git::https://github.com/tmknom/terraform-aws-s3-lb-log.git?ref=tags/2.0.0"
  name                  = "s3-lb-log-ecs-fargate-${data.aws_caller_identity.current.account_id}"
  logging_target_bucket = module.s3_access_log.s3_bucket_id
  force_destroy         = true
}

module "s3_access_log" {
  source        = "git::https://github.com/tmknom/terraform-aws-s3-access-log.git?ref=tags/2.0.0"
  name          = "s3-access-log-ecs-fargate-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/2.0.1"
  cidr_block                = local.cidr_block
  name                      = "ecs-fargate"
  public_subnet_cidr_blocks = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1)]
  public_availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_block = "10.255.0.0/16"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}
