--Task B 
--First, I find top five registrants by dollar amount using similar query from task a :
--Join registrants with filings (to link registrants to their financial records)
--Then, I group by registrant_id, then sum up their total lobbying spend
--Then order by total_spend descending and take the top 5

with registrant_totals AS (
    SELECT 
        r.registrant_id,
        r.registrant_name,
        SUM(f.amount::numeric) AS total_spend
    FROM 
        analyst.registrants r
    JOIN 
        analyst.filings f ON r.registrant_id = f.registrant_id
    WHERE f.amount is NOT NULL
    GROUP BY 
        r.registrant_id, r.registrant_name
    ORDER BY 
        total_spend desc
    LIMIT 5 
), --Then, for the next portion, for each top 5 registrant found, I rank their clients by $ spent
-- Join with filings and clients to get each registrant's clients
-- For each registrant (using partition by), I sum and rank spending by client
client_rankings AS (
    SELECT 
        rt.registrant_id,
        rt.registrant_name,
        c.client_name,
        SUM(f.amount::numeric) AS client_spend,
        ROW_NUMBER() OVER (
            PARTITION BY rt.registrant_id 
            ORDER BY SUM(f.amount::numeric) DESC
        ) AS client_rank
    FROM 
        registrant_totals rt
    JOIN 
        analyst.filings f ON rt.registrant_id = f.registrant_id
    JOIN 
        analyst.clients c ON f.client_id = c.client_id
    WHERE 
        f.amount IS NOT NULL
    GROUP BY 
        rt.registrant_id, rt.registrant_name, c.client_name
)
-- Final output showing registrants and their top 5 clients
SELECT 
    registrant_name,
    registrant_id,
    client_name,
    client_spend,
    client_rank
FROM 
    client_rankings
WHERE 
    client_rank <= 5
ORDER BY 
    registrant_name,
    client_rank;

--I assumed that the output would be 25 clients (5 registrants, 5 clients each), but with only 9 clients as the output, I could assume some registrants have fewer than 5 clients as was stated in the prompt.
--To check this, I checked (select * from analyst.filings where registrant_id = (id of registrants with only 1 client)) to make sure there was only 1 client used for CHAMBER OF COMMERCE OF THE U.S.A.,
--NATIONAL ASSOCIATION OF REALTORS, NCTA - THE INTERNET & TELEVISION ASSOCIATION, U.S. CHAMBER INSTITUTE FOR LEGAL REFORM

