{%- macro from_unixtimestamp(epochs, format='seconds') -%}
{%- if format in ('seconds', 'sec', 's') -%}
    {%- set scale = 0 -%}
    {%- elif format in ('milliseconds', 'milsecs', 'ms') -%}
    {%- set scale = 3 -%}
    {%- elif format in ('microseconds', 'micsecs', 'mcs') -%}
    {%- set scale = 6 -%}
    {%- elif format in ('nanoseconds', 'nanosecs', 'ns') -%}
    {%- set scale = 9 -%}
    {%- else -%}
    {{ exceptions.raise_compiler_error(
        "value " ~ format ~ " for `format` for from_unixtimestamp is not supported."
        )
    }}
    {% endif -%}
    TO_TIMESTAMP_LTZ({{ epochs }}, {{ scale }})
    {%- endmacro %}
