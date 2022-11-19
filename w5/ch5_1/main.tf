# resource "aws_iam_user" "example"{
#     count = 3
#     name = "hs.${count.index}"
# }

# count 를 통한 iam user 생성/삭제 실습
# resource "aws_iam_user" "example" {
#   count = length(var.user_names)
#   name = var.user_names[count.index]
# }

# output "aaa_arn" {
#   value = aws_iam_user.example[0].arn
#   description = "The ARN for user aaa"
# }

# output "all_arn" {
#   value = aws_iam_user.example[*].arn
#   description = "The ARNs for all users"
# }


# for_each 를 통한 iam user 생성/삭제 실습
# resource "aws_iam_user" "example" {
#   # toset: var.user_names 를 list-> set(집합) 변환
#   for_each = toset(var.user_names)
#   name = each.value
# }

# output "all_users" {
#   value = aws_iam_user.example
# }


# resource "aws_autoscaling_group" "example"{
#   launch_configuration = aws_launch_configuration.example.name
#   vpc_zone_identifier = data.aws_subnet_ids.default.ids
#   target_group_arns = [aws_lb_target_group.asg.arn]
#   health_check_type = "ELB"

#   min_size = var.min_size
#   max_size = var.max_size
  
#   tag {
#     key = "Name"
#     value = var.cluster_name
#     propagate_at_launch = true
#   }
# }