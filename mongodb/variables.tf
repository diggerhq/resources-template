
variable "project_name" {}

variable "environment" {}

variable "resource_name" {}

variable "atlas_region" {
  default     = "US_EAST_1"
  description = "Atlas Region"
}

variable "atlasprojectid" {
  description = "Atlas Project ID"
}

variable "app_name" {
  description = "Application name"
}

variable "atlas_num_of_replicas" {
  description = "Number of replicas"
  default = 2
}

variable "backup_on_destroy" {
  default = false
  description = "Create dump on destroy"
}

variable "restore_on_create" {
  default = false
  description = "Restore DB from dump file"
}

variable "atlas_num_of_shards" {
  default = 1
  description = "Number of shards"
}

variable "mongo_db_major_version" {
  default = "4.2"
  description = "MongoDB version"
}

variable "disk_size_gb" {
  default = 10
  description = "MongoDB disk size in GB"
}

variable "provider_disk_iops" {
  default = 250
  description = "MongoDB disk iops"
}

variable "provider_volume_type" {
  default = "STANDARD"
  description = "MongoDB volume type"
}

variable "provider_instance_size_name" {
  default = "M10"
  description = "MongoDB instance type"
}

variable "db_name" {
  description = "Database name to use"
}