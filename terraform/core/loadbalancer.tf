resource "aws_lb" "plana_lb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = values(aws_subnet.plana_public)[*].id

  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}

# Output DNS of ALb - useful for quick test to heck availability
output "alb_dns_test_url" {
  value = format("https://%s/test", aws_lb.plana_lb.dns_name)
}

output "alb_nginx_url" {
  value = format("https://%s", aws_lb.plana_lb.dns_name)
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.plana_lb.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.acm_cert.arn
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_alb_target_group.nginx_tg.id
        weight = lookup(var.traffic_dist_map[var.mode], "blue")
      }

      target_group {
        arn    = aws_alb_target_group.squid_tg.id
        weight = lookup(var.traffic_dist_map[var.mode], "green")
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }


  }
}

resource "aws_alb_target_group" "nginx_tg" {
  name_prefix = "blue"

  health_check {
    healthy_threshold   = "2"
    interval            = "300"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "4"
    matcher             = "200-299,302,400-499" # Have seen healthy 302 as well as 200
  }

  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.plana_vpc.id
  target_type = "ip"
}

resource "aws_alb_target_group" "squid_tg" {
  name_prefix = "green"

  health_check {
    healthy_threshold   = "2"
    interval            = "300"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "4"
    matcher             = "200-299,302,400-499" # Squid returns 400's
  }

  port        = "3128"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.plana_vpc.id
  target_type = "ip"
}

# Handy rule to help check ALB is up and accessible.
# Not to be left in in production (can use tfvars to control this with count)
# http://[alb dns]/test
resource "aws_alb_listener_rule" "listener_rule" {
  listener_arn = aws_alb_listener.alb_listener.id
  priority     = 10
  action {
    type = "fixed-response"
    fixed_response {
      status_code  = "200"
      content_type = "text/plain"
      message_body = "ALB Operational"
    }
  }
  condition {
    path_pattern {
      values = ["/test"]
    }

  }
}


resource "aws_security_group" "alb_sg" {
  name        = "ALB traffic"
  description = "Allow traffic to/from ALB"
  vpc_id      = aws_vpc.plana_vpc.id

  ingress {
    description = "TLS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "PlanA ALB SG"
  }
}