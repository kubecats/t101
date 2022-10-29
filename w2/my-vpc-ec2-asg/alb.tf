resource "aws_lb" "hsalb" {
  name               = "hs-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.hssubnet1.id, aws_subnet.hssubnet2.id]
  security_groups = [aws_security_group.hssg.id]

  tags = {
    Name = "hs-alb"
  }
}

resource "aws_lb_listener" "hshttp" {
  load_balancer_arn = aws_lb.hsalb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - hs"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "hsalbtg" {
  name = "hs-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.hsvpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "hsalbrule" {
  listener_arn = aws_lb_listener.hshttp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hsalbtg.arn
  }
}

output "hsalb_dns" {
  value       = aws_lb.hsalb.dns_name
  description = "The DNS Address of the ALB"
}
