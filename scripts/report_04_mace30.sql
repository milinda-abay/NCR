--Run this script against ncr test database t-auea-ncr-sqldb from

--Hospitals
SELECT COUNT(DISTINCT [hid]) AS measure,
	'All',
	'Count of Hospitals' AS measuredescription,
	1 AS ord
FROM ##vw_quarterleyreportdetailncr

UNION

SELECT COUNT(DISTINCT [hid]) AS measure,
	[state],
	'Count of Hospitals' AS measuredescription,
	2 AS ord
FROM ##vw_quarterleyreportdetailncr
GROUP BY [state]

UNION

-- Patients
SELECT COUNT(DISTINCT patientid) AS measure,
	'All',
	'Count of Patients' AS measuredescription,
	3 AS ord
FROM ##vw_quarterleyreportdetailncr

UNION

SELECT COUNT(DISTINCT patientid) AS measure,
	[state],
	'Count of Patients' AS measuredescription,
	4 AS ord
FROM ##vw_quarterleyreportdetailncr
GROUP BY [state]

UNION

-- PCI
SELECT COUNT(dop) AS measure,
	'All',
	'Count of Procedures(Pci cases)' AS measuredescription,
	5 AS ord
FROM ##vw_quarterleyreportdetailncr

UNION

SELECT COUNT(dop) AS measure,
	[state],
	'Count of Procedures(Pci cases) by State' AS measuredescription,
	6 AS ord
FROM ##vw_quarterleyreportdetailncr
GROUP BY [state]
--In Hospital In Hospital Mace within 30 days
SELECT SUM(ihmacenew) ihmace30,
	COUNT(dop) AS cases,
	CAST(SUM(ihmacenew) AS FLOAT) / COUNT(dop) * 100 ihmacewithin30days,
	'All' AS [state]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'

UNION ALL

--In Hospital Mace within 30 days
SELECT SUM(ihmacenew) ihmace30,
	COUNT(dop) AS cases,
	CAST(SUM(ihmacenew) AS FLOAT) / COUNT(dop) * 100 ihmacewithin30days,
	[state]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
GROUP BY [state]
--30 Days In hospital Mace excluding Shock/OHCA  All
SELECT SUM(ihmacenew) ihmace30,
	COUNT(dop) AS cases,
	CAST(SUM(ihmacenew) AS FLOAT) / COUNT(dop) * 100 ihmacewithin30days,
	'All' AS [state]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
	AND shocksohca = 0

UNION ALL

--30 Days In hospital Mace excluding Shock/OHCA  State
SELECT SUM(ihmacenew) ihmace30,
	COUNT(dop) AS cases,
	CAST(SUM(ihmacenew) AS FLOAT) / COUNT(dop) * 100 ihmacewithin30days,
	[state]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
	AND shocksohca = 0
GROUP BY [state]
--Numbers for the funnel plot ihmace30
--  for each site
SELECT SUM(ihmacenew) ihmace30#,
	COUNT(dop) AS cases,
	SUM(CAST(ihmacenew AS FLOAT)) / COUNT(dop) * 100 ihmacewithin30days,
	'All' AS [state],
	'All' AS [ncrhid]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'

UNION ALL

SELECT SUM(ihmacenew) ihmace30#,
	COUNT(dop) AS cases,
	SUM(CAST(ihmacenew AS FLOAT)) / COUNT(dop) * 100 ihmacewithin30days,
	[state],
	CAST([ncrhid] AS VARCHAR(3)) ncrhid
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
GROUP BY [state],
	[ncrhid]
--Numbers for the funnel plot ihmace30 without shock or OHCA
--  for each site
SELECT SUM(ihmacenew) ihmace30excshocksohca#,
	COUNT(dop) AS cases,
	SUM(CAST(ihmacenew AS FLOAT)) / COUNT(dop) * 100 ihmacewithin30days,
	'All' AS [state],
	'All' AS [ncrhid]
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
	AND shocksohca = 0

UNION ALL

SELECT SUM(ihmacenew) ihmace30excshocksohca#,
	COUNT(dop) AS cases,
	SUM(CAST(ihmacenew AS FLOAT)) / COUNT(dop) * 100 ihmacewithin30days,
	[state],
	CAST([ncrhid] AS VARCHAR(3)) ncrhid
FROM ##vw_quarterleyreportdetailncr
WHERE dop >= '2019-12-01'
	AND dop <= '2022-06-01'
	AND shocksohca = 0
GROUP BY [state],
	[ncrhid]