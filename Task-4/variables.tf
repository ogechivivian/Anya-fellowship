###
# Variables
##
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "test"
}

variable "vpc-name"{
  type        = string
  description = ""
  default     = "test"
}

variable "default_region" {
  type        = string
  description = "the region this infrastructure is in"
  default     = "us-east-1"
}

variable "key" {
    type = string
    default = "Backup"
}

variable "value" {
    default = true
}

variable "project" {
    type = string
    default = "Anya-task-04"
}
