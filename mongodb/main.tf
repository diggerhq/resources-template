resource "random_password" "rds_password" {
  length           = 32
  special          = false
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = var.docdb_username
  master_password         = random_password.rds_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}

resource "aws_ssm_parameter" "docdb_password" {
  name = "${var.project_name}.${var.environment}.${var.resource_name}.app_docdb.database_password"
  value = random_password.rds_password.result
  type = "SecureString"
}
