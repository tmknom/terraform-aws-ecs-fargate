# terraform-aws-ecs-fargate

[![CircleCI](https://circleci.com/gh/tmknom/terraform-aws-ecs-fargate.svg?style=svg)](https://circleci.com/gh/tmknom/terraform-aws-ecs-fargate)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-ecs-fargate.svg)](https://registry.terraform.io/modules/tmknom/ecs-fargate/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-ecs-fargate.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates ECS Fargate resources on AWS.

## Description

Provision [ECS Service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) and
[ECS Task Definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html).

This module provides recommended settings:

- Fargate launch type
- Disable assign public ip address

## Usage

### Minimal

```hcl
module "ecs_fargate" {
  source                = "git::https://github.com/tmknom/terraform-aws-ecs-fargate.git?ref=tags/1.4.0"
  name                  = "example"
  container_name        = "nginx"
  container_port        = "80"
  cluster               = "${var.ecs_cluster_arn}"
  subnets               = ["${var.subnets}"]
  target_group_arn      = "${var.target_group_arn}"
  vpc_id                = "${var.vpc_id}"
  container_definitions = "${var.container_definitions}"
}
```

### Complete

```hcl
module "ecs_fargate" {
  source                = "git::https://github.com/tmknom/terraform-aws-ecs-fargate.git?ref=tags/1.4.0"
  name                  = "example"
  container_name        = "nginx"
  container_port        = "80"
  cluster               = "${var.ecs_cluster_arn}"
  subnets               = ["${var.subnets}"]
  target_group_arn      = "${var.target_group_arn}"
  vpc_id                = "${var.vpc_id}"
  container_definitions = "${var.container_definitions}"

  desired_count                      = 2
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller_type         = "ECS"
  assign_public_ip                   = true
  health_check_grace_period_seconds  = 10
  ingress_cidr_blocks                = ["0.0.0.0/0"]
  cpu                                = 256
  memory                             = 512
  requires_compatibilities           = ["FARGATE"]
  iam_path                           = "/service_role/"
  iam_description                    = "example description"
  enabled                            = true

  create_ecs_task_execution_role = false
  ecs_task_execution_role_arn    = "${var.ecs_task_execution_role_arn}"

  tags = {
    Environment = "prod"
  }
}
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-ecs-fargate/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-ecs-fargate/tree/master/examples/complete)

## Inputs

| Name                               | Description                                                                                                                                                           |  Type  |        Default         | Required |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----: | :--------------------: | :------: |
| cluster                            | ARN of an ECS cluster.                                                                                                                                                | string |           -            |   yes    |
| container_definitions              | A list of valid container definitions provided as a single valid JSON document.                                                                                       | string |           -            |   yes    |
| container_name                     | The name of the container to associate with the load balancer (as it appears in a container definition).                                                              | string |           -            |   yes    |
| container_port                     | The port on the container to associate with the load balancer.                                                                                                        | string |           -            |   yes    |
| name                               | The name of ecs service.                                                                                                                                              | string |           -            |   yes    |
| subnets                            | The subnets associated with the task or service.                                                                                                                      |  list  |           -            |   yes    |
| target_group_arn                   | The ARN of the Load Balancer target group to associate with the service.                                                                                              | string |           -            |   yes    |
| vpc_id                             | VPC Id to associate with ECS Service.                                                                                                                                 | string |           -            |   yes    |
| assign_public_ip                   | Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false.                                                                     | string |        `false`         |    no    |
| cpu                                | The number of cpu units used by the task.                                                                                                                             | string |         `256`          |    no    |
| create_ecs_task_execution_role     | Specify true to indicate that ECS Task Execution IAM Role creation.                                                                                                   | string |         `true`         |    no    |
| deployment_controller_type         | Type of deployment controller. Valid values: CODE_DEPLOY, ECS.                                                                                                        | string |         `ECS`          |    no    |
| deployment_maximum_percent         | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment.                  | string |         `200`          |    no    |
| deployment_minimum_healthy_percent | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. | string |         `100`          |    no    |
| desired_count                      | The number of instances of the task definition to place and keep running.                                                                                             | string |          `0`           |    no    |
| ecs_task_execution_role_arn        | The ARN of the ECS Task Execution IAM Role.                                                                                                                           | string |        `` | no         |
| enabled                            | Set to false to prevent the module from creating anything.                                                                                                            | string |         `true`         |    no    |
| health_check_grace_period_seconds  | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200.                                          | string |          `60`          |    no    |
| iam_description                    | The description of the IAM Role and the IAM Policy.                                                                                                                   | string | `Managed by Terraform` |    no    |
| iam_path                           | Path in which to create the IAM Role and the IAM Policy.                                                                                                              | string |          `/`           |    no    |
| ingress_cidr_blocks                | List of Ingress CIDR blocks.                                                                                                                                          |  list  |   `[ "0.0.0.0/0" ]`    |    no    |
| memory                             | The amount (in MiB) of memory used by the task.                                                                                                                       | string |         `512`          |    no    |
| requires_compatibilities           | A set of launch types required by the task. The valid values are EC2 and FARGATE.                                                                                     |  list  |    `[ "FARGATE" ]`     |    no    |
| tags                               | A mapping of tags to assign to all resources.                                                                                                                         |  map   |          `{}`          |    no    |

## Outputs

| Name                         | Description                                                           |
| ---------------------------- | --------------------------------------------------------------------- |
| ecs_service_cluster          | The Amazon Resource Name (ARN) of cluster which the service runs on.  |
| ecs_service_desired_count    | The number of instances of the task definition.                       |
| ecs_service_iam_role         | The ARN of IAM role used for ELB.                                     |
| ecs_service_id               | The Amazon Resource Name (ARN) that identifies the service.           |
| ecs_service_name             | The name of the service.                                              |
| ecs_task_definition_arn      | Full ARN of the Task Definition (including both family and revision). |
| ecs_task_definition_family   | The family of the Task Definition.                                    |
| ecs_task_definition_revision | The revision of the task in a particular family.                      |
| iam_policy_arn               | The ARN assigned by AWS to this IAM Policy.                           |
| iam_policy_description       | The description of the IAM Policy.                                    |
| iam_policy_document          | The policy document of the IAM Policy.                                |
| iam_policy_id                | The IAM Policy's ID.                                                  |
| iam_policy_name              | The name of the IAM Policy.                                           |
| iam_policy_path              | The path of the IAM Policy.                                           |
| iam_role_arn                 | The Amazon Resource Name (ARN) specifying the IAM Role.               |
| iam_role_create_date         | The creation date of the IAM Role.                                    |
| iam_role_description         | The description of the IAM Role.                                      |
| iam_role_name                | The name of the IAM Role.                                             |
| iam_role_unique_id           | The stable and unique string identifying the IAM Role.                |
| security_group_arn           | The ARN of the ECS Service security group.                            |
| security_group_description   | The description of the ECS Service security group.                    |
| security_group_egress        | The egress rules of the ECS Service security group.                   |
| security_group_id            | The ID of the ECS Service security group.                             |
| security_group_ingress       | The ingress rules of the ECS Service security group.                  |
| security_group_name          | The name of the ECS Service security group.                           |
| security_group_owner_id      | The owner ID of the ECS Service security group.                       |
| security_group_vpc_id        | The VPC ID of the ECS Service security group.                         |

## Development

### Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-ecs-fargate.git
cd terraform-aws-ecs-fargate
make install
```

### Makefile targets

```text
check-format                   Check format code
cibuild                        Execute CI build
clean                          Clean .terraform
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
release                        Release GitHub and Terraform Module Registry
terraform-apply-complete       Run terraform apply examples/complete
terraform-apply-minimal        Run terraform apply examples/minimal
terraform-destroy-complete     Run terraform destroy examples/complete
terraform-destroy-minimal      Run terraform destroy examples/minimal
terraform-plan-complete        Run terraform plan examples/complete
terraform-plan-minimal         Run terraform plan examples/minimal
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/ecs-fargate/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
