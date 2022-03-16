
variable "project_name" {}

variable "environment" {}

variable "resource_name" {}

variable "cluster_identifier" {
}

variable "docdb_username" {
  default = "digger"
}

variable "docdb_port" {
  default = 27017
}

variable "subnet_ids" {}

variable "vpc_id" {}

variable "security_groups_ids" {}