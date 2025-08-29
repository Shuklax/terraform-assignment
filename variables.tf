
variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "infra-assignment"
}

variable "env" {
  type    = string
  default = "dev"
}


variable "use_arm" {
  type    = bool
  default = false
}