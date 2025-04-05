--Task A 
--To find the top 10 registrants whose total lobbying spend exceeds $10,000,00, we will use analyst.registrants and analyst.filings, joining the two on registrant_id.
SELECT 
    r.registrant_id,
    r.registrant_name,
    SUM(f.amount::numeric) AS total_lobby_spend
FROM 
    analyst.registrants r
JOIN 
    analyst.filings f ON r.registrant_id = f.registrant_id
GROUP BY 
    r.registrant_id, r.registrant_name
HAVING 
    SUM(f.amount::numeric) > 10000000
ORDER BY 
    total_lobby_spend desc
    --; if you do not limit to ten and end query here, the query returns 59 registrants whose total lobbying spend exceeds $10,000,000
LIMIT 10;


