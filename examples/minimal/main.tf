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
