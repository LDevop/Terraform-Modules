#in this template we are creating aws application laadbalancer and target group and alb http listener

resource "aws_alb" "alb" {
  name               = "ecs-load-balancer"
  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb-sg.id]
}

resource "aws_alb_target_group" "myapp-tg" {
  name        = "myapp-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.cluster-vpc.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30
    port                = "traffic-port"
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "nginx-app" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port #80
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.myapp-tg]
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.myapp-tg.arn
  }
}
