{% macro create_udfs() %}

{% set query %}

{{ create_example_udf() }};

{# add more udfs macros here *}

{% endset %}

{% do run_query(query) %}

{% endmacro %}
