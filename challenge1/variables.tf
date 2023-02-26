variable "aws-region" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_settings" {
  type = list(any)
  default = [
    {
      resource_unique_id    = "frontend"
      alb-create            = true
      alb-type              = "internet-facing"
      load_balancer_type    = "application"
      alb_port              = 80
      protocol              = "HTTP"
      health_check-enabled  = true
      health_check-interval = 30
      subnet_tier           = "Public"
      sg_name               = "frontend-alb-sg"
    },
    {
      resource_unique_id    = "backend"
      alb-create            = true
      alb-type              = "internal"
      load_balancer_type    = "application"
      alb_port              = 80
      protocol              = "HTTP"
      health_check-enabled  = true
      health_check-interval = 30
      subnet_tier           = "Private"
      sg_name               = "backendend-alb-sg"
    }
  ]
}

variable "ecs_settings" {
  type = list(any)
  default = [
    {
      resource_unique_id = "frontend"
      ecs_cluster-create = true
      subnet_tier        = "Public"
      sg_name            = "frontend-ecs-sg"
      assign_public_ip   = true
      container_port     = 80
    },
    {
      resource_unique_id = "backend"
      ecs_cluster-create = true
      subnet_tier        = "Private"
      sg_name            = "backend-ecs-sg"
      assign_public_ip   = false
      container_port     = 80
    }
  ]
}


variable "sg_rule_settings" {
  type = list(any)
  default = [
    {
      sg_name = "backend-alb-sg"
      rules = [
        {
          rule_type      = "ingress"
          rule_name      = "rule1"
          source_sg_name = "frontend-ecs-sg"
        }
      ]
    },
    {
      sg_name = "backend-ecs-sg"
      rules = [
        {
          rule_type      = "ingress"
          rule_name      = "rule1"
          source_sg_name = "backend-alb-sg"
        }
      ]
    },
    {
      sg_name = "frontend-ecs-sg"
      rules = [
        {
          rule_type      = "ingress"
          rule_name      = "rule1"
          source_sg_name = "frontend-alb-sg"
        }
      ]
    },
    {
      sg_name = "frontend-alb-sg"
      rules = [
        {
          rule_type   = "ingress"
          rule_name   = "rule1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      sg_name = "rds-sg"
      rules = [
        {
          rule_type      = "ingress"
          rule_name      = "rule1"
          source_sg_name = "backend-ecs-sg"
        }
      ]
    }

  ]
}

variable "vpc_id" {
  type    = string
  default = "vpc-01234"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "rds_resource_unique_id" {
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