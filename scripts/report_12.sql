
/* Report 12 06/07/2023 */
--Select *  from ##vw_quarterleyreportdetailncr
--Hospitals
    SELECT
        Count(DISTINCT [hid]) AS measure,
        'All',
        'Count of Hospitals' AS measuredescription,
        1 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        Count(DISTINCT [hid]) AS measure,
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
        Count(
        DISTINCT Cast(patientid AS VARCHAR(50)) + Cast(ncrhid AS VARCHAR(50))
        ) AS measure,
        'All',
        'Count of Patients' AS measuredescription,
        3 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        Count(
        DISTINCT Cast(patientid AS VARCHAR(50)) + Cast(ncrhid AS VARCHAR(50))
        ) AS measure,
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
        Count(dop) AS measure,
        'All',
        'Count of Procedures(Pci cases)' AS measuredescription,
        5 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        Count(dop) AS measure,
        [state],
        'Count of Procedures(Pci cases) by State' AS measuredescription,
        6 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
        [state]
--Lesion Success banner
    SELECT
        Sum(alllesionsuccess) / Cast(Count(dop) AS FLOAT) * 100 AS measure,
        'All',
        'PercentageOfLesionSuccess' AS measuredescription,
        7 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        Sum(alllesionsuccess) / Cast(Count(dop) AS FLOAT) * 100 AS measure,
        [state],
        'PercentageOfLesionSuccess by State' AS measuredescription,
        8 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
        [state]
--Procedure Success banner
    SELECT
        Sum(
        CASE
        WHEN sigcomplication = 0
            AND alllesionsuccess = 1 THEN 1
        ELSE 0
        END
        ) / Cast(Count(dop) AS FLOAT) * 100 AS measure,
        'All',
        'PercentageOfProcedureSuccess' AS measuredescription,
        7 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
UNION
    SELECT
        Sum(
        CASE
        WHEN sigcomplication = 0
            AND alllesionsuccess = 1 THEN 1
        ELSE 0
        END
        ) / Cast(Count(dop) AS FLOAT) * 100 AS measure,
        [state],
        'PercentageOfProcedureSuccess by State' AS measuredescription,
        8 AS ord
    FROM
        ##vw_quarterleyreportdetailncr
    GROUP BY
        [state]
/* top chart Title 'Lesion location' */
-- by hospital
SELECT
    ncrhid,
    Count(dop) AS Cases,
    lesionlocgptxt
FROM
    ##vw_quarterleyreportdetailncr
WHERE
    dop BETWEEN '1-dec-2019'
    AND '01-Jun-2022'
GROUP BY
    ncrhid,
    lesionlocgptxt
/* top chart */
-- by All hospitals
SELECT
    'All' allsites,
    Count(dop) AS Cases,
    lesionlocgptxt
FROM
    ##vw_quarterleyreportdetailncr
WHERE
    dop BETWEEN '1-dec-2019'
    AND '01-Jun-2022'
GROUP BY
    lesionlocgptxt
/* bottom chart Data Title 'Lesion success'  by hospital and all */
SELECT
    *
FROM
    (
    SELECT
        ncrhid,
        dop,
        alllesionsuccess,
        CASE
            WHEN sigcomplication = 0
            AND alllesionsuccess = 1 THEN 1
            ELSE 0
        END procsuccess
    FROM
        ##vw_quarterleyreportdetailncr
    ) chart2data
WHERE
    dop BETWEEN '1-dec-2019'
    AND '01-Jun-2022'