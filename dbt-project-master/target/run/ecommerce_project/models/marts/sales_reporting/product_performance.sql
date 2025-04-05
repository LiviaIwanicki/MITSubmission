
  
    

  create  table "d9snqvovhsjpqs"."public"."product_performance__dbt_tmp"
  
  
    as
  
  (
    SELECT
    product_id,
    COUNT(order_id) AS total_sales,
    SUM(total_price) AS revenue
FROM "d9snqvovhsjpqs"."public"."stg_sales"
GROUP BY product_id
ORDER BY revenue DESC
  );
  