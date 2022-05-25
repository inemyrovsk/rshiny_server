resource "aws_lb" "rstudio" {
  name                   = "rstudio-loadBalancer"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.rstudio.id]
  subnets            = [
    aws_subnet.public-1a.id, aws_subnet.public-2b.id
  ]
  idle_timeout           = 30
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    "Name" = "rstudio-public-lb"
  }

}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "aws_iam_role.ecs_agent.name"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "rshiny-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "rshiny-iam-role"
  }
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

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_lb_target_group" "rstudio" {
  name                          = "rstudio-shiny"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.main.id
  deregistration_delay          = 10
  depends_on = [aws_lb.rstudio]
}

resource "aws_lb_listener" "rstudio_http" {
  load_balancer_arn = aws_lb.rstudio.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "ok"
      status_code  = "200"
    }
  }
}
resource "aws_lb_listener_rule" "rstudio" {
  listener_arn = aws_lb_listener.rstudio_http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rstudio.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}