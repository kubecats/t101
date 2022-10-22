# variable "server_port" {
#   description = "The port the server will use for HTTP requests"
#   type        = number
#   # default     = 50000
# }
# variable "ssh_port" {
#   description = "ssh_port"
#   type = number
#   # default = 22
# }
variable "server_name" {
  description = "server_name"
  type = string
  default = "hs"
}
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}
variable "instance_type" {
  description = "var.instance_type"
  type = string
  default = "t2.micro"
}
variable "ingresses" {
  type = map(object({
    from_port = number
    to_port   = number
  }))
  default = {
      ssh = {
        from_port = 22
        to_port   = 22
      },
      service = {
        from_port = 50000
        to_port   = 50000
      }
  }
}
