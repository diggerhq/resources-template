project_name = "{{app_name}}"
environment = "{{environment}}"
region = "{{region}}"
aws_key = "{{aws_key}}"
aws_secret = "{{aws_secret}}"
vpc_id = "{{environment_config.vpc_id}}"

public_subnet_ids = [
{%- for s in environment_config.public_subnet_ids %}
  "{{ s }}",
{% endfor %}
]

private_subnet_ids = [
{%- for s in environment_config.private_subnet_ids %}
  "{{ s }}",
{% endfor %}
]

security_groups_ids = [
{%- for s in environment_config.security_groups_ids %}
  "{{ s }}",
{% endfor %}
]