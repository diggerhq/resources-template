resource "aws_docdb_subnet_group" "default" {
  name        = "${var.project_name}_${var.environment}_${var.resource_name}_docdb_subnet"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnet_ids
}

resource "random_password" "rds_password" {
  length  = 32
  special = false
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-${var.resource_name}-docdb-sg"
  vpc_id      = var.vpc_id
  description = "Digger docdb ${var.project_name}-${var.environment}-${var.resource_name}"

  # Only postgres in
  ingress {
    from_port       = var.docdb_port
    to_port         = var.docdb_port
    protocol        = "tcp"
    security_groups = var.security_groups_ids
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = var.docdb_username
  master_password         = random_password.rds_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
}

resource "aws_ssm_parameter" "docdb_password" {
  name  = "${var.project_name}.${var.environment}.${var.resource_name}.app_docdb.database_password"
  value = random_password.rds_password.result
  type  = "SecureString"
}
