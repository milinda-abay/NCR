
--Test script for report 5 NCR.  Run this script against ncr test database t-auea-ncr-sqldb from
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

--Discharged on lipid-lowering therapy
--NCRHID
SELECT
    [ncrhid],
    sum(cast(lltgp AS FLOAT)) lltgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(lltgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS lltgpPercentage
FROM
    (
        SELECT
        lltgpDenom.denom,
        lltgpDenom.DOP,
        lltgpDenom.STATE,
        lltgpDenom.ncrhid,
        lltgpDenom.patientid,
        ISNULL(lltnumt.lltgp, 0) AS lltgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dstp IS NOT NULL)
            OR (doll IS NOT NULL)
        ) AS lltgpDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dstp = 1
                AND dis < 6
                )
                OR (
                doll = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dstp > 1
                AND dis < 6
                )
                OR (
                doll > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS lltgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (lltgp = 1)
        ) AS lltnumt ON lltgpDenom.DOP = lltnumt.DOP
            AND lltgpDenom.ncrhid = lltnumt.ncrhid
            AND lltgpDenom.patientid = lltnumt.patientid
            AND lltgpDenom.DOP >= '2021-01-01'
            AND lltgpDenom.DOP <= '2021-12-31'
    ) AS lltDatasetAll
GROUP BY
    [ncrhid]
--State
SELECT
    [state],
    sum(cast(lltgp AS FLOAT)) lltgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(lltgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS lltgpPercentage
FROM
    (
        SELECT
        lltgpDenom.denom,
        lltgpDenom.DOP,
        lltgpDenom.STATE,
        lltgpDenom.ncrhid,
        lltgpDenom.patientid,
        ISNULL(lltnum.lltgp, 0) AS lltgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dstp IS NOT NULL)
            OR (doll IS NOT NULL)
        ) AS lltgpDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dstp = 1
                AND dis < 6
                )
                OR (
                doll = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dstp > 1
                AND dis < 6
                )
                OR (
                doll > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS lltgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (lltgp = 1)
        ) AS lltnum ON lltgpDenom.DOP = lltnum.DOP
            AND lltgpDenom.ncrhid = lltnum.ncrhid
            AND lltgpDenom.patientid = lltnum.patientid
            AND lltgpDenom.DOP >= '2021-01-01'
            AND lltgpDenom.DOP <= '2021-12-31'
    ) AS lltDatasetAll
GROUP BY
    [state]
--All
SELECT
    [state],
    sum(cast(lltgp AS FLOAT)) lltgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(lltgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS lltgpPercentage
FROM
    (
        SELECT
        lltgpDenom.denom,
        lltgpDenom.DOP,
        lltgpDenom.STATE,
        lltgpDenom.ncrhid,
        lltgpDenom.patientid,
        ISNULL(lltnum.lltgp, 0) AS lltgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            'All' AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dstp IS NOT NULL)
            OR (doll IS NOT NULL)
        ) AS lltgpDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dstp = 1
                AND dis < 6
                )
                OR (
                doll = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dstp > 1
                AND dis < 6
                )
                OR (
                doll > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS lltgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (lltgp = 1)
        ) AS lltnum ON lltgpDenom.DOP = lltnum.DOP
            AND lltgpDenom.ncrhid = lltnum.ncrhid
            AND lltgpDenom.patientid = lltnum.patientid
            AND lltgpDenom.DOP >= '2021-01-01'
            AND lltgpDenom.DOP <= '2021-12-31'
    ) AS lltDatasetAll
GROUP BY
    [state]

--Discharged on dual antiplatelet therapy
--NCRHID
SELECT
    [ncrhid],
    sum(cast(daptgp AS FLOAT)) daptgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(daptgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS daptgpPercentage
FROM
    (
        SELECT
        DaptDenom.denom,
        DaptDenom.DOP,
        DaptDenom.STATE,
        DaptDenom.ncrhid,
        DaptDenom.patientid,
        ISNULL(Daptnum.daptgp, 0) AS daptgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dasp IS NOT NULL)
            OR (doap IS NOT NULL)
        ) AS DaptDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dasp = 1
                AND dis < 6
                )
                OR (
                doap = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dasp > 1
                AND dis < 6
                )
                OR (
                doap > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS daptgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (daptgp = 1)
        ) AS Daptnum ON DaptDenom.DOP = Daptnum.DOP
            AND DaptDenom.ncrhid = Daptnum.ncrhid
            AND DaptDenom.patientid = Daptnum.patientid
            AND DaptDenom.DOP >= '2021-01-01'
            AND DaptDenom.DOP <= '2021-12-31'
    ) AS DaptDatasetAll
GROUP BY
    [ncrhid]
    
--State
SELECT
    [state],
    sum(cast(daptgp AS FLOAT)) daptgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(daptgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS daptgpPercentage
FROM
    (
        SELECT
        DaptDenom.denom,
        DaptDenom.DOP,
        DaptDenom.STATE,
        DaptDenom.ncrhid,
        DaptDenom.patientid,
        ISNULL(Daptnum.daptgp, 0) AS daptgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            [state] AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dasp IS NOT NULL)
            OR (doap IS NOT NULL)
        ) AS DaptDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dasp = 1
                AND dis < 6
                )
                OR (
                doap = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dasp > 1
                AND dis < 6
                )
                OR (
                doap > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS daptgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (daptgp = 1)
        ) AS Daptnum ON DaptDenom.DOP = Daptnum.DOP
            AND DaptDenom.ncrhid = Daptnum.ncrhid
            AND DaptDenom.patientid = Daptnum.patientid
            AND DaptDenom.DOP >= '2021-01-01'
            AND DaptDenom.DOP <= '2021-12-31'
    ) AS DaptDatasetAll
GROUP BY
    [state]
--All
SELECT
    [state],
    sum(cast(daptgp AS FLOAT)) daptgp,
    sum(Cast(denom AS FLOAT)) denom,
    sum(cast(daptgp AS FLOAT)) / sum(Cast(denom AS FLOAT)) AS daptgpPercentage
FROM
    (
        SELECT
        DaptDenom.denom,
        DaptDenom.DOP,
        DaptDenom.STATE,
        DaptDenom.ncrhid,
        DaptDenom.patientid,
        ISNULL(Daptnum.daptgp, 0) AS daptgp
    FROM
        (
            SELECT
            1 AS denom,
            DOP,
            'All' AS STATE,
            ncrhid,
            patientid
        FROM
            (
                SELECT
                *
            FROM
                ##vw_quarterleyreportdetailncr
            WHERE
                DOP >= '2021-01-01'
                AND DOP <= '2021-12-31'
            ) ##vw_quarterleyreportdetailncr
        WHERE
            (dasp IS NOT NULL)
            OR (doap IS NOT NULL)
        ) AS DaptDenom
        LEFT OUTER JOIN (
            SELECT
            DOP,
            dstp,
            doll,
            dasp,
            doap,
            dis,
            ncrhid,
            patientid,
            STATE,
            CASE
                WHEN (
                dasp = 1
                AND dis < 6
                )
                OR (
                doap = 1
                AND dis < 6
                ) THEN 1
                WHEN (
                dasp > 1
                AND dis < 6
                )
                OR (
                doap > 1
                AND dis < 6
                ) THEN 2
                ELSE 0
            END AS daptgp
        FROM
            ##vw_quarterleyreportdetailncr AS vw_QuarterleyReportDetailNCR_1
        WHERE
            (daptgp = 1)
        ) AS Daptnum ON DaptDenom.DOP = Daptnum.DOP
            AND DaptDenom.ncrhid = Daptnum.ncrhid
            AND DaptDenom.patientid = Daptnum.patientid
            AND DaptDenom.DOP >= '2021-01-01'
            AND DaptDenom.DOP <= '2021-12-31'
    ) AS DaptDatasetAll
GROUP BY
    [state]