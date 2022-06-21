{%- macro camel_to_snake(string) -%}
{%- set intermediate = modules.re.sub('(.)([A-Z][a-z]+)', '\\1_\\2', string) -%}
{%- set final = modules.re.sub('([a-z0-9])([A-Z])', '\\1_\\2', intermediate).lower() -%}
{{ final }}
{%- endmacro -%}
