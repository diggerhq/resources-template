project_name = "{{project}}"
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
]qq

security_group_ids = [
{%- for s in environment_config.security_group_ids %}
  "{{ s }}",
{% endfor %}
]