locals {
  common_tags = {
    Project = "t101"
    Owner = "hs"
  }
}

# vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  enable_dns_hostnames = true # 기본값이 false
  enable_dns_support = true # 기본값이 true
  
  tags = local.common_tags
}


# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = local.common_tags

}

# public subnet
resource "aws_subnet" "first_public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = local.common_tags
}

resource "aws_subnet" "second_public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true


  tags = local.common_tags
}

# private subnet
resource "aws_subnet" "first_private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "ap-northeast-2a"

  tags = local.common_tags

}

resource "aws_subnet" "second_private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  availability_zone = "ap-northeast-2c"

  tags = local.common_tags

}

# route table__public
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  tags = local.common_tags
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.first_public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.second_public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route" "public" {
  route_table_id              = aws_route_table.route_table.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

# route table__private
resource "aws_route_table" "route_table_private_1" {
  vpc_id = aws_vpc.main.id
  tags = local.common_tags
}

resource "aws_route_table" "route_table_private_2" {
  vpc_id = aws_vpc.main.id
  tags = local.common_tags
}

resource "aws_route_table_association" "route_table_association_private_1" {
  subnet_id      = aws_subnet.first_private_subnet.id
  route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "route_table_association_private_2" {
  subnet_id      = aws_subnet.second_private_subnet.id
  route_table_id = aws_route_table.route_table_private_2.id
}

resource "aws_route" "private_nat_1" {
  route_table_id              = aws_route_table.route_table_private_1.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_nat_2" {
  route_table_id              = aws_route_table.route_table_private_2.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway_2.id
}

# eip
resource "aws_eip" "nat_1" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat_2" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

# nat gateway
resource "aws_nat_gateway" "nat_gateway_1" {
  # eip를 연결
  allocation_id = aws_eip.nat_1.id

  # Private subnet이 아닌 public subnet을 연결
  subnet_id = aws_subnet.first_public_subnet.id
  tags = local.common_tags

}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id = aws_subnet.second_public_subnet.id
  tags = local.common_tags

}