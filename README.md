# MITSubmission
# Congressional Lobbying Analysis  
**Technical Assessment Submission**  
*April 2025*

---

## Repository Contents
├── MIT_Exam/ # Task 2
│ ├── Task A Script.sql
│ ├── Task B Script.sql
│ ├── Task C Script.sql
│ └── Task D Script.sql
├── TASK2.ipynb/ # Task 2: Data Analysis & Visualization
├── dbt-project-master/ # Task 3: Code Sample (dbt project)
└── README.md # This file


## Task 1: SQL Queries

### A) Super-Registrants (>$10M Spending)

```sql
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
LIMIT 10;

Complete Results: See Screenshot Folder


### B) Top Clients per Registrant

WITH registrant_totals AS (
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
),
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
Complete Results: See Screenshot Folder

### C) Medicare/Medicaid (MMM) Bills

WITH top_registrant AS (
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
)
SELECT DISTINCT
   fb.bill_id
FROM
   top_registrant tr
JOIN
   analyst.filings f ON tr.registrant_id = f.registrant_id
JOIN
   analyst.filings_issues fi ON f.filing_uuid = fi.filing_uuid
JOIN
   analyst.filings_bills fb ON f.filing_uuid = fb.filing_uuid
WHERE
   fi.general_issue_code = 'MMM'

Complete Results: hconres85-111
hjres101-111
hjres105-111
hjres38-111
hjres45-111
hjres64-111
hjres76-111
hjres77-111
hr1020-111
hr1076-111


D) Bill Title Categorization

WITH standard_titles AS (
    SELECT distinct(title) FROM analyst.bills
    WHERE LOWER(title) LIKE '%act'
        OR LOWER(title) LIKE '%law'
        OR LOWER(title) LIKE '%resolution'
    ),
non_standard_titles AS (
    SELECT DISTINCT(title) FROM analyst.bills
    WHERE title NOT IN (SELECT title FROM standard_titles))
SELECT
(SELECT count(*) FROM standard_titles) AS standard_title_count,
(SELECT count(*) FROM non_standard_titles) AS non_standard_title_count;

Complete Results:
standard_title_count | non_standard_title_count
--------------------|-------------------------
8539                | 27004



## Task 2: Data Analysis & Visualization
See Screenshots folder for visuals.

Key Metrics (2019)
Top Committees by Lobbying Dollars:

- House Energy & Commerce: $839.4M
- House Ways & Means: $573.3M
- Senate Finance: $361.8M

Top Committees by Filings:
- House Ways & Means: 766 filings
- House Energy & Commerce: 696 filings
- Senate Finance: 527 filings

Conclusions: Measuring Committee Importance Through Lobbying Activity
Financial Attention Highlights

Consistent with my methodology of measuring total lobbying dollars as a key importance metric, the analysis reveals:

House Dominance in Financial Attention
Energy & Commerce Committee attracted $839.4M - the highest across both chambers

Ways & Means Committee received $573.3M, demonstrating tax policy's lobbying premium

Judiciary Committee's $380.2M reflects high-value battles over judicial matters

Senate's Targeted Influence
Finance Committee led Senate at $361.8M

Health Committee's $297.3M shows healthcare's consistent priority

63% of Senate lobbying concentrated in top 3 committees vs. 52% in House

Filing Engagement Volume Insights My secondary metric - counting unique lobbying filings - showed distinct patterns:

Energy & Commerce commands 62% higher $ per filing than Ways & Means

Senate committees show more efficient lobbying (higher $ per filing)

Appropriations committees under-index in filings relative to dollars

Temporal Trends (2009-2019) Supporting visuals reveal three lobbying patterns:

Growth Committees
Energy & Commerce: +14% CAGR in lobbying dollars

Senate Health: 2.3x increase, likely since ACA passage

Event-Driven Committees
House Judiciary: 2017-19 spike, likely (+62%) from court battles
Steady Power Committees
Both Appropriations committees: <$200M/year fluctuation

Ways & Means: Most consistent year-over-year engagement

Validation of Methodology The two metrics collectively identify:

Must-target committees (High $ + High filings: Energy/Commerce, Finance)

Efficiency plays (High $/filing: Judiciary, Health)

Broad-influence committees (High filings, mid $: Ways & Means)

Suggested Refinements For future analysis, I'd recommend:

Tracking which bills actually became laws would help measure real committee impact. If we knew which committees advanced the most successful bills, we could compare lobbying activity to actual results. For example, a committee might attract lots of lobbying money but rarely pass bills, while another with less lobbying might be more effective at turning bills into laws. This would show whether lobbying dollars match real-world influence.
