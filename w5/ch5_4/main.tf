# resource "aws_instance" "example_1" {
#     count = 2
#     ami = "ami-0eddbd81024d3fbdd"
#     instance_type = "t2.micro"
# }

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "example_2" {
    count = length(data.aws_availability_zones.available.names)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    ami = "ami-0eddbd81024d3fbdd"
    instance_type = "t2.micro"
}

output "zone" {
    value = data.aws_availability_zones.available.names
}
