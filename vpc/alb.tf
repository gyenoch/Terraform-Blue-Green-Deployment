##########################
# Load Balancer (ALB)    #
##########################

resource "aws_lb" "app_lb" {
  name               = "blue-green-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name = "blue-green-alb"
  }
}
