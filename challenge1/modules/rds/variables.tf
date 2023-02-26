variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "resource_unique_id" {
  type = string
}

variable "rds-create" {
  type = bool
}

variable "rds-instance_class" {
  type = string
}

variable "rds-allocated_storage" {
  type = number
}

variable "rds-storage_type" {
  type = string
}

variable "rds-iops" {
  type = string
}

variable "rds-storage_encrypted" {
  type = bool
}

variable "rds-kms_key_id" {
  type = string
}

variable "rds-master_username" {
  type = string
}

variable "rds-master_password" {
  type = string
}

variable "rds-master_database_name" {
  type = string
}

variable "rds-engine" {
  type = string
}

variable "rds-engine_version" {
  type = string
}

variable "rds-port" {
  type = number
}

variable "rds-db_subnet_name" {
  type = string
}

variable "rds-multi_az" {
  type = bool
}

variable "rds-security_group_ids" {
  type = list(string)
}

variable "rds-publicly_accessible" {
  type    = bool
  default = false
}

variable "rds-delete_automated_backups" {
  type    = bool
  default = true
}

variable "rds-deletion_protection" {
  type    = bool
  default = true
}

variable "tags" {
  type = map(string)
}