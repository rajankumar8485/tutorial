variable "aws-region" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_settings" {
  type = list(any)
}

variable "ecs_settings" {
  type = list(any)
}

variable "sg_settings" {
  type = list(any)
}

variable "sg_rule_settings" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

