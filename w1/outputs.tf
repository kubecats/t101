output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}
output "arn" {
  value       = aws_instance.example.arn
  description = "ARN of the server"
}
output "aws_ami" {
  value       = aws_instance.example.ami
  description = "ARN of the server"
  sensitive   = true
}
output "server_name" {
  value       = aws_instance.example.id
  description = "Name(id) of the server"
}
# output "ec2_ssh" {
#   description = "The public ssh access"
#   value       = "ssh -i "sandbox-hs.pem" ubuntu@${aws_instance.example.public_ip}"
# }
