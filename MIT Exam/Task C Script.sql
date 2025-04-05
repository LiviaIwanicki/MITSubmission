--Task C
--First, identified the registrant who has lobbied the most separate bills in the Medicare/Medicaid issue category.
--Need analyst.registrants, analyst.filings, analyst.filings_issues, and analyst.filings_bills. This connects registrants to filings to issues, to bills. 
--Then, filtering to general issue code 'MMM' for only Medicare/Medicaid issues.
--We then cnt(distinct()) to find number of bill IDs per registrant
--Order by bill_count, LIMIT 1 returns the top registrant

WITH top_reg AS (
    SELECT 
        r.registrant_id,
        r.registrant_name,
        COUNT(DISTINCT fb.bill_id) AS bill_count
    FROM 
        analyst.registrants r
    JOIN 
        analyst.filings f ON r.registrant_id = f.registrant_id
    JOIN 
        analyst.filings_issues fi ON f.filing_uuid = fi.filing_uuid
    JOIN 
        analyst.filings_bills fb ON f.filing_uuid = fb.filing_uuid
    WHERE 
        fi.general_issue_code = 'MMM'
    GROUP BY 
        r.registrant_id, r.registrant_name
    ORDER BY 
        bill_count DESC
    LIMIT 1
)--For this second part, we are looking at the bills
--Using the same joins as the first query, and filtering only for MMM and distinct(so each bill ID only appears once) 
--LIMIT 10 shows us just a sample as was requested 
SELECT DISTINCT
    fb.bill_id
FROM 
    top_reg tr
JOIN 
    analyst.filings f ON tr.registrant_id = f.registrant_id
JOIN 
    analyst.filings_issues fi ON f.filing_uuid = fi.filing_uuid
JOIN 
    analyst.filings_bills fb ON f.filing_uuid = fb.filing_uuid
WHERE 
    fi.general_issue_code = 'MMM'
LIMIT 10;