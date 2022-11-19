# true를 입력받을 경우 Cloudwatch full access policy 생성을 user에 attach 
variable "give_hs_cloudwatch_full_access" {
    description = "If true, hs gets full access to CloudWatch"
    type = bool
}