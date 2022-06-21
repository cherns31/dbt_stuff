{% macro build_key_from_columns(model_name, include=[], exclude=[]) %}


{%- if include -%}

{% set include = include | map('lower') | list  %}
{%- set cols = [] -%}

{% for col in include %}
    {%- do cols.append(col) -%}
{%- endfor -%}

{%- else -%}

{% set columns = ( get_columns_in_relation(ref(model_name)) )  -%}

{% set exclude = exclude | map('lower') | list  %}

{% set star_cols = columns|map(attribute='name')| map('lower') |reject("in", exclude) | list %}


{%- set cols = star_cols -%}

{% endif %}


{{ return(dbt_utils.surrogate_key(cols)) }}

{% endmacro %}
