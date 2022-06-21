{% macro star(from, relation_alias=False, except=[], prefix='', suffix='') -%}

    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('*') }}
    {% endif %}

    {%- for col in dbt_utils.get_filtered_columns_in_relation(from, except) %}

    {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%} {{ col | lower }} {%- if prefix!='' or suffix!='' %} as {{ prefix ~ col ~ suffix|trim|lower }} {%- endif -%}
    {%- if not loop.last %},{{ '\n  ' }}{% endif %}

    {%- endfor -%}
{%- endmacro %}
