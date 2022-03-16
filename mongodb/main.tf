resource "mongodbatlas_cluster" "main" {
  project_id                   = var.atlasprojectid
  name                         = "${var.app_name}-${var.environment}"
  num_shards                   = var.atlas_num_of_shards
  replication_factor           = var.atlas_num_of_replicas
  cloud_backup                 = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = var.mongo_db_major_version

  provider_name               = "AWS"
  disk_size_gb                = var.disk_size_gb
  provider_disk_iops          = var.provider_disk_iops
  provider_volume_type        = var.provider_volume_type
  provider_instance_size_name = var.provider_instance_size_name
  provider_region_name        = var.atlas_region

}

resource "aws_ssm_parameter" "sdb_hostname" {

  name        = "${var.project_name}.${var.environment}.${var.resource_name}.app_mongodb.hostname"
  description = "terraform_db_hostname"
  type        = "SecureString"
  value       = trimprefix(mongodbatlas_cluster.main.srv_address,"mongodb+srv://")
  overwrite   = true
  depends_on = [
    mongodbatlas_cluster.main
  ]
}
