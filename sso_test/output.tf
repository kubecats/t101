output "sso_arn" {
   value = aws_ssoadmin_permission_set.example.arn
}

output "sso_id" {
  value = aws_ssoadmin_permission_set.example.id
}

output "sso_created_date" {
  value = aws_ssoadmin_permission_set.example.created_date
}

output "sso_tags_all" {
  value = aws_ssoadmin_permission_set.example.tags_all
}

output "sso_inlinepolicy" {
  value = aws_ssoadmin_permission_set_inline_policy.example.id
}

output "group_id" {
  value = aws_identitystore_group.example.group_id
}