DECLARE @prmStartDate DATE
DECLARE @prmEndDate DATE
SET @prmStartDate = '2019-Dec-01'
SET @prmEndDate = '2023-Jan-31'
DECLARE @StartDate DATE,
    @EndDate DATE
SET @EndDate = @prmEndDate --Sex female by site
SELECT *
    FROM (
        SELECT
            StudySite,
            SiteSort,
            Format(MeasureValue, 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST([StudySiteId] AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum([Gender - Female]) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS Measurevalue,
                    Sum([Gender - Female]) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    4 AS MeasureSort,
                    'Gender-Female (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate -- and  procdate >= '01-Jan-2020' and procdate <= '31-Mar-2020'
                GROUP BY [StudySiteId],
                    [SiteSortOrder]
            ) AS genderfsite
        UNION ALL
        --Sex female All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum([Gender - Female]) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS Measurevalue,
                    Sum([Gender - Female]) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    4 AS MeasureSort,
                    'Gender-Female (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) AS genderfAll
        UNION ALL
        --Age by Site
        SELECT
            CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
            SiteSortOrder AS SiteSort,
            Format(AVG(CAST(AGE AS DECIMAL)), 'N2', 'en-us') MeasureValue,
            0 AS Numerator,
            0 AS Denominator,
            3 AS MeasureSort,
            'Average Age (%)' AS MeasureDescription
        FROM ##vw_quarterleyreportdetailncr
        WHERE
            procdate >= @StartDate
            AND procdate <= @EndDate
        GROUP BY StudySiteId,
            SiteSortOrder
        UNION ALL
        --Age by All
        SELECT
            'All' AS StudySite,
            500 AS SiteSort,
            Format(AVG(CAST(AGE AS DECIMAL)), 'N2', 'en-us') MeasureValue,
            0 AS Numerator,
            0 AS Denominator,
            3 AS MeasureSort,
            'Average Age (%)' AS MeasureDescription
        FROM ##vw_quarterleyreportdetailncr
        WHERE
            procdate >= @StartDate
            AND procdate <= @EndDate ---Median Age
        UNION ALL
        --Median Age by Site
        SELECT
            CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
            SiteSortOrder AS SiteSort,
            Format(
                PERCENTILE_CONT(0.5) WITHIN GROUP (
                    ORDER BY CAST(AGE AS INT)
                ) OVER (
                    PARTITION BY StudySiteId,
                    SiteSortOrder
                ),
                'N1',
                'en-us'
            ) MeasureValue,
            0 AS Numerator,
            0 AS Denominator,
            38 AS MeasureSort,
            'Age (median)' AS MeasureDescription
        FROM (
                SELECT
                    *
                FROM ##vw_quarterleyreportdetailncr
            ) x
        WHERE
            procdate >= @StartDate
            AND procdate <= @EndDate --GROUP BY [Year], [Quarter],CAST(LOS as int), StudySiteId,SiteSortOrder
        UNION ALL
        --Median Age by All
        SELECT
            'All' AS StudySite,
            500 AS SiteSort,
            Format(
                PERCENTILE_CONT(0.5) WITHIN GROUP (
                    ORDER BY isnull(CAST(AGE AS INT), 0)
                ) OVER (PARTITION BY Allrecords),
                'N1',
                'en-us'
            ) MeasureValue,
            0 AS Numerator,
            0 AS Denominator,
            38 AS MeasureSort,
            'Age (median)' AS MeasureDescription
        FROM (
                SELECT
                    *,
                    1 AS Allrecords
                FROM ##vw_quarterleyreportdetailncr
            ) x
        WHERE
            procdate >= @StartDate
            AND procdate <= @EndDate
        UNION ALL
        -- previouspci ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(previouspci) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(previouspci) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    40 AS MeasureSort,
                    ' previouspci (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) previouspcibysite
        UNION ALL
        -- previouspci ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(previouspci) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(previouspci) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    40 AS MeasureSort,
                    ' previouspci (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) previouspci
        UNION ALL
        -- BMIUnderweight ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIUnderweight) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIUnderweight) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    40 AS MeasureSort,
                    ' BMIUnderweight (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) BMIUnderweightbysite
        UNION ALL
        -- BMIUnderweight ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIUnderweight) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIUnderweight) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    40 AS MeasureSort,
                    ' BMIUnderweight (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) BMIUnderweight
        UNION ALL
        -- BMINormal ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMINormal) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMINormal) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    41 AS MeasureSort,
                    ' BMINormal (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) BMINormalbysite
        UNION ALL
        -- BMINormal ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMINormal) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMINormal) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    41 AS MeasureSort,
                    ' BMINormal (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) BMINormal
        UNION ALL
        -- BMIOverweight ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIOverweight) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIOverweight) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    42 AS MeasureSort,
                    ' BMIOverweight (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) BMIOverweightbysite
        UNION ALL
        -- BMIOverweight ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIOverweight) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIOverweight) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    42 AS MeasureSort,
                    ' BMIOverweight (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) BMIOverweight
        UNION ALL
        -- BMIObese ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIObese) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIObese) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    43 AS MeasureSort,
                    ' BMIObese (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) BMIObesebysite
        UNION ALL
        -- BMIObese ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(BMIObese) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(BMIObese) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    43 AS MeasureSort,
                    ' BMIObese (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) BMIObese
        UNION ALL
        -- EGFRGreaterThan60 ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRGreaterThan60) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRGreaterThan60) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    44 AS MeasureSort,
                    ' EGFRGreaterThan60 (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EGFRGreaterThan60bysite
        UNION ALL
        -- EGFRGreaterThan60 ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRGreaterThan60) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRGreaterThan60) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    43 AS MeasureSort,
                    ' EGFRGreaterThan60 (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EGFRGreaterThan60
        UNION ALL
        -- EGFRBetween31And60 ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRBetween31And60) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRBetween31And60) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    44 AS MeasureSort,
                    ' EGFRBetween31And60 (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EGFRBetween31And60bysite
        UNION ALL
        -- EGFRBetween31And60 ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRBetween31And60) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRBetween31And60) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    44 AS MeasureSort,
                    ' EGFRBetween31And60 (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EGFRBetween31And60
        UNION ALL
        -- EGFRLessThanThirty ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRLessThanThirty) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRLessThanThirty) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    45 AS MeasureSort,
                    ' EGFRLessThanThirty (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EGFRLessThanThirtybysite
        UNION ALL
        -- EGFRLessThanThirty ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EGFRLessThanThirty) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EGFRLessThanThirty) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    45 AS MeasureSort,
                    ' EGFRLessThanThirty (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EGFRLessThanThirty
        UNION ALL
        -- EFNormal ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFNormal) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFNormal) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    47 AS MeasureSort,
                    ' EFNormal (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EFNormalbysite
        UNION ALL
        -- EFNormal ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFNormal) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFNormal) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    47 AS MeasureSort,
                    ' EFNormal (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EFNormal
        UNION ALL
        -- EFMild ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFMild) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFMild) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    48 AS MeasureSort,
                    ' EFMild (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EFMildbysite
        UNION ALL
        -- EFMild ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFMild) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFMild) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    48 AS MeasureSort,
                    ' EFMild (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EFMild
        UNION ALL
        -- EFModerate ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFModerate) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFModerate) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    49 AS MeasureSort,
                    ' EFModerate (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EFModeratebysite
        UNION ALL
        -- EFModerate ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFModerate) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFModerate) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    49 AS MeasureSort,
                    ' EFModerate (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EFModerate
        UNION ALL
        -- EFSevere ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFSevere) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFSevere) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    50 AS MeasureSort,
                    ' EFSevere (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) EFSeverebysite
        UNION ALL
        -- EFSevere ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(EFSevere) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(EFSevere) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    50 AS MeasureSort,
                    ' EFSevere (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) EFSevere
        UNION ALL
        -- cardiogenicshock ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(cardiogenicshock) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(cardiogenicshock) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    51 AS MeasureSort,
                    ' cardiogenicshock (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) cardiogenicshockbysite
        UNION ALL
        -- cardiogenicshock ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(cardiogenicshock) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(cardiogenicshock) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    51 AS MeasureSort,
                    ' cardiogenicshock (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) cardiogenicshock
        UNION ALL
        -- outofhospitalcardiacarrest ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(outofhospitalcardiacarrest) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(outofhospitalcardiacarrest) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    52 AS MeasureSort,
                    ' outofhospitalcardiacarrest (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) outofhospitalcardiacarrestbysite
        UNION ALL
        -- outofhospitalcardiacarrest ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(outofhospitalcardiacarrest) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(outofhospitalcardiacarrest) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    52 AS MeasureSort,
                    ' outofhospitalcardiacarrest (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) outofhospitalcardiacarrest
        UNION ALL
        -- Preproceduralintubation ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(Preproceduralintubation) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(Preproceduralintubation) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    53 AS MeasureSort,
                    ' Preproceduralintubation (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) Preproceduralintubationbysite
        UNION ALL
        -- Preproceduralintubation ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(Preproceduralintubation) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(Preproceduralintubation) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    53 AS MeasureSort,
                    ' Preproceduralintubation (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) Preproceduralintubation
        UNION ALL
        -- ProceduralIntubationrequired ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(ProceduralIntubationrequired) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(ProceduralIntubationrequired) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    54 AS MeasureSort,
                    ' ProceduralIntubationrequired (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) ProceduralIntubationrequiredbysite
        UNION ALL
        -- ProceduralIntubationrequired ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(ProceduralIntubationrequired) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(ProceduralIntubationrequired) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    54 AS MeasureSort,
                    ' ProceduralIntubationrequired (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) ProceduralIntubationrequired
        UNION ALL
        -- db ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(db) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(db) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    55 AS MeasureSort,
                    ' Diabetes (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) dbbysite
        UNION ALL
        -- db ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(db) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(db) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    55 AS MeasureSort,
                    ' Diabetes (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) db
        UNION ALL
        -- pcab ‐ all cases by Site
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    CAST(StudySiteId AS VARCHAR(40)) AS StudySite,
                    SiteSortOrder AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(pcab) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(pcab) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    56 AS MeasureSort,
                    ' Previous CABG (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
                GROUP BY StudySiteId,
                    SiteSortOrder
            ) pcabbysite
        UNION ALL
        -- pcab ‐ all cases All
        SELECT
            StudySite,
            SiteSort,
            Format(isnull(MeasureValue, 0), 'N1', 'en-us') AS MeasureValue,
            Numerator,
            Denominator,
            MeasureSort,
            MeasureDescription
        FROM (
                SELECT
                    'All' AS StudySite,
                    500 AS SiteSort,
                    CASE
                        WHEN SUM(CAST(CompletedCase AS DECIMAL)) > 0 THEN (
                            Sum(pcab) / SUM(CAST(CompletedCase AS DECIMAL)) * 100
                        )
                        ELSE 0
                    END AS MeasureValue,
                    Sum(pcab) AS Numerator,
                    SUM(CAST(CompletedCase AS DECIMAL)) AS Denominator,
                    56 AS MeasureSort,
                    ' Previous CABG (%)' AS MeasureDescription
                FROM ##vw_quarterleyreportdetailncr
                WHERE
                    procdate >= @StartDate
                    AND procdate <= @EndDate
            ) pcab
    ) Results