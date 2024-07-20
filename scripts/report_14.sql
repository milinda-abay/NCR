--- Non-ACS cohort discharged alive
WITH
    NonACScohort
    AS
    (
        SELECT
            ncrhid,
            DOP,
            patientid,
            STATE,
            LOS,
            CASE
                WHEN LOS = 0 THEN 'Less the 24hrs'
                WHEN LOS = 1 THEN '1 Day'
                ELSE '2 plus days'
            END AS LOScategory
        FROM
            ##vw_quarterleyreportdetailncr
        WHERE
            (LOS IS NOT NULL)
            AND (dis <> 6)
            AND (acs = 0)
            AND (DOP >= '2021-01-01')
            AND (DOP <= '2021-12-31')
    )
SELECT
    b.*,
    a.TotalProcs,
    cast(b.Procs AS FLOAT) / cast(a.TotalProcs AS FLOAT) * 100 AS LoSCategoryPercentage
FROM
    (
    SELECT
        ncrhid,
        count(DOP) TotalProcs
    FROM
        NonACScohort
    GROUP BY
        ncrhid
    ) A
    INNER JOIN
    (
    SELECT
        ncrhid,
        count(DOP) Procs,
        LOScategory
    FROM
        NonACScohort
    GROUP BY
        ncrhid,
        LOScategory
        ) B ON a.ncrhid = b.ncrhid
ORDER BY
  ncrhid,
  LOScategory
--- NSTEMI cohort discharged alive
;
WITH
    NSTEMIcohort
    AS
    (
        SELECT
            ncrhid,
            DOP,
            patientid,
            STATE,
            LOS,
            CASE
                WHEN LOS = 0 THEN 'Less the 24hrs'
                WHEN LOS = 1 THEN '1 Day'
                WHEN LOS = 2 THEN '2 Days'
                WHEN LOS = 3 THEN '3 Days'
                WHEN LOS = 4 THEN '4 Days'
                ELSE '5 plus days'
            END AS LOScategory
        FROM
            ##vw_quarterleyreportdetailncr
        WHERE
            (LOS IS NOT NULL)
            AND (dis <> 6)
            AND (acst = 2)
            AND (DOP >= '2021-01-01')
            AND (DOP <= '2021-12-31')
    )
SELECT
    b.*,
    a.TotalProcs,
    cast(b.Procs AS FLOAT) / cast(a.TotalProcs AS FLOAT) * 100 AS LoSCategoryPercentage
FROM
    (
    SELECT
        ncrhid,
        count(DOP) TotalProcs
    FROM
        NSTEMIcohort
    GROUP BY
      ncrhid
  ) a
    INNER JOIN
    (
    SELECT
        ncrhid,
        count(DOP) Procs,
        LOScategory
    FROM
        NSTEMIcohort
    GROUP BY
      ncrhid,
      LOScategory
    ) b ON a.ncrhid = b.ncrhid
ORDER BY
  a.ncrhid,
  LOScategory