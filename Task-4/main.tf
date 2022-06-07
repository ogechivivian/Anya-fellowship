###
# Providers
##
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }

#   backend "s3" {
#     bucket  = ""
#     key     = ""
#     region  = "us-east-2"
#   }
}

provider "aws" {
  region  = "us-east-2"
}


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

locals {
  cidr_subnets = cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4)
}

###
# Data
##
data "aws_ami" "app" {
#   executable_users = ["self"]
  most_recent      = true
#   name_regex       = "^myami-\\d{3}"
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

#    filter {
#     name   = "tag:Environment"
#     values = [var.infra_env]
#   }
}

# data "aws_ami" "app" {
#   most_recent = true

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name   = "tag:Component"
#     values = ["app"]
#   }

#   filter {
#     name   = "tag:Project"
#     values = ["cloudcasts"]
#   }

#   filter {
#     name   = "tag:Environment"
#     values = [var.infra_env]
#   }

#   owners = ["self"]
# }


###
# Resources
##
module "vpc" {
  source = "../Task-4/vpc"

  infra_env       = var.infra_env
  vpc_cidr        = "10.0.0.0/17"
  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = slice(local.cidr_subnets, 0, 3)
  private_subnets = slice(local.cidr_subnets, 3, 6)
}

module "autoscale_web" {
  source = "../Task-4/ec2"

  ami             = data.aws_ami.app.id
  infra_env       = var.infra_env
  infra_role      = "http"
  instance_type   = "t3a.small"
  security_groups = [module.vpc.internal_sg, module.vpc.web_sg]
  ssh_key_name    = "Anya-key"

  asg_subnets = module.vpc.vpc_private_subnets
  alb_subnets = module.vpc.vpc_public_subnets
  vpc_id      = module.vpc.vpc_id

  min_size    = 0
  max_size    = 5
  desired_capacity = 2

}

module "autoscale_queue" {
  source = "../Task-4/ec2"

  ami             = data.aws_ami.app.id
  infra_env       = var.infra_env
  infra_role      = "queue"
  instance_type   = "t3a.small"
  security_groups = [module.vpc.internal_sg]
  ssh_key_name    = "Anya-key"

  asg_subnets = module.vpc.vpc_private_subnets
  vpc_id      = module.vpc.vpc_id

  min_size    = 0
  max_size    = 5
  desired_capacity = 2
}