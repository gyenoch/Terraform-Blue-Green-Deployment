###################################################
# Target Groups For Both Blue and Green Environment 
####################################################
resource "aws_lb_target_group" "blue_tg" {
  count    = var.env == "blue" ? 1 : 0
  name     = "blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "green_tg" {
  count    = var.env == "green" ? 1 : 0
  name     = "green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "blue_attachment" {
  count            = var.env == "blue" ? 1 : 0
  target_group_arn = aws_lb_target_group.blue_tg[0].arn
  target_id        = aws_instance.blue_app[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green_attachment" {
  count            = var.env == "green" ? 1 : 0
  target_group_arn = aws_lb_target_group.green_tg[0].arn
  target_id        = aws_instance.green_app[0].id
  port             = 80
}

resource "aws_lb_listener" "app_listener" {
  count             = var.env == "blue" ? 1 : 0
  load_balancer_arn = data.aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue_tg[0].arn
  }
}

