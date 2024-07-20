
--Test script for report 7 NCR.  Run this script against  ncr test database t-auea-ncr-sqldb from

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
  SELECT COUNT(DISTINCT CAST(patientid AS VARCHAR(30)) + CAST(hid AS VARCHAR(30))) AS measure,
    'All',
    'Count of Patients' AS measuredescription,
    3 AS ord
  FROM ##vw_quarterleyreportdetailncr

UNION

  SELECT COUNT(DISTINCT CAST(patientid AS VARCHAR(30)) + CAST(hid AS VARCHAR(30))) AS measure,
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

--bar chart

--Banner percentage 4th from the right Peri PCI Stroke
  SELECT SUM(ISNULL(ihstr, 0)) InHospitalStroke,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihstr, 0)) AS FLOAT) / COUNT(dop) * 100 InHospitalStroke,
    'All' AS [State]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'

UNION ALL

  --Peri PCI Stroke
  SELECT SUM(ISNULL(ihstr, 0)) InHospitalStroke,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihstr, 0)) AS FLOAT) / COUNT(dop) * 100 InHospitalStroke,
    [state]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
  GROUP BY [state]

--Banner percentage 3rd from the right MajorBleeding
  SELECT SUM(majorbl) majorbl,
    COUNT(dop) AS Cases,
    CAST(SUM(majorbl) AS FLOAT) / COUNT(dop) * 100 MajorBleeding,
    'All' AS [State]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'

UNION ALL

  SELECT SUM(majorbl) upc30,
    COUNT(dop) AS Cases,
    CAST(SUM(majorbl) AS FLOAT) / COUNT(dop) * 100 MajorBleeding,
    [state]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
  GROUP BY [state]

--Banner percentage 2nd  from the right Mortality
--Banner percentage 2nd  from the right in hospital Mortality
  SELECT a.Mortality_numerator,
    b.Mortality_Denominator,
    cast(a.Mortality_numerator AS FLOAT) / cast(b.Mortality_Denominator AS FLOAT) * 100 Perc,
    b.[State]
  FROM (
      SELECT count(DISTINCT patientid) Mortality_numerator,
      'All' [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND ihmort = 1
      ) a
    INNER JOIN (
      SELECT count(DOP) Mortality_Denominator,
      'All' [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      ) b ON a.[State] = b.[State]

UNION ALL

  SELECT a.Mortality_numerator,
    b.Mortality_Denominator,
    cast(a.Mortality_numerator AS FLOAT) / cast(b.Mortality_Denominator AS FLOAT) * 100 Perc,
    b.[State]
  FROM (
      SELECT count(DISTINCT patientid) Mortality_numerator,
      [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND ihmort = 1
    GROUP BY [STATE]
      ) a
    INNER JOIN (
      SELECT count(DOP) Mortality_Denominator,
      [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
    GROUP BY [STATE]
      ) b ON a.[State] = b.[State]

--Banner percentage far right Mortality with out shock/OHCA
-- Banner percentage far right Mortality with out shock/OHCA numerator
  SELECT a.MortalitywithoutshockOHCA_numerator,
    b.MortalitywithoutshockOHCA_Denominator,
    cast(a.MortalitywithoutshockOHCA_numerator AS FLOAT) / cast(b.MortalitywithoutshockOHCA_Denominator AS FLOAT) * 100 Perc,
    b.[State]
  FROM (
      SELECT count(DISTINCT patientid) MortalitywithoutshockOHCA_numerator,
      'All' [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND (
          shocksohca = 0
      OR shocksohca IS NULL
          )
      AND mort30 = 1
      ) a
    INNER JOIN (
      SELECT count(DOP) MortalitywithoutshockOHCA_Denominator,
      'All' [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND (
          shocksohca = 0
      OR shocksohca IS NULL
          )
      ) b ON a.[State] = b.[State]

UNION ALL

  SELECT a.MortalitywithoutshockOHCA_numerator,
    b.MortalitywithoutshockOHCA_Denominator,
    cast(a.MortalitywithoutshockOHCA_numerator AS FLOAT) / cast(b.MortalitywithoutshockOHCA_Denominator AS FLOAT) * 100 Perc,
    b.[State]
  FROM (
      SELECT count(DISTINCT patientid) MortalitywithoutshockOHCA_numerator,
      [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND (
          shocksohca = 0
      OR shocksohca IS NULL
          )
      AND mort30 = 1
    GROUP BY [STATE]
      ) a
    INNER JOIN (
      SELECT count(DOP) MortalitywithoutshockOHCA_Denominator,
      [State]
    FROM ##vw_quarterleyreportdetailncr
    WHERE Dop >= '2019-12-01'
      AND Dop <= '2021-06-01'
      AND (
          shocksohca = 0
      OR shocksohca IS NULL
          )
    GROUP BY [STATE]
      ) b ON a.[State] = b.[State]

--Numbers for the funnel plot report 3 Major Bleed
  SELECT SUM(majorbl) MajorBleeding#,
    COUNT(dop) AS Cases,
    SUM(CAST(majorbl AS FLOAT)) / COUNT(dop) * 100 MajorBleeding,
    'All' AS [State],
    'All' AS [ncrhid]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'

UNION ALL

  SELECT SUM(majorbl) MajorBleeding#,
    COUNT(dop) AS Cases,
    SUM(CAST(majorbl AS FLOAT)) / COUNT(dop) * 100 MajorBleeding,
    [state],
    CAST([ncrhid] AS VARCHAR(3)) ncrhid
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
  GROUP BY [state],
      [ncrhid]

--Funnel plot numbers for --Peri PCI Stroke
  SELECT SUM(ISNULL(ihstr, 0)) InHospitalStroke,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihstr, 0)) AS FLOAT) / COUNT(dop) * 100 InHospitalStroke,
    'All' AS [State],
    'All' AS [ncrhid]
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'

UNION ALL

  --Peri PCI Stroke
  SELECT SUM(ISNULL(ihstr, 0)) InHospitalStroke,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihstr, 0)) AS FLOAT) / COUNT(dop) * 100 InHospitalStroke,
    [state],
    CAST([ncrhid] AS VARCHAR(3)) ncrhid
  FROM ##vw_quarterleyreportdetailncr
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
  GROUP BY [state],
      [ncrhid]
ORDER BY COUNT(dop)

--Funnel plot in hospital mortality
  SELECT SUM(CASE 
          WHEN ihmort = 1
      AND procone = 1
            THEN 1
          ELSE 0
          END) Mortality#,
    COUNT(dop) AS Cases,
    SUM(CAST(CASE 
            WHEN ihmort = 1
      AND procone = 1
              THEN 1
            ELSE 0
            END AS FLOAT)) / COUNT(dop) * 100 Mortality,
    'All' AS [State],
    'All' AS [ncrhid]
  FROM (
      SELECT ROW_NUMBER() OVER (
          PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid)) ORDER BY dop
          ) AS procone,
      *
    FROM ##vw_quarterleyreportdetailncr
      ) mortdata
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'

UNION ALL

  SELECT SUM(CASE 
          WHEN ihmort = 1
      AND procone = 1
            THEN 1
          ELSE 0
          END) Mortality#,
    COUNT(dop) AS Cases,
    SUM(CAST(CASE 
            WHEN ihmort = 1
      AND procone = 1
              THEN 1
            ELSE 0
            END AS FLOAT)) / COUNT(dop) * 100 Mortality,
    [state],
    CAST([ncrhid] AS VARCHAR(3)) ncrhid
  FROM (
      SELECT ROW_NUMBER() OVER (
          PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid)) ORDER BY dop
          ) AS procone,
      *
    FROM ##vw_quarterleyreportdetailncr
      ) mortdata
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
  GROUP BY [state],
      [ncrhid]
ORDER BY COUNT(dop)

--Funnel plot in hospital mortality without shock/OHCA
  SELECT SUM(ISNULL(CASE 
            WHEN ihmortexcshocksohca = 1
      AND procone = 1
              THEN 1
            ELSE 0
            END, 0)) MortalityExclShockOHCA#,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihmortexcshocksohca, 0)) AS FLOAT) / COUNT(dop) * 100 MortalityExclShockOHCA,
    'All' AS [State],
    'All' AS [ncrhid]
  FROM (
      SELECT ROW_NUMBER() OVER (
          PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid)) ORDER BY dop
          ) AS procone,
      *
    FROM ##vw_quarterleyreportdetailncr
      ) mortdata
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
    AND shocksohca = 0

UNION ALL

  SELECT SUM(ISNULL(CASE 
            WHEN ihmortexcshocksohca = 1
      AND procone = 1
              THEN 1
            ELSE 0
            END, 0)) MortalityExclShockOHCA#,
    COUNT(dop) AS Cases,
    CAST(SUM(ISNULL(ihmortexcshocksohca, 0)) AS FLOAT) / COUNT(dop) * 100 MortalityExclShockOHCA,
    [state],
    CAST([ncrhid] AS VARCHAR(3)) ncrhid
  FROM (
      SELECT ROW_NUMBER() OVER (
          PARTITION BY CAST(ncrhid AS VARCHAR(30)) + RTRIM(LTRIM(patientid)) ORDER BY dop
          ) AS procone,
      *
    FROM ##vw_quarterleyreportdetailncr
      ) mortdata
  WHERE dop >= '2019-12-01'
    AND dop <= '2022-06-01'
    AND shocksohca = 0
  GROUP BY [state],
      [ncrhid]
ORDER BY COUNT(dop)