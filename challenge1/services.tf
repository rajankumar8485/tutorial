terraform {
  backend "s3" {
  }
}

provider "aws" {
  region  = var.aws-region
  profile = "default"
}

locals {

  ecs_settings = [for key in var.ecs_settings :
    {
      ecs_service-create = key.ecs_service-create
      resource_unique_id = key.resource_unique_id
      ecs_service-network_configuration = {
        subnets          = key.subnet_ids
        security_groups  = key.security_groups
        assign_public_ip = try(key.assign_public_ip, false)
      }
      load_balancer-target_groups = {
        container_name   = "${key.resource_unique_id}-lb-container"
        target_group_arn = "arn"
        container_port   = try(key.container_port, 443)
      }
      container_definitions = jsonencode(file("${path.module}/containerdefs/${key.resource_unique_id}ecs.json"))
    }
  ]

  ecs_service_settings = { for key in local.ecs_settings : format("%s.%s", key.resource_unique_id, "service") => key }
}

data "aws_caller_identity" "this" {}

module "services" {
  source = "./modules/ecs"

  for_each = local.ecs_service_settings

  ecs_cluster-create                            = lookup(each.value, "ecs_cluster-create")
  region                                        = var.aws-region
  environment                                   = var.environment
  ecs_service-create                            = lookup(each.value, "ecs_cluster-create") == true ? true : false
  resource_unique_id                            = lookup(each.value, "resource_unique_id")
  ecs_service-iam_role                          = lookup(each.value, "ecs_service-iam_role_arn", null)
  ecs_service-desired_count                     = lookup(each.value, "ecs_service-desired_count", 1)
  ecs_service-health_check_grace_period_seconds = lookup(each.value, "ecs_service-health_check_grace_period_seconds", 30)
  ecs_service-wait_for_steady_state             = lookup(each.value, "ecs_service-wait_for_steady_state", true)
  ecs_service-force_new_deployment              = lookup(each.value, "ecs_service-force_new_deployment", false)
  ecs_service-launch_type                       = lookup(each.value, "ecs_service-launch_type", "FARGATE")
  ecs_service-network_configuration             = lookup(each.value, "ecs_service-network_configuration")
  ecs_service-platform_version                  = lookup(each.value, "ecs_service-launch_type", "FARGATE") == "FARGATE" ? try(lookup(each.value, "ecs_service-platform_version", null)) != null ? lookup(each.value, "ecs_service-platform_version") : null : null
  load_balancer-target_groups                   = lookup(each.value, "load_balancer-target_groups")
  task_definition-create                        = lookup(each.value, "ecs_cluster-create") == true ? true : false
  launch_type_compatibility                     = lookup(each.value, "ecs_service-launch_type", "FARGATE")
  container_definitions                         = lookup(each.value, "container_definitions")
  cpu                                           = lookup(each.value, "cpu", 1024)
  memory                                        = lookup(each.value, "memory", 2048)
  task_role_arn                                 = try(lookup(each.value, "task_role_name", null)) != null ? "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${lookup(each.value, "task_role_name")}" : null
  execution_role_arn                            = try(lookup(each.value, "execution_role_name", null)) != null ? "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${lookup(each.value, "execution_role_name")}" : null

  tags = var.tags
}

module "lb" {
  source = "./modules/alb"

  for_each = local.ecs_alb_settings

  region                 = var.aws-region
  environment            = var.environment
  alb-create             = lookup(each.value, "alb-create")
  alb-type               = lookup(each.value, "alb-type")
  load_balancer_type     = lookup(each.value, "load_balancer_type", "application")
  alb-security_group_ids = lookup(each.value, "load_balancer_type", "application") == "application" ? lookup(each.value, "security_groups", null) : null
  alb-subnet_ids         = lookup(each.value, "alb-subnet_ids")
  alb-vpc_id             = lookup(each.value, "alb-vpc_id")
  alb_port               = lookup(each.value, "alb_port", 80)
  protocol               = lookup(each.value, "alb_protocol", "HTTP")
  health_check-enabled   = lookup(each.value, "health_check-enabled", true)
  health_check-protocol  = lookup(each.value, "alb_protocol", "HTTP")
  health_check-interval  = lookup(each.value, "health_check-interval", 30)

}