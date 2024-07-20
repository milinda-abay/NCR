
--Test script for report 5 NCR.  Run this script against [PRDCRT-AGL1].[MNHS-Registry-VCOR] after you have transfered data from  ncr test database t-auea-ncr-sqldb from
--Hospitals  2021
    SELECT
        count(DISTINCT [HID]) AS measure,
        'All',
        'Count of Hospitals' AS measuredescription,
        1 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
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
        ##vw_quarterleyreportdetailncr
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
        ##vw_quarterleyreportdetailncr
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
        ##vw_quarterleyreportdetailncr
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
        ##vw_quarterleyreportdetailncr
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
        ##vw_quarterleyreportdetailncr
    WHERE
        Dop >= '2021-01-01'
        AND Dop <= '2021-12-31'
    GROUP BY
    [State]
/*
        *Bar graph 6. Rehab Referral
        
        tab crehab ncrhid, if dis<6 & crehab!=-1
        */
--NCRHID
SELECT
    [ncrhid],
    sum(cast(crehabapplies AS FLOAT)) crehabapplies,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(crehabapplies AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS crehabPercentage
FROM
    (
        SELECT
        crehabDenom.denom,
        crehabDenom.DOP,
        crehabDenom.STATE,
        crehabDenom.ncrhid,
        crehabDenom.patientid,
        ISNULL(tcrehab.crehabapplies, 0) AS crehabapplies
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            ##vw_quarterleyreportdetailncr
        WHERE
            crehab IS NOT NULL
            AND DOP >= '2021-01-01'
            AND DOP <= '2021-12-31'
        ) AS crehabDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            crehab,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN dis < 6
                AND crehab = 1 THEN 1
                ELSE 0
            END AS crehabapplies
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        ) AS tcrehab ON crehabDenom.DOP = tcrehab.DOP
            AND crehabDenom.ncrhid = tcrehab.ncrhid
            AND crehabDenom.patientid = tcrehab.patientid
            AND crehabDenom.DOP >= '2021-01-01'
            AND crehabDenom.DOP <= '2021-12-31'
    ) AS crehabDatasetAll
GROUP BY
    [ncrhid]
--State
SELECT
    [state],
    sum(cast(crehabapplies AS FLOAT)) crehabapplies,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(crehabapplies AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS crehabPercentage
FROM
    (
        SELECT
        crehabDenom.denom,
        crehabDenom.DOP,
        crehabDenom.STATE,
        crehabDenom.ncrhid,
        crehabDenom.patientid,
        ISNULL(tcrehab.crehabapplies, 0) AS crehabapplies
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            ##vw_quarterleyreportdetailncr
        WHERE
            crehab IS NOT NULL
            AND DOP >= '2021-01-01'
            AND DOP <= '2021-12-31'
        ) AS crehabDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            crehab,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN dis < 6
                AND crehab = 1 THEN 1
                ELSE 0
            END AS crehabapplies
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        ) AS tcrehab ON crehabDenom.DOP = tcrehab.DOP
            AND crehabDenom.ncrhid = tcrehab.ncrhid
            AND crehabDenom.patientid = tcrehab.patientid
            AND crehabDenom.DOP >= '2021-01-01'
            AND crehabDenom.DOP <= '2021-12-31'
    ) AS crehabDatasetAll
GROUP BY
    [state]
--All
SELECT
    [state],
    sum(cast(crehabapplies AS FLOAT)) crehabapplies,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(crehabapplies AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS crehabPercentage
FROM
    (
        SELECT
        crehabDenom.denom,
        crehabDenom.DOP,
        crehabDenom.STATE,
        crehabDenom.ncrhid,
        crehabDenom.patientid,
        ISNULL(tcrehab.crehabapplies, 0) AS crehabapplies
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            'All' AS STATE,
            ncrhid,
            patientid
        FROM
            ##vw_quarterleyreportdetailncr
        WHERE
            crehab IS NOT NULL
            AND DOP >= '2021-01-01'
            AND DOP <= '2021-12-31'
        ) AS crehabDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            crehab,
            ncrhid,
            patientid,
            'All' STATE,
            CASE
                WHEN dis < 6
                AND crehab = 1 THEN 1
                ELSE 0
            END AS crehabapplies
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        ) AS tcrehab ON crehabDenom.DOP = tcrehab.DOP
            AND crehabDenom.ncrhid = tcrehab.ncrhid
            AND crehabDenom.patientid = tcrehab.patientid
            AND crehabDenom.DOP >= '2021-01-01'
            AND crehabDenom.DOP <= '2021-12-31'
    ) AS crehabDatasetAll
GROUP BY
    [state]