provider "aws" {
  region  = "ap-northeast-2"
}

# vpc 생성 : cidr 맵핑
resource "aws_vpc" "hsvpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_hostnames = true # default : false

  tags = {
    Name = "hs-vpc"
  }
}

# subnet 생성 : vpc 와 맵핑
resource "aws_subnet" "hssubnet1" {
  vpc_id     = aws_vpc.hsvpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "hs-subnet1"
  }
}

resource "aws_subnet" "hssubnet2" {
  vpc_id     = aws_vpc.hsvpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "hs-subnet2"
  }
}

# igw 생성 : vpc와 맵핑
resource "aws_internet_gateway" "hsigw" {
  vpc_id = aws_vpc.hsvpc.id

  tags = {
    Name = "hs-igw"
  }
}

# routing table 생성 : vpc와 맵핑
resource "aws_route_table" "hsrt" {
  vpc_id = aws_vpc.hsvpc.id

  tags = {
    Name = "hs-rt"
  }
}

# routing 연결 생성 : routing table과 subnet 을 맵핑
resource "aws_route_table_association" "hsrtassociation1" {
  subnet_id      = aws_subnet.hssubnet1.id
  route_table_id = aws_route_table.hsrt.id
}

resource "aws_route_table_association" "hsrtassociation2" {
  subnet_id      = aws_subnet.hssubnet2.id
  route_table_id = aws_route_table.hsrt.id
}

# routing 등록 : routing table에 맵핑
resource "aws_route" "hsdefaultroute" {
  route_table_id         = aws_route_table.hsrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hsigw.id
}

# security group : vpc 와 맵핑
resource "aws_security_group" "hssg" {
  vpc_id      = aws_vpc.hsvpc.id
  name        = "hs SG"
  description = "hs SG"
}

# security group rule : sg과 맵핑
resource "aws_security_group_rule" "hssginbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hssg.id
}

resource "aws_security_group_rule" "hssgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # 모든 프로토콜
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hssg.id
}