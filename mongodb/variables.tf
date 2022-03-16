
variable "project_name" {}

variable "environment" {}

variable "resource_name" {}

variable "cluster_identifier" {
}

variable "docdb_username" {
  default = "digger"
}

variable "subnet_ids" {}

variable "security_groups_ids" {}