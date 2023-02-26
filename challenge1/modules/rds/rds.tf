locals {

  resource_name_pattern = replace(join("-", ["${var.region}", "${var.environment}", "${var.resource_unique_id}"]), "/_*||", "")
  identifier            = "${local.resource_name_pattern}-db"
  subnet_group          = "${local.resource_name_pattern}-subnet-group"

}

resource "aws_db_instance" "this" {
  count = var.rds-create ? 1 : 0

  identifier = local.identifier

  instance_class    = var.rds-instance_class
  allocated_storage = var.rds-allocated_storage
  storage_type      = var.rds-storage_type
  iops              = var.rds-iops
  storage_encrypted = var.rds-storage_encrypted
  kms_key_id        = length(var.rds-kms_key_id) > 0 ? var.rds-kms_key_id : null

  username       = var.rds-master_username
  password       = var.rds-master_password
  name           = var.rds-master_database_name
  engine         = var.rds-engine
  engine_version = var.rds-engine_version
  port           = var.rds-port

  db_subnet_group_name   = var.rds-db_subnet_name
  multi_az               = var.rds-multi_az
  availability_zone      = var.rds-availability_zone
  vpc_security_group_ids = var.rds-security_group_ids

  publicly_accessible       = var.rds-publicly_accessible
  final_snapshot_identifier = "${var.resource_name_pattern}-final-${replace(timestamp(), ":", "-")}"
  delete_automated_backups  = var.rds-delete_automated_backups
  deletion_protection       = var.rds-deletion_protection

  tags = merge({
    "resource_name"  = local.identifier,
    "resource_class" = "db",
  }, var.tags)

}