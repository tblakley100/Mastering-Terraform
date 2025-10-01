module "database" {
  source = "./modules/rds"

  credentials = {
    username = "db-admin"
    password = "1a2bC3!45$&TCB4" # Ensure this meets the password policy
  }
  project_name       = "proj04-TCB"
  subnet_ids         = [aws_subnet.private1.id]
  security_group_ids = []
}