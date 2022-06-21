{% macro remove_partial_duplicates (model_name, primary_key,
order_column, include=[], exclude=[], all_cols_in_result= False ) %}

{%- if (include and exclude) -%}
    {%- set error_message -%}
    'Include and exclude are mutually exclusive arguments'
    {%- endset -%}
    {{ exceptions.raise_compiler_error(error_message) }}
{%- endif -%}
{%- if (not primary_key) -%}
    {%- set error_message -%}
    'Primary key must be set'
    {%- endset -%}
    {{ exceptions.raise_compiler_error(error_message) }}
{%- endif -%}
{%- if (not order_column) -%}
    {%- set error_message -%}
    'Order column must be set'
    {%- endset -%}
    {{ exceptions.raise_compiler_error(error_message) }}
{%- endif -%}


WITH flag_uniqueness AS(

    SELECT 
        {%- if all_cols_in_result %}
                *,
        {%- else %}
            {%- if include -%}
                {% set include = include | map('lower') | list  %}
                {%- set cols = [] -%}
                {%- do cols.append(primary_key) -%}
                {%- do cols.append(order_column) -%}
                {% for col in include %}
                {%- do cols.append(col) -%}
                {%- endfor %}
                {{ cols | join(',\n ') }},
            {%- else %}
                {{ star(ref(model_name), except = exclude) }},
            {% endif %}
        {% endif %}        
        {{ build_key_from_columns(model_name= model_name, include = include,
        exclude=exclude) }}  AS grain_id
    FROM {{ ref( model_name) }} 


)

, mark_real_diffs AS(

    SELECT
        *,
        COALESCE(
                LAG(grain_id) OVER (PARTITION BY {{ primary_key }} ORDER BY {{ order_column }}),
            'first_record'
        ) as previous_grain_id,
        CASE
            WHEN grain_id != previous_grain_id then true 
            ELSE false
        END AS is_real_diff
    FROM flag_uniqueness
)

, deduped AS(
    SELECT 
            *,
            {{ order_column }} AS valid_from,
            LEAD({{ order_column }}) OVER (PARTITION BY {{ primary_key }} ORDER BY {{ order_column }}) AS valid_to
    FROM mark_real_diffs
    WHERE is_real_diff
)

SELECT *
FROM deduped

{% endmacro %}
