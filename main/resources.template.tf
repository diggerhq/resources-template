{% for resource in environment_config.resources %}
    # resource.resource_type  {{ resource.resource_type }} {{ resource }}
    {% if resource.resource_type == "database" %}
        module "app_rds_{{resource.name}}" {
          source = "../rds"
          
          {%- if resource.rds_instance_class is defined %}
          instance_class = "{{resource.rds_instance_class}}"
          {% endif %}

          {%- if resource.rds_engine is defined %}
          engine = "{{resource.rds_engine}}"
          {%+ endif %}

          {%- if resource.rds_engine_version is defined %}
          engine_version = "{{resource.rds_engine_version}}"
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

          identifier_prefix = "${var.environment}"
          publicly_accessible = false
          subnet_ids = var.vpc_subnet_ids
        }

        output "DGVAR_DATABASE_URL" {
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
