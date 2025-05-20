{% macro replace_nulls(columns, new_value=0) %}
    {%- for col in columns %}
        coalesce({{ col }}, {{ new_value }}) as {{ col }}{% if not loop.last %}, {% endif %}
    {%- endfor %}
{% endmacro %}

{% macro replace_nulls2(columns, new_value='0-0') %}
    {%- for col in columns %}
        case 
            when {{ col }} is null or {{ col }} = '' then '{{ new_value }}'
            else {{ col }}
        end as {{ col }}{% if not loop.last %}, {% endif %}
    {%- endfor %}
{% endmacro %}
