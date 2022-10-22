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
  subnet_id = aws_subnet.first_public_subnet.id
  associate_public_ip_address = true
  # key_name = 
  vpc_security_group_ids = [aws_security_group.instance["ssh"].id, aws_security_group.instance["service"].id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, LHS ${var.ingresses.service.from_port}" > index.html
              nohup busybox httpd -f -p \${var.ingresses.service.from_port} &
              EOF

  # user_data = <<-EOF
  #             #!/bin/bash
  #             wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
  #             mv busybox-x86_64 busybox
  #             chmod +x busybox
  #             RZAZ=\$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
  #             IID=\$(curl 169.254.169.254/latest/meta-data/instance-id)
  #             LIP=\$(curl 169.254.169.254/latest/meta-data/local-ipv4)
  #             echo "<h1>RegionAz(\$RZAZ) : Instance ID(\$IID) : Private IP(\$LIP) : Web Server</h1>" > index.html
  #             nohup ./busybox httpd -f -p 80 &
  #             EOF

  user_data_replace_on_change = true

  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id
  for_each = var.ingresses
  name = each.key

  ingress {
    from_port   = each.value.from_port
    to_port     = each.value.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sg_test" {
  # value = aws_security_group.instance["ssh"]
  value = var.ingresses.service.from_port
}
