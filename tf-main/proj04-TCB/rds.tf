module "database" {
  source = "./modules/rds"

  project_name       = "proj04-tcb"
  security_group_ids = [aws_security_group.compliant.id]
  subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]

  credentials = {
    username = "dbadmin"
    password = "1a2bC3!45$&TCB4" # Ensure this meets the password policy
  }
}