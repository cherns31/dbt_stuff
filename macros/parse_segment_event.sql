{%- macro parse_segment_event(model_name,  event_name
, parsed_columns=['context', 'properties']) -%}

SELECT 
    {{ star(ref(model_name|string), except=[properties_column, 'message_id', 'event', '__hevo_id', '__hevo__ingested_at', '__hevo__loaded_at']) }},
    {{ json_object_parsing(source_type='model', source_name=model_name,
json_columns= parsed_columns , sample_size= 100000, event_type=event_name, include_object = False) }}
FROM {{ ref(model_name|string) }}
--{% raw -%} {{ ref( {%- endraw -%} '{{model_name}}'  {%- raw -%} ) }} {%- endraw %}
WHERE lower(event) = '{{ event_name | lower }}'

{%- endmacro %}
