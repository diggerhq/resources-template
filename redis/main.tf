
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

resource "aws_elasticache_cluster" "dg_redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_number_nodes
  parameter_group_name = "default.redis6.x"
  engine_version       = var.engine_version
  port                 = var.redis_port
  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_private_subnet_group.name
  tags                 = var.tags
}


output "redis_url" {
  value = "${aws_elasticache_cluster.dg_redis.cache_nodes[0].address}:${var.redis_port}"
}