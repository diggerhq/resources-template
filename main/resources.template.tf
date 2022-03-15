{% for resource in environment_config.resources %}
    {% if (resource.resource_type | lower) == "database" %}
        module "app_rds_{{resource.name}}" {
          source = "../rds"

          resource_name = "{{ resource.name }}"
          {%- if resource.rds_instance_class is defined %}
          instance_class = "{{resource.rds_instance_class}}"
          {% endif %}

          {%- if resource.rds_engine is defined %}
          engine = "{{resource.rds_engine}}"
          {%+ endif %}

          {%- if resource.rds_engine_version is defined %}
          engine_version = "{{resource.rds_engine_version}}"
          {% endif %}

          {%- if resource.storage_type is defined %}
          storage_type = "{{resource.storage_type}}"
          {% endif %}

          {%- if resource.rds_allocated_storage is defined %}
          allocated_storage = "{{resource.rds_allocated_storage}}"
          {% endif %}

          {%- if resource.database_snapshot_identifier is defined %}
          snapshot_identifier = "{{resource.rds_snapshot_identifier}}"
          {% endif %}

          {%- if resource.database_iops is defined %}
          iops = "{{resource.rds_iops}}"
          {% endif %}

          identifier_prefix = "${var.environment}-${var.project_name}-${var.resource_name}"
          publicly_accessible = false

          vpc_id = var.vpc_id
          subnet_ids = var.private_subnet_ids
          security_groups_ids = var.security_groups_ids

          project_name = var.project_name
          environment = var.environment
        }

        output "DGVAR_DATABASE_{{ app_name | upper }}_URL" {
          value = module.app_rds_{{resource.name}}.database_url
        }

    {% elif resource.resource_type == "redis" %}
        module "app_redis_{{resource.name}}" {
        source = "../redis"
        }
    {% elif resource.resource_type == "mongodb" %}
        module "app_mongodb_{{resource.name}}" {
        source = "../mongodb"
        }
    {% endif %}

{% endfor %}
