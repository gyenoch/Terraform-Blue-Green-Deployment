###################
# VPC and Network #
###################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-sub-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-sub-2"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.rt.id
}

#####################
# Security Group    #
#####################

resource "aws_security_group" "blue_sg" {
  name        = "blue-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

##################
# EC2 Instance   #
##################

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_1.id
  vpc_security_group_ids      = [aws_security_group.blue_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              cat <<HTML > /home/ubuntu/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>${var.env} Environment</title>
                  <style>
                      body {
                          margin: 0;
                          height: 100vh;
                          display: flex;
                          flex-direction: column;
                          justify-content: center;
                          align-items: center;
                          font-family: 'Segoe UI', sans-serif;
                          color: white;
                          background-color: ${var.env == "green" ? "green" : "blue"};
                      }
                      h1 {
                          font-size: 3em;
                          margin: 0;
                      }
                      p {
                          font-size: 1.2em;
                          opacity: 0.9;
                      }
                      .badge {
                          margin-top: 20px;
                          padding: 10px 20px;
                          border: 2px solid white;
                          border-radius: 25px;
                          font-weight: bold;
                          letter-spacing: 1px;
                      }
                  </style>
              </head>
              <body>
                  <h1>Welcome to the ${var.env} Environment</h1>
                  <p>Your Blue-Green Deployment is up and running 🚀</p>
                  <div class="badge">${var.env} Deployment</div>
                  <p>Gyenoch Channel</p>
              </body>
              </html>
              HTML

              # Start simple HTTP server
              cd /home/ubuntu
              nohup python3 -m http.server 80 &
              EOF


  tags = {
    Name = "${var.env}-instance"
  }
}

##########################
# Load Balancer (ALB)    #
##########################

resource "aws_lb" "app_lb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.blue_sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app.id
  port             = 80
}
