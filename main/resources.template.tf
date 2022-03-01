
{% for resource in resources %}

    {% if resource.resource_type == "database" %}
        module "app_rds_{{resource.name}}" {
          source = "../rds"
          
          {% if resource.rds_instance_class %}
          instance_class = "{{resource.rds_instance_class}}"
          {% endif %}

          {% if resource.rds_engine %}
          engine = "{{resource.rds_engine}}"
          {% endif %}
          
          {% if resource.rds_engine_version %}
          engine_version = "{{resource.rds_engine_version}}"
          {% endif %}
          
          {% if resource.rds_allocated_storage %}
          allocated_storage = "{{resource.rds_allocated_storage}}"
          {% endif %}

          {% if resource.database_snapshot_identifier %}
          snapshot_identifier = "{{resource.rds_snapshot_identifier}}"
          {% endif %}

          {% if resource.database_iops %}
          iops = "{{resource.rds_iops}}"
          {% endif %}

          identifier_prefix = "${var.app}-${var.environment}"
          publicly_accessible = false
        }

        output "DGVAR_DATABASE_URL" {
          value = module.app_rds_{{resource.name}}.database_url
        }

    {% elif resource.resource_type == "redis" %}
    {% elif reosource.resource_type == "mongodb" %}  
    {% endif %}

{% endfor %}
