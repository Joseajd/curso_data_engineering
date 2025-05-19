{% macro replace_nulls(columns, new_value=0) %}
    {%- for col in columns %}
        coalesce({{ col }}, {{ new_value }}) as {{ col }}{% if not loop.last %}, {% endif %}
    {%- endfor %}
{% endmacro %}
