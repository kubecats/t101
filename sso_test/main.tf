data "aws_ssoadmin_instances" "example" {}

# [권한세트] sso_permission_set 생성
data "aws_ssoadmin_permission_set" "example" {
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  name         = "T101-Admin"
}

resource "aws_ssoadmin_permission_set" "example" {
  name             = "T101-Admin"
  description      = "T101-Administrator"
  instance_arn     = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=us-east-1#" #릴레이 상태
  session_duration = "PT4H" #세션시간
}


# [권한세트] aws_ssoadmin_managed_policy_attachment
resource "aws_ssoadmin_managed_policy_attachment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.example.arn
}


# [권한세트] inline_policy_attachment
data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "example" {
  inline_policy      = data.aws_iam_policy_document.example.json
  instance_arn       = aws_ssoadmin_permission_set.example.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example.arn
}



###################################
# [그룹] aws_identifystore_group 생성
###################################
resource "aws_identitystore_group" "example" {
  for_each = var.group_info

  display_name      = "T101-Admin"
  description       = "T101 - Operation Admin"
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  display_name   = each.value.display_name
  description   = each.value.description

}
variable "group_info" {
  description = "group_r info"
  type        = map(any)
}


###################################
# [사용자] aws_identifystore_user 생성
###################################
resource "aws_identitystore_user" "example" {
  for_each = var.user_info

  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  display_name   = each.value.display_name
  user_name   = each.value.user_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value = each.value.emails
  }
}

variable "user_info" {
  description = "user_info"
  type        = map(any)
}

######################################################
# [그룹/사용자] identitystore_group_membership : group 과 user 간 연걀
######################################################
resource "aws_identitystore_group_membership" "example" {
  for_each = var.user_info

  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  group_id          = aws_identitystore_group.example.group_id
  member_id         = aws_identitystore_user.example[each.key].user_id
}


## Permission set, account, Group을 연결
resource "aws_ssoadmin_account_assignment" "example" {
  for_each = var.account_info

  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.example.arn #희망하는 권한세트 지정

  principal_id   = aws_identitystore_group.example.group_id #희망하는 그룹 지정
  principal_type = "GROUP"

  target_id   = each.value.account_no
  target_type = "AWS_ACCOUNT"
}

variable "account_info" {
  description = "account_info"
  type        = map(any)
}

account_info = {
  universal-ntw = {
    account_no    = "11111111111",
    account_label = "T101 test"
  }
}

## SSO User ##
## user_name, emails은 유일한 값
user_info = {
  no1 = {
    display_name    = "t101(t101) - hs",
    user_name = "hs",
    given_name = "hs",
    family_name= "lee",
    emails = "hs.lee@amazon.com"
  }
}

## SSO Group ##
group_info = {
  no1 = {
    display_name    = "T101-Admin",
    description = "T101 - Operation Admin"
  },
  no2 = {
    display_name    = "T202-Admin",
    description = "T202 - Admin"
  }
}