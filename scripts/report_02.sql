
----Data for banner
--Hospitals
  SELECT count(DISTINCT [HID]) AS measure,
    'All',
    'Count of Hospitals' AS measuredescription,
    1 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'

UNION

  SELECT count(DISTINCT [HID]) AS measure,
    [State],
    'Count of Hospitals' AS measuredescription,
    2 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'
  GROUP BY [State]

UNION

  -- Patients
  SELECT count(DISTINCT cast(Patientid AS VARCHAR(50)) + cast(ncrhid AS VARCHAR(50))) AS measure,
    'All',
    'Count of Patients' AS measuredescription,
    3 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'

UNION

  SELECT count(DISTINCT cast(Patientid AS VARCHAR(50)) + cast(ncrhid AS VARCHAR(50))) AS measure,
    [State],
    'Count of Patients' AS measuredescription,
    4 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'
  GROUP BY [State]

UNION

  -- PCI
  SELECT count(dop) AS measure,
    'All',
    'Count of Procedures(Pci cases)' AS measuredescription,
    5 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'

UNION

  SELECT count(dop) AS measure,
    [State],
    'Count of Procedures(Pci cases) by State' AS measuredescription,
    6 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'
  GROUP BY [State]
--Proportion of Cases where Door to balloon time less than 90 minutes.
-- PCI
  SELECT count(dop) AS measure,
    sum(CASE 
          WHEN dbdt <= 90
            THEN 1
          ELSE 0
          END) dbbdtLessThan90,
    Cast(sum(CASE 
            WHEN dbdt <= 90
              THEN 1
            ELSE 0
            END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
    0.75 * count(dop) Target75,
    0.75 [Target                                 ],
    'All' AS [State],
    'proportioncasesDbdtLessThan90' AS measuredescription,
    5 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'

UNION

  SELECT count(dop) AS measure,
    sum(CASE 
          WHEN dbdt <= 90
            THEN 1
          ELSE 0
          END) dbbdtLessThan90,
    Cast(sum(CASE 
            WHEN dbdt <= 90
              THEN 1
            ELSE 0
            END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
    0.75 * count(dop) Target75,
    0.75 [Target],
    [State],
    'proportioncasesDbdtLessThan90 buy State' AS measuredescription,
    6 AS ord
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'
  GROUP BY [State]
-- Count of Hosptials that acheived 75% of their target
  SELECT count(*) CountHospitalsAchieved75pTarget,
    'All' [State]
  FROM (
      SELECT count(dop) AS measure,
      sum(CASE 
            WHEN dbdt <= 90
              THEN 1
            ELSE 0
            END) dbbdtLessThan90,
      Cast(sum(CASE 
              WHEN dbdt <= 90
                THEN 1
              ELSE 0
              END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
      0.75 * count(dop) Target75,
      0.75 [Target],
      'All' AS [State],
      ncrhid,
      'CountcasesDbdtLessThan90' AS measuredescription,
      5 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
      AND iht = 0
      AND (inp = 0)
      AND s2d >= 0
      AND s2d < 721
      AND s2d IS NOT NULL
      AND dbdt > 0
      AND DOP >= '01-Jan-2022'
      AND DOP <= '31-Dec-2022'
    GROUP BY ncrhid
      ) AllStates
  WHERE proportioncasesLessThan90 > [Target]

UNION ALL

  SELECT count(*) CountHospitalsAchieved75pTarget,
    [State]
  FROM (
      SELECT count(dop) AS measure,
      sum(
        CASE 
          WHEN dbdt <= 90
          THEN 1
          ELSE 0
          END) dbbdtLessThan90,
      Cast(
        sum(
          CASE 
            WHEN dbdt <= 90
            THEN 1
            ELSE 0
            END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
      0.75 * count(dop) Target75,
      0.75 [Target],
      [State],
      ncrhid,
      'CountcasesDbdtLessThan90 by State' AS measuredescription,
      6 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
      AND iht = 0
      AND (inp = 0)
      AND s2d >= 0
      AND s2d < 721
      AND s2d IS NOT NULL
      AND dbdt > 0
      AND DOP >= '01-Jan-2022'
      AND DOP <= '31-Dec-2022'
    GROUP BY [State],
        ncrhid
      ) IndividualStates
  WHERE proportioncasesLessThan90 > [Target]
  GROUP BY [State]
-- TOP bar chart Proportion of Door to Reperfusion times < 90 Minutions
--Proportion of Cases where Door to balloon time less than 90 minutes.
--  Overall each site
SELECT count(dop) AS measure,
  sum(CASE 
          WHEN dbdt <= 90
            THEN 1
          ELSE 0
          END) dbbdtLessThan90,
  Cast(sum(CASE 
            WHEN dbdt <= 90
              THEN 1
            ELSE 0
            END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
  0.75 * count(dop) Target75,
  0.75 [Target],
  'All' AS [State],
  ncrhid,
  'proportioncasesDbdtLessThan90' AS measuredescription,
  5 AS ord
FROM ##vw_quarterleyreportdetailncr
WHERE pci = 1
  AND iht = 0
  AND (inp = 0)
  AND s2d >= 0
  AND s2d < 721
  AND s2d IS NOT NULL
  AND dbdt > 0
  AND DOP >= '01-Jan-2022'
  AND DOP <= '31-Dec-2022'
GROUP BY ncrhid
--  each site including state
SELECT count(dop) AS measure,
  sum(CASE 
          WHEN dbdt <= 90
            THEN 1
          ELSE 0
          END) dbbdtLessThan90,
  Cast(sum(CASE 
            WHEN dbdt <= 90
              THEN 1
            ELSE 0
            END) AS FLOAT) / cast(count(dop) AS FLOAT) proportioncasesLessThan90,
  0.75 * count(dop) Target75,
  0.75 [Target],
  [State],
  ncrhid,
  'proportioncasesDbdtLessThan90 by State' AS measuredescription,
  6 AS ord
FROM ##vw_quarterleyreportdetailncr
WHERE pci = 1
  AND iht = 0
  AND (inp = 0)
  AND s2d >= 0
  AND s2d < 721
  AND s2d IS NOT NULL
  AND dbdt > 0
  AND DOP >= '01-Jan-2022'
  AND DOP <= '31-Dec-2022'
GROUP BY [State],
      ncrhid
ORDER BY ncrhid
--Data for bottom Box plot 'Diagnosic ECG to PCI mediated reperfusion time in Primary PCI'.
---tabstat dbdt, by(ncrhid) stat(n mean sd min p25 p50 p75 max)
--graph box dbdt if pci==1 & iht==0 & inp==0 & s2d < 721 & dbdt > 0   , over(ncrhid) noout
--Graph two data
SELECT ncrhid,
  [state],
  pci,
  iht,
  inp,
  s2d,
  dbdt,
  PERCENTILE_CONT(0.25) WITHIN
    GROUP (
        ORDER BY dbdt
        ) OVER (PARTITION BY ncrhid) p25,
  PERCENTILE_CONT(0.5) WITHIN
    GROUP (
        ORDER BY dbdt
        ) OVER (PARTITION BY ncrhid) p50,
  PERCENTILE_CONT(0.75) WITHIN
    GROUP (
        ORDER BY dbdt
        ) OVER (PARTITION BY ncrhid) p75
FROM ##vw_quarterleyreportdetailncr
WHERE pci = 1
  AND iht = 0
  AND (inp = 0)
  AND s2d >= 0
  AND s2d < 721
  AND s2d IS NOT NULL
  AND dbdt > 0
  AND DOP >= '01-Jan-2022'
  AND DOP <= '31-Dec-2022'
--and ncrhid = 2
--Numbers,mean,sd,min,p25,p50,p75,max
SELECT ncrhid,
  [state        ],
  count(ncrhid) n,
  avg(dbdt) meandbdt,
  stdev(dbdt) sddbdt,
  min(dbdt) mindbdt,
  max(dbdt) maxdbdt
FROM (
      SELECT ncrhid,
    [state],
    pci,
    iht,
    inp,
    s2d,
    dbdt
  FROM ##vw_quarterleyreportdetailncr
  WHERE pci = 1
    AND iht = 0
    AND (inp = 0)
    AND s2d >= 0
    AND s2d < 721
    AND s2d IS NOT NULL
    AND dbdt > 0
    AND DOP >= '01-Jan-2022'
    AND DOP <= '31-Dec-2022'
      ) dataset
GROUP BY ncrhid,
      [state] --HAVING  ncrhid = 2