WITH raw_products AS (
    SELECT
        product_id,
        product_name,
        category,
        price
    FROM {{ source('ecommerce', 'products') }}
)
SELECT
    product_id,
    product_name,
    category,
    price::decimal AS price
FROM raw_products