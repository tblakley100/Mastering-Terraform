locals {
  math       = 10 - 2
  equality   = 2 != 3
  comparison = 2 <= 3
  logical    = true && true && true && false
}

output "operators" {
  value = {
    math       = local.math
    equality   = local.equality
    comparison = local.comparison
    logical    = local.logical
  }
}