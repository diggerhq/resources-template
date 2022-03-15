
resource "aws_elasticache_subnet_group" "redis_private_subnet_group" {
  name       = "${var.environment}_${var.project_name}_${var.resource_name}_redis_subnet_group"
  subnet_ids = var.subnet_ids
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

resource "random_password" "rds_password" {
  length  = 32
  special = false
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.cluster_id
  replication_group_description = var.cluster_description
  node_type                     = var.redis_node_type
  port                          = var.redis_port
  #parameter_group_name =

  #snapshot_retention_limit = 5
  #snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.redis_private_subnet_group.name
  automatic_failover_enabled = true

  replicas_per_node_group = var.replicas_per_node_group
  num_node_groups         = var.num_node_groups

}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}
