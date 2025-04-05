SELECT
    order_date,
    COUNT(order_id) AS total_orders,
    SUM(total_price) AS total_revenue
FROM "d9snqvovhsjpqs"."public"."stg_sales"
GROUP BY order_date
ORDER BY order_date