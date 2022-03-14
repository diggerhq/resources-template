project_name = "{{app_name}}"
environment = "{{environment}}"
region = "{{region}}"
aws_key = "{{aws_key}}"
aws_secret = "{{aws_secret}}"
vpc_id = "{{environment_config.vpc_id}}"
vpc_subnet_ids = [
{%- for s in environment_config.subnet_ids %}
  "{{ s }}",
{% endfor %}
]