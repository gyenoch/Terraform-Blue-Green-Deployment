##################
# EC2 Instance   #
##################

resource "aws_instance" "blue_app" {
  count                       = var.env == "blue" ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.subnet_1.id
  vpc_security_group_ids      = [data.aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y python3
              cat <<HTML > /home/ubuntu/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Blue Environment</title>
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
                          background-color: blue;
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
                  <h1>Welcome to the Blue Environment</h1>
                  <p>Your Blue-Green Deployment is up and running 🚀</p>
                  <div class="badge">Blue Deployment</div>
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

resource "aws_instance" "green_app" {
  count                       = var.env == "green" ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.subnet_1.id
  vpc_security_group_ids      = [data.aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y python3
              cat <<HTML > /home/ubuntu/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Green Environment</title>
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
                          background-color: green; 
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
                  <h1>Welcome to the Green Environment</h1>
                  <p>Your Blue-Green Deployment is up and running 🚀</p>
                  <div class="badge">Green Deployment</div>
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



# ##################
# # EC2 Instance   #
# ##################

# resource "aws_instance" "app" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.subnet_1.id
#   vpc_security_group_ids      = [aws_security_group.blue_sg.id]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               cat <<HTML > /home/ubuntu/index.html
#               <!DOCTYPE html>
#               <html lang="en">
#               <head>
#                   <meta charset="UTF-8">
#                   <meta name="viewport" content="width=device-width, initial-scale=1.0">
#                   <title>${var.env} Environment</title>
#                   <style>
#                       body {
#                           margin: 0;
#                           height: 100vh;
#                           display: flex;
#                           flex-direction: column;
#                           justify-content: center;
#                           align-items: center;
#                           font-family: 'Segoe UI', sans-serif;
#                           color: white;
#                           background-color: ${var.env == "green" ? "green" : "blue"};
#                       }
#                       h1 {
#                           font-size: 3em;
#                           margin: 0;
#                       }
#                       p {
#                           font-size: 1.2em;
#                           opacity: 0.9;
#                       }
#                       .badge {
#                           margin-top: 20px;
#                           padding: 10px 20px;
#                           border: 2px solid white;
#                           border-radius: 25px;
#                           font-weight: bold;
#                           letter-spacing: 1px;
#                       }
#                   </style>
#               </head>
#               <body>
#                   <h1>Welcome to the ${var.env} Environment</h1>
#                   <p>Your Blue-Green Deployment is up and running 🚀</p>
#                   <div class="badge">${var.env} Deployment</div>
#                   <p>Gyenoch Channel</p>
#               </body>
#               </html>
#               HTML

#               # Start simple HTTP server
#               cd /home/ubuntu
#               nohup python3 -m http.server 80 &
#               EOF


#   tags = {
#     Name = "${var.env}-instance"
#   }
# }