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

  ingress {
    description = "Non TLS from VPC - Squid"
    from_port   = 3128
    to_port     = 3128
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

resource "aws_ecs_cluster" "plana_cluster" {
  name = var.app_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}