# Terraform module which creates ECS Fargate resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted.html

# ECS Task Execution IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = "${var.name}-ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  path               = "${var.ecs_task_execution_path}"
  description        = "${var.ecs_task_execution_description}"
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
  name        = "${var.name}-ecs-task-execution"
  policy      = "${var.ecs_task_execution_policy}"
  path        = "${var.ecs_task_execution_path}"
  description = "${var.ecs_task_execution_description}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}
