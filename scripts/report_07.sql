
--Test script for report 7 NCR.  Run this script against ncr test database t-auea-ncr-sqldb

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

--bar chart

--Banner percentage 2nd from the right
    SELECT
        SUM(
            CASE
            WHEN crh30any = 1
            AND upc30any = 1 THEN 1
            ELSE 0
            END
        ) upc30,
        COUNT(dop) AS Cases,
        CAST(
            SUM(
            CASE
                WHEN crh30any = 1
            AND upc30any = 1 THEN 1
                ELSE 0
            END
            ) AS FLOAT
        ) / COUNT(dop) * 100 UnplannedCardiacRehospitisationWithin30days,
        'All' AS [State]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND dis <> 6
        OR dis IS NULL
    -- if they died in hospital dis = 6 they are not included in the numerator or denominator
UNION ALL
    --unplanned cardiac rehospilsation within 30 days
    SELECT
        SUM(
            CASE
            WHEN crh30any = 1
            AND upc30any = 1 THEN 1
            ELSE 0
            END
        ) upc30,
        COUNT(dop) AS Cases,
        CAST(
            SUM(
            CASE
                WHEN crh30any = 1
            AND upc30any = 1 THEN 1
                ELSE 0
            END
            ) AS FLOAT
        ) / COUNT(dop) * 100 UnplannedCardiacRehospitisationWithin30days,
        [state]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dis <> 6
        OR dis IS NULL
    -- if they died in hospital dis = 6 they are not included in the numerator or denominator
    GROUP BY
        [state]

--unplanned revasc 30  2nd part   (Scatter plot )
--unplanned  revascularisation
    SELECT
        SUM(unprevasc30new) unprevasc30new,
        COUNT(dop) AS Cases,
        SUM(CAST(unprevasc30new AS FLOAT)) / COUNT(dop) * 100 unplannedrevasc30day,
        'All' AS [State]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
UNION ALL
    SELECT
        SUM(unprevasc30new) unprevasc30new,
        COUNT(dop) AS Cases,
        SUM(CAST(unprevasc30new AS FLOAT)) / COUNT(dop) * 100 unplannedrevasc30,
        [state]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY
        [state]

--Numbers for the top barchart report 7
    SELECT
        SUM(
            CASE
            WHEN crh30any = 1
            AND upc30any = 1 THEN 1
            ELSE 0
            END
        ) upc30,
        COUNT(dop) AS Cases,
        CAST(
            SUM(
            CASE
                WHEN crh30any = 1
            AND upc30any = 1 THEN 1
                ELSE 0
            END
            ) AS FLOAT
        ) / COUNT(dop) * 100 UnplannedCardiacRehospitisationWithin30days,
        'All' AS [ncrhid]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND dis <> 6
    -- if they died in hospital dis = 6 they are not included in the numerator or denominator
UNION ALL
    --unplanned cardiac rehospilsation within 30 days
    SELECT
        SUM(
            CASE
            WHEN crh30any = 1
            AND upc30any = 1 THEN 1
            ELSE 0
            END
        ) upc30,
        COUNT(dop) AS Cases,
        CAST(
            SUM(
            CASE
                WHEN crh30any = 1
            AND upc30any = 1 THEN 1
                ELSE 0
            END
            ) AS FLOAT
        ) / COUNT(dop) * 100 UnplannedCardiacRehospitisationWithin30days,
        CAST([ncrhid] AS NVARCHAR(3))
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
        AND dis <> 6
    -- if they died in hospital dis = 6 they are not included in the numerator or denominator
    GROUP BY
        [ncrhid]
--Numbers for the funnel plot
--unplanned  revascularisation  for each site
    SELECT
        SUM(unprevasc30new) unprevasc30new#,
        COUNT(dop) AS Cases,
        SUM(CAST(unprevasc30new AS FLOAT)) / COUNT(dop) * 100 unprevasc30new,
        'All' AS [State],
        'All' AS [ncrhid]
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
UNION ALL
    SELECT
        SUM(unprevasc30new) unprevasc30new#,
        COUNT(dop) AS Cases,
        SUM(CAST(unprevasc30new AS FLOAT)) / COUNT(dop) * 100 unprevasc30new,
        [state],
        CAST([ncrhid] AS VARCHAR(3)) ncrhid
    FROM
        ##vw_quarterleyreportdetailncr
    WHERE
        dop >= '2019-12-01'
        AND dop <= '2022-06-01'
    GROUP BY
        [state],
        [ncrhid]