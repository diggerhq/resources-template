
resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name_prefix  = "rds_private_subnet_group"
  subnet_ids   = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id ]

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds-sg"
  vpc_id = local.vpc.id
  description = "Digger database ${var.project_name}-${var.environment}"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id, aws_security_group.bastion_sg.id]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "random_password" "rds_password" {
  length           = 32
  special          = false
}

resource "aws_db_instance" "digger_rds" {
  identifier_prefix    = var.identifier_prefix
  allocated_storage    = var.allocated_storage
  iops                 = var.iops
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.database_name
  username             = var.database_username
  password             = random_password.rds_password.result
  snapshot_identifier  = var.snapshot_identifier
  skip_final_snapshot  = true
  publicly_accessible  = var.publicly_accessible
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name  = aws_db_subnet_group.rds_private_subnet_group.name
}

locals {
  database_address = module.app_rds.database_address
  database_name = module.app_rds.database_name
  database_username = module.app_rds.database_username
  database_password = module.app_rds.database_password
  database_port = module.app_rds.database_port
  database_url = "postgres://${local.database_username}:${local.database_password}@${local.database_address}:${local.database_port}/${local.database_name}"
  database_endpoint = "postgres://${local.database_username}:${local.database_password}@${local.database_address}:${local.database_port}/"
}

resource "aws_ssm_parameter" "database_password" {
  name = "${var.project_name}.${var.environment}.app_rds.database_password"
  value = local.database_password
  type = "SecureString"
}

resource "aws_ssm_parameter" "database_url" {
  name = "${var.project_name}.${var.environment}.app_rds.database_url"
  value = local.database_url
  type = "SecureString"
}

resource "aws_ssm_parameter" "database_endpoint" {
  name = "${var.project_name}.${var.environment}.app_rds.database_endpoint"
  value = local.database_endpoint
  type = "SecureString"
}

output "database_address" {
  value = aws_db_instance.default.address
}

output "database_name" {
  value = var.database_name
}

output "database_username" {
  value = var.database_username
}

output "database_password" {
  value = aws_db_instance.default.password
}

output "database_port" {
  value = 5432
}

output "database_url" {
  value = aws_ssm_parameter.database_url.arn
}

