{# Macro to change the way schemas are generated hinging on the target being used #}

{% macro generate_schema_name(custom_schema_name, node) -%}
    {# target.schema and target.name are set at the job level. Custom schema name is configured at the model or dbt_proyect.yml file. #}
    {%- set default_schema = target.schema -%}
    {%- if target.name|lower in ['prod', 'production', 'deploy', 'deployment'] and custom_schema_name is not none -%}

        {{ custom_schema_name | trim }}

    {%- elif custom_schema_name is not none -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
