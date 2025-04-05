WITH raw_sales AS (
    SELECT
        order_id,
        customer_id,
        product_id,
        order_date,
        quantity,
        total_price
    FROM "d9snqvovhsjpqs"."public"."sales"
)
SELECT
    order_id,
    customer_id,
    product_id,
    order_date::date AS order_date,
    quantity::int AS quantity,
    total_price::decimal AS total_price
FROM raw_sales