
variable "project_name" {}

variable "environment" {}

variable "resource_name" {}

variable "allocated_storage" {
  type        = number
  default     = 100
  description = "The default storage for the RDS instance"
} 


variable "cluster_id" {
}

variable "cluster_description" {}

variable "redis_node_type" {
  default = "cache.t3.micro"
}

variable "redis_port" {
  default = 6379
}

variable "replicas_per_node_group" {
  default = 1
}

variable "num_node_groups" {
  default = 2
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "security_groups_ids" {}

