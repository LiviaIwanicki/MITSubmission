{% snapshot sales_snapshot %}
    {{
        config(
            target_schema='snapshots',
            unique_key='order_id',
            strategy='timestamp',
            updated_at='order_date'
        )
    }}

    SELECT * FROM {{ ref('stg_sales') }}

{% endsnapshot %}
