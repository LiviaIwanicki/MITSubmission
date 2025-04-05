--Task D
--Standard_titles helps to find all unique bills that end with act, law, resolution (regardless of case)
--Non-standard titles finds the rest of the bills whose titles are not in the standard_titles list.
--The final select statement finds the total counts for each title type.
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
 