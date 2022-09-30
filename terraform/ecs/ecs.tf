resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "${var.app_name}-service-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "nginx-app"
      image     = "nginx:latest"
      cpu       = 512
      memory    = 2048
      essential = true # if true and if fails, all other containers fail. Must have at least one essential
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "nginx_service" {
  name             = "${var.app_name}_nginx_service"
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.nginx_task.id
  desired_count    = lookup(var.num_tasks[var.tasks], "blue")
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = [var.ecs_sg]
    subnets         = var.priv_subnets
  }

  load_balancer {
    target_group_arn = var.blue_tg
    container_name   = "nginx-app"
    container_port   = 80
  }
}



resource "aws_ecs_task_definition" "squid_task" {
  family                   = "squid-service-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "squid"
      image     = "ubuntu/squid:latest"
      cpu       = 512
      memory    = 2048
      essential = true # if true and if fails, all other containers fail. Must have at least one essential
      portMappings = [
        {
          containerPort = 3128
          hostPort      = 3128
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "squid_service" {
  name             = "squid_nginx_service"
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.squid_task.id
  desired_count    = lookup(var.num_tasks[var.tasks], "green")
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = [var.ecs_sg]
    subnets         = var.priv_subnets
  }

  load_balancer {
    target_group_arn = var.green_tg
    container_name   = "squid"
    container_port   = 3128
  }
}