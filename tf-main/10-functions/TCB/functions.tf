locals {
  name = "fred Blakley"
  age  = 52
  my_object = {
    key1 = 77
    key2 = "my_tcb_value"
  }
}

output "example1" {
  value = startswith(lower(local.name), "fred")
}

output "example2" {
  value = pow(local.age, 3)
}

output "example3" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].group
}

output "example4" {
  value = jsonencode(local.my_object.key2)
}