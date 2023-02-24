locals {

 resource_name_pattern = replace(join("-", ["${var.region}","${var.environment}","${var.resource_unique_id}"]), "/_*||", "")
 network_mode          = var.launch_type_compatibility == "FARGATE" ? "awsvpc" : var.network_mode

}

data "aws_region" "current" {}

resource "aws_lb" "this" {
  count = var.alb-create ? 1 : 0

  name = trim(substr("${local.resource_name_pattern}-alb", 0, 32), "-")
  internal           = var.alb-type == "internal" ? true : false
  load_balancer_type = "application"
  security_groups    = var.alb-security_group_ids
  subnets            = var.alb-subnet_ids
  idle_timeout       = var.alb-idle_timeout

  dynamic "access_logs" {
    for_each = length(keys(var.alb-access_logs)) == 0 ? [] : [var.alb-access_logs]

    content {
      bucket  = var.s3_bucket_id
      enabled = lookup(access_logs.value, "enabled", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  tags = merge({
    "Name"              = substr(local.resource_name_pattern, 0, 32),
    "wk_resource_class" = "elasticloadbalancing-application"
  }, var.tags)
}

resource "aws_lb_target_group" "this" {
  count = var.alb-create ? 1 : 0

  name     = trim(substr("${local.resource_name_pattern}-tg", 0, 32), "-")
  vpc_id   = var.alb-vpc_id
  port     = var.port
  protocol = var.protocol

  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    enabled             = var.health_check-enabled
    protocol            = var.health_check-protocol
    interval            = var.health_check-interval
  }

  tags = merge({
    "resource_name"  = substr("${local.resource_name_pattern}-${each.key}", 0, 32),
  }, var.tags)

  depends_on = [aws_lb.this]
} 

resource "aws_lb_target_group_attachment" "this" {
  count = var.alb-create ? 1 : 0

  target_group_arn = aws_lb_target_group.this[0].arn
  target_id        = aws_lb.this[0].arn
  port             = var.alb_port
  
}