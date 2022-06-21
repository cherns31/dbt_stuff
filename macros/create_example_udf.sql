{% macro create_is_test_user(schema_name='public') %}

CREATE OR REPLACE FUNCTION {{ target.database }}.{{ schema_name }}.is_test_user(email VARCHAR)
    RETURNS BOOLEAN
AS
$$
    SELECT 
          CONTAINS(email, 'estrin') OR
          CONTAINS(email, 'hernan')
$$
{{ log('Succesfully created is_test_user UDF at ' ~ target.database ~ '.' ~  schema_name, info= True)  }}
{% endmacro %}
