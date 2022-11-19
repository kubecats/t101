# example1
# resource "aws_instance" "example_1" {
#     count = 2
#     ami = "ami-0eddbd81024d3fbdd"
#     instance_type = "t2.micro"
# }

# example2
# Declare the data source
# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_instance" "example_2" {
#     count = length(data.aws_availability_zones.available.names)
#     availability_zone = data.aws_availability_zones.available.names[count.index]
#     ami = "ami-0eddbd81024d3fbdd"
#     instance_type = "t2.micro"
# }

# output "zone" {
#     value = data.aws_availability_zones.available.names
# }

# example3 - terraform 은 plan단계에서 count와 for_each를 계산할 수 있어야 한다.
# 계산된 리소스 출력은 참조할 수 없다.
resource "random_integer" "num_instances" {
    min = 1
    max = 3
}

resource "aws_instance" "example_3" {
    count = random_integer.num_instances.result
    ami = "ami-0eddbd81024d3fbdd"
    instance_type = "t2.micro"
}


