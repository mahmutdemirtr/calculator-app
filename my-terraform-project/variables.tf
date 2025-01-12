provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# En güncel Amazon Linux 2 AMI'yi al
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group oluştur
resource "aws_security_group" "example_sg" {
  name        = "example_security_group"
  description = "Allow SSH, HTTP, and HTTPS access"

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

  ingress {
    from_port   = 443
    to_port     = 443
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

# EC2 instance oluştur ve User Data ekle
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest.id
  instance_type = "t2.micro"

  # Güvenlik grubunu ilişkilendir
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  # User Data script
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 git
              git clone https://github.com/mahmutdemirtr/calculator-app.git
              cd calculator-app
              pip3 install -r requirements.txt
              python3 app.py &
              EOF

  tags = {
    Name = "ExampleInstance"
  }
}
