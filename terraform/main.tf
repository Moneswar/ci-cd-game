provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "game_server" {
  ami           = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251212" 
  instance_type = "t3.small"
  key_name      = "jenkins"

  security_groups = [aws_security_group.game-sg-jenkins.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Game-Server"
  }
}

resource "aws_security_group" "gamenew" {
  name = "gamenew"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}
output "public_ip" {
  value = aws_instance.game_server.public_ip
}
