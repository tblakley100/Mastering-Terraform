output "rds_endpoint" {
  value = module.database.rds_instance_endpoint
}

output "rds_address" {
  value = module.database.rds_instance_address
}

output "rds_port" {
  value = module.database.rds_instance_port
}
output "rds_id" {
  value = module.database.rds_instance_id
}

output "rds_arn" {
  value = module.database.rds_instance_arn
}
