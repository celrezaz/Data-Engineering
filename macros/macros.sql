{% macro crear_id(cols) %}
    MD5(
        CONCAT_WS(
            '||',
            {% for col in cols %}
                COALESCE(
                    LOWER(TRIM(CAST({{ col }} AS VARCHAR))),
                    '_NULL_'
                ){% if not loop.last %}, {% endif %}
            {% endfor %}
        )
    )
{% endmacro %}


{% macro mayusculas_nombres(col) %}
    INITCAP(TRIM(TO_VARCHAR({{ col }})))
{% endmacro %}

{% macro numero_mes(col) %}
    CASE 
        WHEN {{ col }} = 'January' THEN 1 
        WHEN {{ col }} = 'February' THEN 2
        WHEN {{ col }} = 'March' THEN 3
        WHEN {{ col }} = 'April' THEN 4
        WHEN {{ col }} = 'May' THEN 5 
        WHEN {{ col }} = 'June' THEN 6
        WHEN {{ col }} = 'July' THEN 7 
        WHEN {{ col }} = 'August' THEN 8
        WHEN {{ col }} = 'September' THEN 9 
        WHEN {{ col }} = 'October' THEN 10
        WHEN {{ col }} = 'November' THEN 11 
        WHEN {{ col }} = 'December' THEN 12
    END
{% endmacro %}