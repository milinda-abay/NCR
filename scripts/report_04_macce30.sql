--Test script for report 8 NCR.  Run this script against [PRDCRT-AGL1].[MNHS-Registry-VCOR] after you have transfered data from  ncr test database t-auea-ncr-sqldb from
--Select *  from ##vw_quarterleyreportdetailncr
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
--In Hospital macce within 30 days
    SELECT SUM(ihmaccenew) ihmacce30,
        COUNT(dop) AS cases,
        CAST(SUM(ihmaccenew) AS FLOAT) / COUNT(dop) * 100 ihmaccewithin30days,
        'All' AS [state]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'

UNION ALL

    --In Hospital macce within 30 days
    SELECT SUM(ihmaccenew) ihmacce30,
        COUNT(dop) AS cases,
        CAST(SUM(ihmaccenew) AS FLOAT) / COUNT(dop) * 100 ihmaccewithin30days,
        [state]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY [state]
--30 Days In Hospital macce excluding Shock/OHCA  All
    SELECT SUM(ihmaccenew) ihmacce30,
        COUNT(dop) AS cases,
        CAST(SUM(ihmaccenew) AS FLOAT) / COUNT(dop) * 100 ihmaccewithin30days,
        'All' AS [state]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0

UNION ALL

    --30 Days In Hospital macce excluding Shock/OHCA  State
    SELECT SUM(ihmaccenew) ihmacce30,
        COUNT(dop) AS cases,
        CAST(SUM(ihmaccenew) AS FLOAT) / COUNT(dop) * 100 ihmaccewithin30days,
        [state]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
    GROUP BY [state]
--Numbers for the funnel plot ihmacce30
--  for each site
    SELECT SUM(ihmaccenew) ihmacce30#,
        COUNT(dop) AS cases,
        SUM(CAST(ihmaccenew AS FLOAT)) / COUNT(dop) * 100 ihmaccewithin30days,
        'All' AS [state],
        'All' AS [ncrhid]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'

UNION ALL

    SELECT SUM(ihmaccenew) ihmacce30#,
        COUNT(dop) AS cases,
        SUM(CAST(ihmaccenew AS FLOAT)) / COUNT(dop) * 100 ihmaccewithin30days,
        [state],
        CAST([ncrhid] AS VARCHAR(3)) ncrhid
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY [state],
	[ncrhid]
--Numbers for the funnel plot ihmacce30 without shock or OHCA
--  for each site
    SELECT SUM(ihmaccenew) ihmacce30excshocksohca#,
        COUNT(dop) AS cases,
        SUM(CAST(ihmaccenew AS FLOAT)) / COUNT(dop) * 100 ihmaccewithin30days,
        'All' AS [state],
        'All' AS [ncrhid]
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0

UNION ALL

    SELECT SUM(ihmaccenew) ihmacce30excshocksohca#,
        COUNT(dop) AS cases,
        SUM(CAST(ihmaccenew AS FLOAT)) / COUNT(dop) * 100 ihmaccewithin30days,
        [state],
        CAST([ncrhid] AS VARCHAR(3)) ncrhid
    FROM ##vw_quarterleyreportdetailncr
    WHERE dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
    GROUP BY [state],
	[ncrhid]