----Data for banner

--Hospitals
    SELECT COUNT(DISTINCT [HID]) AS measure,
        'All',
        'Count of Hospitals' AS measuredescription,
        1 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL

UNION

    SELECT COUNT(DISTINCT [HID]) AS measure,
        [State],
        'Count of Hospitals' AS measuredescription,
        2 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL
    GROUP BY [State]

UNION

    -- Patients
    SELECT COUNT(DISTINCT CAST(Patientid AS VARCHAR(50)) + CAST(ncrhid AS VARCHAR(50))) AS measure,
        'All',
        'Count of Patients' AS measuredescription,
        3 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL

UNION

    SELECT COUNT(DISTINCT CAST(Patientid AS VARCHAR(50)) + CAST(ncrhid AS VARCHAR(50))) AS measure,
        [State],
        'Count of Patients' AS measuredescription,
        4 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL
    GROUP BY [State]

UNION

    -- PCI
    SELECT COUNT(dop) AS measure,
        'All',
        'Count of Procedures(Pci cases)' AS measuredescription,
        5 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL

UNION

    SELECT COUNT(dop) AS measure,
        [State],
        'Count of Procedures(Pci cases) by State' AS measuredescription,
        6 AS ord
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	inp = 0
        OR inp IS NULL
 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL
    GROUP BY [State]

--Median FMC to reperfusion
SELECT (
 	(
 	SELECT MAX(fmctr)
    FROM (
 	 	SELECT TOP 50 PERCENT
            fmctr
        FROM ##vw_quarterleyreportdetailncr
        WHERE pci = 1
            AND iht = 0
            AND (
 	 	 	inp = 0
            OR inp IS NULL
 	 	 	)
            AND s2d > 0
            AND s2d < 720
            AND s2d IS NOT NULL
            AND fmctr > 0
        ORDER BY fmctr
 	 	) AS BottomHalf
 	) + 
    (
 	SELECT MIN(fmctr)
    FROM (
 	 	SELECT TOP 50 PERCENT
            fmctr
        FROM ##vw_quarterleyreportdetailncr
        WHERE pci = 1
            AND iht = 0
            AND (
 	 	 	inp = 0
            OR inp IS NULL
 	 	 	)
            AND s2d > 0
            AND s2d < 720
            AND s2d IS NOT NULL
            AND fmctr > 0
        ORDER BY fmctr DESC
 	 	) AS TopHalf
 	)
 	 	) / 2 AS Median

--Median ECG to reperfusion
SELECT (
 	(
    SELECT MAX(ecgdb)
    FROM (
        SELECT TOP 50 PERCENT
            ecgdb
        FROM ##vw_quarterleyreportdetailncr
        WHERE pci = 1
            AND iht = 0
            AND (
            inp = 0
            OR inp IS NULL
            )
            AND s2d > 0
            AND s2d < 720
            AND s2d IS NOT NULL
            AND ecgdb > 0
        ORDER BY ecgdb
        ) AS BottomHalf
 	) + 
    (
 	SELECT MIN(ecgdb)
    FROM (
 	 	SELECT TOP 50 PERCENT
            ecgdb
        FROM ##vw_quarterleyreportdetailncr
        WHERE pci = 1
            AND iht = 0
            AND (
 	 	 	 	inp = 0
            OR inp IS NULL
 	 	 	 	 	 	)
            AND s2d > 0
            AND s2d < 720
            AND s2d IS NOT NULL
            AND ecgdb > 0
        ORDER BY ecgdb DESC
 	 	) AS TopHalf
 	)
 	 	) / 2 AS Median
--Data for Top Box 'First Medical Contact to PCI mediated reperfusion time in Primary PCI'.
---tabstat fmctr, by(ncrhid) stat(n mean sd min p25 p50 p75 max)
--graph box fmctr if pci==1 & iht==0 & inp==0 & s2d < 720 & fmctr > 0   , over(ncrhid) noout
--Graph one data
SELECT ncrhid,
    [state],
    pci,
    iht,
    inp,
    s2d,
    fmctr,
    PERCENTILE_CONT(0.25) WITHIN
GROUP (
 	 	ORDER BY fmctr
 	 	) OVER (PARTITION BY ncrhid) p25,
    PERCENTILE_CONT(0.5) WITHIN
GROUP (
 	 	ORDER BY fmctr
 	 	) OVER (PARTITION BY ncrhid) p50,
    PERCENTILE_CONT(0.75) WITHIN
GROUP (
 	 	ORDER BY fmctr
 	 	) OVER (PARTITION BY ncrhid) p75
FROM ##vw_quarterleyreportdetailncr
WHERE pci = 1
    AND iht = 0
    AND (
 	 	inp = 0
    OR inp IS NULL
 	 	)
    AND s2d > 0
    AND s2d < 720
    AND s2d IS NOT NULL
    AND fmctr > 0

--Numbers,mean,sd,min,p25,p50,p75,max
SELECT ncrhid,
    [state],
    COUNT(ncrhid) n,
    AVG(fmctr) meanfmctr,
    stdev(fmctr) sdfmctr,
    MIN(fmctr) minfmctr,
    MAX(fmctr) maxfmctr
FROM (
 	SELECT ncrhid,
        [state],
        pci,
        iht,
        inp,
        s2d,
        fmctr
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	 	inp = 0
        OR inp IS NULL
 	 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL
        AND fmctr > 0
 	) dataset
GROUP BY ncrhid,
 	[state]

--Data for bottom Box plot 'Diagnosic ECG to PCI mediated reperfusion time in Primary PCI'.
---tabstat fmctr, by(ncrhid) stat(n mean sd min p25 p50 p75 max)
--graph box fmctr if pci==1 & iht==0 & inp==0 & s2d < 720 & fmctr > 0   , over(ncrhid) noout
--Graph two data
SELECT ncrhid,
    [state],
    pci,
    iht,
    inp,
    s2d,
    ecgdb,
    PERCENTILE_CONT(0.25) WITHIN
GROUP (
 	 	ORDER BY ecgdb
 	 	) OVER (PARTITION BY ncrhid) p25,
    PERCENTILE_CONT(0.5) WITHIN
GROUP (
 	 	ORDER BY ecgdb
 	 	) OVER (PARTITION BY ncrhid) p50,
    PERCENTILE_CONT(0.75) WITHIN
GROUP (
 	 	ORDER BY ecgdb
 	 	) OVER (PARTITION BY ncrhid) p75
FROM ##vw_quarterleyreportdetailncr
WHERE pci = 1
    AND iht = 0
    AND (
 	 	inp = 0
    OR inp IS NULL
 	 	)
    AND s2d > 0
    AND s2d < 720
    AND s2d IS NOT NULL
    AND ecgdb > 0

--Numbers,mean,sd,min,p25,p50,p75,max
SELECT ncrhid,
    [state],
    COUNT(ncrhid) n,
    AVG(ecgdb) meanecgdb,
    stdev(ecgdb) sdecgdb,
    MIN(ecgdb) minecgdb,
    MAX(ecgdb) maxecgdb
FROM (
 	SELECT ncrhid,
        [state],
        pci,
        iht,
        inp,
        s2d,
        ecgdb
    FROM ##vw_quarterleyreportdetailncr
    WHERE pci = 1
        AND iht = 0
        AND (
 	 	 	inp = 0
        OR inp IS NULL
 	 	 	)
        AND s2d > 0
        AND s2d < 720
        AND s2d IS NOT NULL
        AND ecgdb > 0
 	) dataset
GROUP BY ncrhid,
 	[state]