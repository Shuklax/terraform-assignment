variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "use_arm" {
  type = bool
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}
