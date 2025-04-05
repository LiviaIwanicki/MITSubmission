SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(total_price) AS total_revenue
FROM "d9snqvovhsjpqs"."public"."stg_sales"
GROUP BY customer_id
ORDER BY total_revenue DESC