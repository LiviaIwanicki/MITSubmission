{% macro check_nulls(table_name, column_name) %}
    SELECT
        COUNT(1) AS null_count
    FROM {{ table_name }}
    WHERE {{ column_name }} IS NULL
{% endmacro %}
