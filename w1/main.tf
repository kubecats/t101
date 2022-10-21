provider "aws" {
  region = "ap-northeast-2"
}

#data "aws_ssm_parameter" "amzn2_latest" {
#  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
#}

data "aws_ssm_parameter" "ubuntu-focal" {
    name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# data "aws_ami" "amazon-2" {
#   most_recent = true

#   filter {
#     name = "name"
#     values = ["amzn2-ami-kernel-*-hvm-*-gp2"]
#   }
#   filter {
#     name = "root-device-type"
#     values = [ "ebs" ]
#   }
#   filter {
#     name = "virtualization-type"
#     values = [ "hvm" ]
#   }
#   filter {
#     name = "architecture"
#     values = [ "x86_64" ]
#   }  
#   owners = ["amazon"]
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_instance" "example" {
  #ami                    = data.aws_ssm_parameter.amzn2_latest.value
  ami                    = data.aws_ssm_parameter.ubuntu-focal.value
  
  # ami                    = data.aws_ami.amazon-2.id
  #ami                    = data.aws_ami.ubuntu.id

  #ami                    = "ami-0e9bfdb247cc8de84"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, LHS ${var.server_port}" > index.html
              nohup busybox httpd -f -p \${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

