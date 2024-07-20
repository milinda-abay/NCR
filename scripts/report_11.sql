
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
        *Bar graph 11. Pel  entry location
        Select distinct pel  FROM            ##vw_quarterleyreportdetailncr
        tab Pel ncrhid
        
        Field Value	Field Description
        1	Brachial
        2	Radial
        3	Femoral
        */
--NCRHID   Put in excel and pivot table
SELECT
    pelDenom.denom,
    pelDenom.DOP,
    pelDenom.STATE,
    pelDenom.ncrhid,
    pelDenom.patientid,
    ISNULL(pelnumerator, 0) AS pelnumerator,
    CASE
        WHEN peldenom.pel = 1 THEN 'Brachial'
        WHEN peldenom.pel = 2 THEN 'Radial'
        WHEN peldenom.pel = 3 THEN 'Femoral'
    END pelgp
FROM
    (
        SELECT
        1 AS denom,
        DOP,
        [state] AS STATE,
        ncrhid,
        patientid,
        pel
    FROM
        ##quarterleyreportdetailncr
    WHERE
        pel IS NOT NULL
        AND DOP >= '2021-01-01'
        AND DOP <= '2021-12-31'
    ) AS pelDenom
    LEFT OUTER JOIN (
        SELECT
        DOP,
        pel,
        ncrhid,
        patientid,
        STATE,
        CASE
            WHEN pel > 0 THEN 1
            ELSE 0
        END pelnumerator
    FROM
        ##quarterleyreportdetailncr AS vw_quarterleyreportdetailncr_1
    WHERE
        pel IS NOT NULL
    ) AS tpel ON pelDenom.DOP = tpel.DOP
        AND pelDenom.ncrhid = tpel.ncrhid
        AND pelDenom.patientid = tpel.patientid
        AND pelDenom.DOP >= '2021-01-01'
        AND pelDenom.DOP <= '2021-12-31'
WHERE
        pelDenom.STATE = 'NSW'