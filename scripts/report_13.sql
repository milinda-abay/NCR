
--Test script for report 5 NCR.  Run this script against [PRDCRT-AGL1].[MNHS-Registry-VCOR] after you have transfered data from  ncr test database t-auea-ncr-sqldb from
--Hospitals  2021
    SELECT
        count(DISTINCT [HID]) AS measure,
        'All',
        'Count of Hospitals' AS measuredescription,
        1 AS ord
    FROM
        (
        SELECT
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
UNION
    SELECT
        count(DISTINCT [HID]) AS measure,
        [State],
        'Count of Hospitals' AS measuredescription,
        2 AS ord
    FROM
        (
        SELECT
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
    GROUP BY
        [State]
UNION
    -- Patients
    SELECT
        count(
            DISTINCT cast(Patientid AS VARCHAR(50)) + cast(ncrhid AS VARCHAR(50))
        ) AS measure,
        'All',
        'Count of Patients' AS measuredescription,
        3 AS ord
    FROM
        (
        SELECT
            ncrhid,
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
UNION
    SELECT
        count(
            DISTINCT cast(Patientid AS VARCHAR(50)) + cast(ncrhid AS VARCHAR(50))
        ) AS measure,
        [State],
        'Count of Patients' AS measuredescription,
        4 AS ord
    FROM
        (
        SELECT
            ncrhid,
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
    GROUP BY
        [State]
UNION
    -- PCI
    SELECT
        count(dop) AS measure,
        'All',
        'Count of Procedures(Pci cases)' AS measuredescription,
        5 AS ord
    FROM
        (
        SELECT
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
UNION
    SELECT
        count(dop) AS measure,
        [State],
        'Count of Procedures(Pci cases) by State' AS measuredescription,
        6 AS ord
    FROM
        (
        SELECT
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
        ) x
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
    GROUP BY
        [State]
/*
            
            *Box plot 13. Days in Hospital (LOS)
            
            graph box los, over(ncrhid) noout
            graph save LOS.gph,replace
            */
--Question for Milinda   can we have the median in the box plot in power bi returning the same number as what we get in excel or stata   in metions inclusive.   Is it an option that can be turned on or off.
--NCRHID
SELECT
    ncrhid,
    min(LOS) minlos,
    max(LOS) maxlos,
    Avg(CAST(LOS AS FLOAT)) avglos
FROM
    (
    SELECT
        ncrhid,
        HID,
        DOP,
        PatientId,
        [State],
        CASE
            WHEN Los > 30 THEN 30
            ELSE Los
        END AS Los
    FROM
        ##vw_quarterleyreportdetailncr
    ) x
WHERE
    los IS NOT NULL -- and los < 31
    AND DOP >= '2021-01-01'
    AND DOP <= '2021-12-31'
GROUP BY
    ncrhid
ORDER BY
    ncrhid
--State
SELECT
    [state],
    min(LOS) minlos,
    max(LOS) maxlos,
    Avg(CAST(LOS AS FLOAT)) avglos
FROM
    (
    SELECT
        ncrhid,
        HID,
        DOP,
        PatientId,
        [State],
        CASE
            WHEN Los > 30 THEN 30
            ELSE Los
        END AS Los
    FROM
        ##vw_quarterleyreportdetailncr
    ) x
WHERE
    los IS NOT NULL
    AND DOP >= '2021-01-01'
    AND DOP <= '2021-12-31'
GROUP BY
        [state]
ORDER BY
        [state]
--All
SELECT
    'All' [state],
    min(LOS) minlos,
    max(LOS) maxlos,
    Avg(CAST(LOS AS FLOAT)) avglos
FROM
    (
    SELECT
        ncrhid,
        HID,
        DOP,
        PatientId,
        [State],
        CASE
            WHEN Los > 30 THEN 30
            ELSE Los
        END AS Los
    FROM
        ##vw_quarterleyreportdetailncr
    ) x
WHERE
    los IS NOT NULL
    AND DOP >= '2021-01-01'
    AND DOP <= '2021-12-31'
SELECT
    DISTINCT ncrhid,
    [state],
    PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY ncrhid) p25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY ncrhid) p50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY ncrhid) p75
FROM
    (
    SELECT
        ncrhid,
        HID,
        DOP,
        PatientId,
        [State],
        CASE
            WHEN Los > 30 THEN 30
            ELSE Los
        END AS Los
    FROM
        ##vw_quarterleyreportdetailncr
        ) x
WHERE
    los IS NOT NULL
    AND DOP >= '2021-01-01'
    AND DOP <= '2021-12-31'
--State
SELECT
    DISTINCT [state],
    PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p75
FROM
    (
    SELECT
        ncrhid,
        HID,
        DOP,
        PatientId,
        [State],
        CASE
            WHEN Los > 30 THEN 30
            ELSE Los
        END AS Los
    FROM
        ##vw_quarterleyreportdetailncr
        ) x
WHERE
    los IS NOT NULL
    AND DOP >= '2021-01-01'
    AND DOP <= '2021-12-31'
--All
SELECT
    DISTINCT [state],
    PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
            los
        ) OVER (PARTITION BY [state]) p75
FROM
    (
    SELECT
        'All' AS [state],
        los
    FROM
        (
        SELECT
            ncrhid,
            HID,
            DOP,
            PatientId,
            [State],
            CASE
                WHEN Los > 30 THEN 30
                ELSE Los
            END AS Los
        FROM
            ##vw_quarterleyreportdetailncr
            ) x
    WHERE
        los IS NOT NULL
        AND DOP >= '2021-01-01'
        AND DOP <= '2021-12-31'
        ) dataset