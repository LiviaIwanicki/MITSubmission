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
    FROM {{ source('ecommerce', 'customers') }}
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    state
FROM raw_customers