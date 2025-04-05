WITH raw_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        address,
        city,
        state,
        postal_code
    FROM "d9snqvovhsjpqs"."public"."customers"
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    state
FROM raw_customers