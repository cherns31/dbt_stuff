{% macro quote (str, quote="'") %}
  {% set quoted = quote ~ str ~ quote %}
  {% do return(quoted) %}
{% endmacro %}
