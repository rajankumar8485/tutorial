module "database" {
  source = "./modules/rds"

  region                       = var.aws-region
  environment                  = var.environment
  rds-create                   = var.rds-create
  resource_unique_id           = var.rds_resource_unique_id
  rds-instance_class           = var.rds-instance_class
  rds-master_username          = var.rds-master_username
  rds-master_password          = var.rds-master_password
  rds-master_database_name     = var.rds-master_database_name
  rds-engine                   = var.rds-engine
  rds-engine_version           = var.rds-engine_version
  rds-port                     = var.rds-port
  rds-db_subnet_name           = element(data.aws_subnets.this[Private].ids, 0)
  rds-multi_az                 = var.rds-multi_az
  rds-security_group_ids       = [aws_security_group.this[rds-db].id]
  rds-publicly_accessible      = var.rds-publicly_accessible
  rds-delete_automated_backups = var.rds-delete_automated_backups
  rds-deletion_protection      = var.rds-deletion_protection

  depends_on = [
    aws_security_group.this,
    aws_security_group_rule.this,
    data.aws_subnets.this
  ]

  tags = var.tags

}