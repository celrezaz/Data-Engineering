{% macro mayusculas_nombres(col) %}
    INITCAP(TRIM(TO_VARCHAR({{ col }})))
{% endmacro %}

{% macro numero_mes(col) %}
    CASE 
        WHEN {{ col }} IN ('January',   'Jan', '1')  THEN 1 
        WHEN {{ col }} IN ('February',  'Feb', '2')  THEN 2
        WHEN {{ col }} IN ('March',     'Mar', '3')  THEN 3
        WHEN {{ col }} IN ('April',     'Apr', '4')  THEN 4
        WHEN {{ col }} IN ('May',              '5')  THEN 5 
        WHEN {{ col }} IN ('June',      'Jun', '6')  THEN 6
        WHEN {{ col }} IN ('July',      'Jul', '7')  THEN 7 
        WHEN {{ col }} IN ('August',    'Aug', '8')  THEN 8
        WHEN {{ col }} IN ('September', 'Sep', 'Sept', '9')  THEN 9 
        WHEN {{ col }} IN ('October',   'Oct', '10') THEN 10
        WHEN {{ col }} IN ('November',  'Nov', '11') THEN 11 
        WHEN {{ col }} IN ('December',  'Dec', '12') THEN 12
        ELSE -1
    END
{% endmacro %}

{% macro mes_code(year_col, month_col) %}
    TO_VARCHAR({{ year_col }}) || LPAD(TO_VARCHAR({{ month_col }}), 2, '0')
{% endmacro %}

{% macro limpiar_nombres(col) %}
    lower(trim(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(
                REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(
                REGEXP_REPLACE(REGEXP_REPLACE(
                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                        lower(trim(TO_VARCHAR({{ col }}))),
                    '1', 'l'), '0', 'o'), '3', 'e'), '$', 's'), '@', 'a'), '|', 'l'),
                '[áàäâã]', 'a'),
                '[éèëê]',  'e'),
                '[íìïî]',  'i'),
                '[óòöôõ]', 'o'),
                '[úùüû]',  'u'),
                '[ñ]',     'n'),
                '[ç]',     'c'),
                '[^a-z ]', ''),
            '\s+', ' ')
    ))
{% endmacro %}