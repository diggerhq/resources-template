
resource "aws_elasticache_subnet_group" "redis_private_subnet_group" {
  name       = "${var.environment}-${var.project_name}-${var.resource_name}-redis-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "${var.project_name}-${var.environment}-${var.resource_name}-redis-sg"
  vpc_id      = var.vpc_id
  description = "Digger Redis ${var.project_name}-${var.environment}-${var.resource_name}"

  # Only redis in
  ingress {
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = var.cluster_id
  description          = var.cluster_description
  port                 = var.redis_port
  engine               = "redis"
  node_type            = var.redis_node_type
  security_group_ids   = [aws_security_group.redis_sg.id]

  #snapshot_retention_limit = 5
  #snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.redis_private_subnet_group.name
  automatic_failover_enabled = true

  replicas_per_node_group = var.replicas_per_node_group
  num_node_groups         = var.num_node_groups

  tags = var.tags
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.redis.configuration_endpoint_address
}
