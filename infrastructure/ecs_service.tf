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
  container_definitions    = jsonencode([
    {
      name         = "rshiny"
      image        = "inemyrovsk/shiny-server:${var.docker_image_tag_shiny}"
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          containerPort = 3838
          protocol      = "tcp"
          hostPort      = 3838
        }
      ]
      environment = [
        {
          "name" : "USER",
          "value" : "default"
        },
        {
          "name" : "PASSWORD",
          "value" : "default"
        },
        {
          "name" : "ROOT",
          "value" : "TRUE"
        },
        {
          "name" : "PERUSER",
          "value" : "FALSE"
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "rshiny" {
  name                              = "rshiny"
  cluster                           = aws_ecs_cluster.rstudio_cluster.id
  task_definition                   = aws_ecs_task_definition.rstudio_service.arn
  launch_type                       = "EC2"
  desired_count                     = 1
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  propagate_tags                    = "NONE"

  load_balancer {
    container_name   = "rshiny"
    container_port   = 3838
    target_group_arn = aws_lb_target_group.rstudio.arn
  }

  tags = {
    Name = "rshiny"
  }

}