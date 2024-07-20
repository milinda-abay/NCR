
--Test script for report 8 NCR.  Run this script against [PRDCRT-AGL1].[MNHS-Registry-VCOR] after you have transfered data from  ncr test database t-auea-ncr-sqldb from
--Select *  from ##vw_quarterleyreportdetailncr
--Hospitals
    SELECT
        COUNT(DISTINCT [hid]) AS measure,
        'All',
        'Count of Hospitals' AS measuredescription,
        1 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        COUNT(DISTINCT [hid]) AS measure,
        [state],
        'Count of Hospitals' AS measuredescription,
        2 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
    [state]
UNION
    -- Patients
    SELECT
        COUNT(DISTINCT patientid) AS measure,
        'All',
        'Count of Patients' AS measuredescription,
        3 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        COUNT(DISTINCT patientid) AS measure,
        [state],
        'Count of Patients' AS measuredescription,
        4 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
    [state]
UNION
    -- PCI
    SELECT
        COUNT(dop) AS measure,
        'All',
        'Count of Procedures(Pci cases)' AS measuredescription,
        5 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        COUNT(dop) AS measure,
        [state],
        'Count of Procedures(Pci cases) by State' AS measuredescription,
        6 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
    [state]
-- numerator is number of unique deaths e.g 1 death per patient we don't care if in or out of hospital as long as it's within 30 days of the last procedure.  denominator is count of procedures e.g
-- a patient that dies 10 days after discharge may have had 4 procedures over 2 admissions.   So the numerator would be 1 and the denominator is 4   1 divided by 4 is 0.25
--Banner percentage 2nd from the right --Mortality within 30 days
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30 = 1 THEN 1
        ELSE 0
        END
        ) mort30,
        COUNT(dop) AS Cases,
        CAST(
        SUM(
        CASE
            WHEN procone = 1
            AND mort30 = 1 THEN 1
            ELSE 0
        END
        ) AS FLOAT
    ) / COUNT(dop) * 100 MortalityWithin30Days,
        'All' AS [State]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
            ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
    ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
UNION ALL
    --Mortality within 30 days
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30 = 1 THEN 1
        ELSE 0
        END
        ) mort30,
        COUNT(dop) AS Cases,
        CAST(
        SUM(
        CASE
            WHEN procone = 1
            AND mort30 = 1 THEN 1
            ELSE 0
        END
        ) AS FLOAT
        ) / COUNT(dop) * 100 MortalityWithin30Days,
        [state]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY
    [state]
--30 Days Mortality excluding Shock/OHCA
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
        ELSE 0
        END
        ) mort30excsshocksohca,
        COUNT(dop) AS Cases,
        CAST(
        SUM(
        CASE
            WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
            ELSE 0
        END
        ) AS FLOAT
        ) / COUNT(dop) * 100 MortalityWithoutShockOrOHCAWithin30Days,
        'All' AS [State]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
UNION ALL
    --Mortality within 30 days
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
        ELSE 0
        END
        ) mort30excshocksohca,
        COUNT(dop) AS Cases,
        CAST(
        SUM(
        CASE
            WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
            ELSE 0
        END
        ) AS FLOAT
        ) / COUNT(dop) * 100 MortalityWithoutShockOrOHCAWithin30Days,
        [state]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
    GROUP BY
        [state]
--Numbers for the funnel plot mort30
--  for each site
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30 = 1 THEN 1
        ELSE 0
        END
        ) mort30#,
        COUNT(dop) AS Cases,
        SUM(
        CAST(
        CASE
            WHEN procone = 1
            AND mort30 = 1 THEN 1
            ELSE 0
        END AS FLOAT
        )
        ) / COUNT(dop) * 100 MortalityWithin30Days,
        'All' AS [State],
        'All' AS [ncrhid]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
UNION ALL
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30 = 1 THEN 1
        ELSE 0
        END
        ) mort30#,
        COUNT(dop) AS Cases,
        SUM(
        CAST(
        CASE
            WHEN procone = 1
            AND mort30 = 1 THEN 1
            ELSE 0
        END AS FLOAT
        )
        ) / COUNT(dop) * 100 MortalityWithin30Days,
        [state],
        CAST([ncrhid] AS VARCHAR(3)) ncrhid
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY
        [state],
        [ncrhid]
--Numbers for the funnel plot mort30 without shock or OHCA
--  for each site
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
        ELSE 0
        END
        ) mort30excshocksohca#,
        COUNT(dop) AS Cases,
        SUM(
        CAST(
        CASE
            WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
            ELSE 0
        END AS FLOAT
        )
        ) / COUNT(dop) * 100 MortalityWithin30Days,
        'All' AS [State],
        'All' AS [ncrhid]
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
UNION ALL
    SELECT
        SUM(
        CASE
        WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
        ELSE 0
        END
        ) mort30excshocksohca#,
        COUNT(dop) AS Cases,
        SUM(
        CAST(
        CASE
            WHEN procone = 1
            AND mort30excshocksohca = 1 THEN 1
            ELSE 0
        END AS FLOAT
        )
        ) / COUNT(dop) * 100 MortalityWithin30Days,
        [state],
        CAST([ncrhid] AS VARCHAR(3)) ncrhid
    FROM
        (
        SELECT
            ROW_NUMBER() OVER (
            PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid))
            ORDER BY
            dop
        ) AS procone,
            *
        FROM
            ##vw_quarterleyreportdetailncr
        ) mortdata
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND shocksohca = 0
    GROUP BY
    [state],
    [ncrhid]