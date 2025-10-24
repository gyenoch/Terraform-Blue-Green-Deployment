################################################################
### VARIABLES
################################################################

variable "env" {
  description = "Environment name: blue or green"
  type        = string
}

variable "lb_name" {
  description = "Name of Load Balancer"
  default     = "blue-green-alb"
}

################################################################
### DATA SOURCE
################################################################

# Fetch existing Load Balancer Listener
data "aws_lb_listener" "existing_listener" {
  load_balancer_arn = data.aws_lb.app_lb.arn
  port              = 80
}

# Fetch existing Blue Target Group
data "aws_lb_target_group" "blue_tg" {
  name = "blue-tg"
}

# Fetch existing Green Target Group
data "aws_lb_target_group" "green_tg" {
  name = "green-tg"
}

# Fetch existing Load Balancer
data "aws_lb" "app_lb" {
  name = var.lb_name
}

################################################################
### LOAD BALANCER LISTENER RULE
################################################################

resource "aws_lb_listener_rule" "switch_traffic" {
  listener_arn = data.aws_lb_listener.existing_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.green_tg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

