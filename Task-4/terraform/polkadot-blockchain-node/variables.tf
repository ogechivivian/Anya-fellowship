variable "region" {
  default = "us-west-2"
}

variable "availability_zone" {
  default = "us-west-2a"
}

variable "machine_type" {
  default = "m4.large"
}


variable "ssh_user" {
  default = ""
}

variable "node_count" {
  default = 1
}

variable "name" {
  default = "polkadot-full-node"
}

variable "image" {
  default = "ami-08d70e59c07c61a3a"
}