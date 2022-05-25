resource "aws_ecs_cluster" "rstudio_cluster" {
  name = "rstudio-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_launch_configuration" "rshiny_ecs" {
  name                 = "rshiny-service-launch-configuration"
  image_id             = var.ami_for_cluster
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  instance_type        = "t2.micro"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=rstudio-cluster >> /etc/ecs/ecs.config"
  key_name             = "rstudio"
  security_groups      = [aws_security_group.rstudio.id]

}

resource "aws_autoscaling_group" "rshiny_ecs" {
  name                      = "rshiny-ecs-autoscaling-group"
  max_size                  = 2
  min_size                  = 0
  max_instance_lifetime     = 604800
  vpc_zone_identifier       = [aws_subnet.public-1a.id]
  wait_for_capacity_timeout = "10m"
  launch_configuration      = aws_launch_configuration.rshiny_ecs.name

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "services-rsudio-cluster"
  }
}

resource "aws_ecs_capacity_provider" "rstudio" {
  name = "rshiny-service-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.rshiny_ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      target_capacity           = 100
    }
  }
}
