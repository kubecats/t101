# provider "aws" {
#     region = "ap-northeast-2"
# }
 
# variable "user_names" {
#   description = "Create IAM users with these names"
#   type        = list(string)
#   default     = ["aaa", "ccc"]
# }
 
# resource "aws_iam_user" "for_each_set" {
#   for_each = toset(var.user_names)
#   name = each.key # each.key == each.value
# }


# variable fruits {
#   type        = set(string)
#   default     = ["apple", "banana"]
#   description = "fruit example"
# }
 
provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_iam_user" "example"{
    count = 3
    name = "hs.${count.index}"
}