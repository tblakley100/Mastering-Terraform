locals {
  users_map = {
    for user_info in var.users : user_info.username => user_info.role...
  }
}

locals {
  users_map2 = {
    for username, roles in local.users_map : username => {
      roles = roles
    }
  }
}

locals {
  usernames_from_map = [for username, roles in local.users_map : username]
  # We can also use usernames_from_map = keys(local.users_map) instead of manually creating the list!
}


output "users_map" {
  value = local.users_map
}

output "users_map2" {
  value = local.users_map2
}

output "user_to_output_roles" {
  value = local.users_map2[var.user_to_output].roles
}

output "usernames_from_map" {
  value = local.usernames_from_map
}