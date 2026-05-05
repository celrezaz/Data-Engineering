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