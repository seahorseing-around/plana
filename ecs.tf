resource "aws_ecs_cluster" "plana_cluster" {
  name = var.app_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

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
  cluster          = aws_ecs_cluster.plana_cluster.id
  task_definition  = aws_ecs_task_definition.nginx_task.id
  desired_count    = var.num_tasks
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    subnets         = values(aws_subnet.plana_private)[*].id
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx_tg.id
    container_name   = "nginx-app"
    container_port   = 80
  }

}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Traffic into/out of ECS"
  vpc_id      = aws_vpc.plana_vpc.id

  ingress {

    description = "Non TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allows for retrieval of docker container to ECS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PlanA ECS SG"
  }
}