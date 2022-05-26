resource "aws_ecr_repository" "rshiny" {
  name                 = "rshiny-repo"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "rshiny-repo-policy" {
  repository = aws_ecr_repository.rshiny.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the rshiny repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

#resource "aws_secretsmanager_secret" "rstudio_env" {
#  name        = "rstudio"
#  description = "Rstudio username and password"
#  tags        = {
#    Name = "rstudio"
#  }
#}
#
#
#resource "aws_secretsmanager_secret_version" "rstudio_env" {
#  secret_id = aws_secretsmanager_secret.rstudio_env.id
#
#  lifecycle {
#    ignore_changes = [
#      secret_string
#    ]
#  }
#}

#locals {
#  password = jsondecode(aws_secretsmanager_secret_version.rstudio_env.secret_string)["password"]
#  username = jsondecode(aws_secretsmanager_secret_version.rstudio_env.secret_string)["username"]
#}

resource "aws_ecs_task_definition" "rstudio_service" {
  family                   = "shiny"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "bridge"
  container_definitions    = jsonencode([
    {
      name         = "rshiny"
      image        = "138941284341.dkr.ecr.eu-central-1.amazonaws.com/rshiny-repo:${var.docker_image_tag}"
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          containerPort = 3838
          protocol      = "tcp"
          hostPort      = 3838
        },
        {
          containerPort = 8787
          protocol      = "tcp"
          hostPort      = 8787
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "rshiny" {
  name                               = "rshiny"
  cluster                            = aws_ecs_cluster.rstudio_cluster.id
  task_definition                    = aws_ecs_task_definition.rstudio_service.arn
  launch_type                        = "EC2"
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  force_new_deployment               = true
  health_check_grace_period_seconds  = 0
  deployment_minimum_healthy_percent = 0
  propagate_tags                     = "NONE"

  load_balancer {
    container_name   = "rshiny"
    container_port   = 3838
    target_group_arn = aws_lb_target_group.rstudio.arn
  }

  tags = {
    Name = "rshiny"
  }

}