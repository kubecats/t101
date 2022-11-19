# variable "user_names" {
#   description = "Create IAM Users with these names"
#   type = list(string)
#   default = ["aaa", "ccc"]
#   # default = ["aaa", "ccc"]
# }

variable "names" {
  description = "A list of names"
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}

# output "upper_names" {
#   value = [for name in var.names : upper(name)]
# }

# output "short_upper_names" {
#   value = [for name in var.names : upper(name) if length(name) < 5]
# }


# variable "hero_thousand_faces" {
#   description = "map"
#   type = map(string)
#   default = {
#     neo = "hero"
#     trinity = "love interest"
#     morpheus = "mentor"
#   }
# }

# # list를 반복하고 map을 출력
#   output "bios" {
#     value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
#   }

# # map(key,value) 을 반복하고 list를 출력
#   output "upper_roles" {
#     value = {for name, role in var.hero_thousand_faces : upper(name) => upper(role)}
#   }

  # for반복문
    output "for_directive_strip_marker" {
      value = <<EOF
      %{~ for name in var.names }
        ${name}
      %{~ endfor }
        EOF
    }
