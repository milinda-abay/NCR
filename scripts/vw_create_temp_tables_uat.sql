/*
 Create a temp ##vw_quarterleyreportdetailncrboxplot table in the DB
*/
SELECT *
INTO ##vw_quarterleyreportdetailncrboxplot
FROM (
  SELECT
    hname,
    pcode,
    hid,
    ncrhid,
    patientid,
    sex,
    inds,
    CONVERT(DATE, doa, 103) AS doa,
    toa,
    age,
    htm,
    wkg,
    bmi,
    CONVERT(DATE, dop, 103) AS dop,
    [top],
    po,
    ncrpo,
    db,
    dbm,
    pvd1,
    pvd2,
    pcabg,
    CAST(dpcabg AS DATE) dpcabg,
    ppci,
    CONVERT(DATE, dppci, 103) AS dppci,
    pcr,
    npcr,
    eftp,
    CONVERT(DATE, def, 103) AS def,
    eft,
    ef,
    efes,
    egfri,
    egfr,
    shock,
    oca,
    pint,
    acs,
    CONVERT(DATE, dso, 103) AS dso,
    tso,
    ntso,
    acst,
    iht,
    phn,
    CONVERT(DATE, dbd, 103) AS dbd,
    tbd,
    sor,
    dbdt,
    spr,
    CONVERT(DATE, dfmc, 103) AS dfmc,
    tfmc,
    sofmc,
    fmctr,
    fmctd,
    CONVERT(DATE, decgd, 103) AS decgd,
    tecgd,
    ecgdb,
    inp,
    pci,
    pel,
    pintr,
    vsr,
    lr1_lesion,
    lr1_isr,
    lr1_isrst,
    lr1_lst,
    lr1_sit,
    lr2_lesion,
    lr2_isr,
    lr2_isrst,
    lr2_lst,
    lr2_sit,
    lr3_lesion,
    lr3_isr,
    lr3_isrst,
    lr3_lst,
    lr3_sit,
    lr4_lesion,
    lr4_isr,
    lr4_isrst,
    lr4_lst,
    lr4_sit,
    lr5_lesion,
    lr5_isr,
    lr5_isrst,
    lr5_lst,
    lr5_sit,
    tak,
    dap,
    tft,
    ihmi,
    ihpci,
    ihpcip,
    ihtvr,
    ihtlr,
    ihcab,
    ihpcab,
    ihtvcab,
    ihstr,
    ihstrt,
    ihbl,
    ihblsite,
    ihst,
    dis,
    CONVERT(DATE, dod, 103) AS dod,
    los,
    crehab,
    mortc,
    dasp,
    doap,
    dstp,
    doll,
    CONVERT(DATE, dfu30, 103) AS dfu30,
    stat30,
    CONVERT(DATE, dmort30, 103) AS dmort30,
    mort30r,
    mi30,
    st30,
    nstr,
    nstrt,
    crh30,
    CONVERT(DATE, rhdte, 103) AS rhdte,
    pc30,
    pci30,
    tvr30,
    tlr30,
    cab30,
    tvcab30,
    crh30_2,
    CONVERT(DATE, rhdte_2, 103) AS rhdte_2,
    pc30_2,
    pci30_2,
    tvr30_2,
    tlr30_2,
    cab30_2,
    tvcab30_2,
    crh30_3,
    CONVERT(DATE, rhdte_3, 103) AS rhdte_3,
    pc30_3,
    pci30_3,
    tvr30_3,
    tlr30_3,
    cab30_3,
    tvcab30_3,
    crh30_4,
    CONVERT(DATE, rhdte_4, 103) AS rhdte_4,
    pc30_4,
    pci30_4,
    tvr30_4,
    tlr30_4,
    cab30_4,
    tvcab30_4,
    crh30_5,
    CONVERT(DATE, rhdte_5, 103) AS rhdte_5,
    pc30_5,
    pci30_5,
    tvr30_5,
    tlr30_5,
    cab30_5,
    tvcab30_5,
    crh30_6,
    CONVERT(DATE, rhdte_6, 103) AS rhdte_6,
    pc30_6,
    pci30_6,
    tvr30_6,
    tlr30_6,
    cab30_6,
    tvcab30_6,
    CASE
      WHEN sor <= 720
      AND iht = 0
      AND (
      inp = 0
      OR inp IS NULL
      )
      AND pci = 1 THEN 1
  END AS primarypci
  FROM
    fact.vw_Data_Extract_Report
    ) AS x
;
/*
   Create a temp ##vw_quarterleyreportdetailncrtable table in the DB
*/

SELECT *
INTO ##vw_quarterleyreportdetailncrtable
FROM (
  SELECT hname,
    pcode,
    hid,
    ncrhid,
    patientid,
    sex,
    inds,
    doa,
    toa,
    age,
    htm,
    wkg,
    bmi,
    dop,
    [top],
    po,
    ncrpo,
    db,
    dbm,
    pvd1,
    pvd2,
    pcabg,
    dpcabg,
    ppci,
    dppci,
    pcr,
    npcr,
    eftp,
    def,
    eft,
    ef,
    efes,
    egfri,
    egfr,
    shock,
    oca,
    pint,
    acs,
    dso,
    tso,
    ntso,
    acst,
    iht,
    phn,
    dbd,
    tbd,
    sor,
    dbdt,
    spr,
    dfmc,
    tfmc,
    sofmc,
    fmctr,
    fmctd,
    decgd,
    tecgd,
    ecgdb,
    inp,
    pci,
    pel,
    pintr,
    vsr,
    lr1_lesion,
    lr1_isr,
    lr1_isrst,
    lr1_lst,
    lr1_sit,
    lr2_lesion,
    lr2_isr,
    lr2_isrst,
    lr2_lst,
    lr2_sit,
    lr3_lesion,
    lr3_isr,
    lr3_isrst,
    lr3_lst,
    lr3_sit,
    lr4_lesion,
    lr4_isr,
    lr4_isrst,
    lr4_lst,
    lr4_sit,
    lr5_lesion,
    lr5_isr,
    lr5_isrst,
    lr5_lst,
    lr5_sit,
    tak,
    dap,
    tft,
    ihmi,
    ihpci,
    ihpcip,
    ihtvr,
    ihtlr,
    ihcab,
    ihpcab,
    ihtvcab,
    ihstr,
    ihstrt,
    ihbl,
    ihblsite,
    ihst,
    dis,
    dod,
    crehab,
    mortc,
    dasp,
    doap,
    dstp,
    doll,
    dfu30,
    stat30,
    dmort30,
    mort30r,
    mi30,
    st30,
    nstr,
    nstrt,
    crh30,
    rhdte,
    pc30,
    pci30,
    tvr30,
    tlr30,
    cab30,
    tvcab30,
    crh30_2,
    rhdte_2,
    pc30_2,
    pci30_2,
    tvr30_2,
    tlr30_2,
    cab30_2,
    tvcab30_2,
    crh30_3,
    rhdte_3,
    pc30_3,
    pci30_3,
    tvr30_3,
    tlr30_3,
    cab30_3,
    tvcab30_3,
    crh30_4,
    rhdte_4,
    pc30_4,
    pci30_4,
    tvr30_4,
    tlr30_4,
    cab30_4,
    tvcab30_4,
    crh30_5,
    rhdte_5,
    pc30_5,
    pci30_5,
    tvr30_5,
    tlr30_5,
    cab30_5,
    tvcab30_5,
    crh30_6,
    rhdte_6,
    pc30_6,
    pci30_6,
    tvr30_6,
    tlr30_6,
    cab30_6,
    tvcab30_6,
    primarypci,
    los,
    dbdtgp,
    lltgp,
    daptgp,
    creadgp,
    lesionlocgp,
    lesionlocgptxt,
    LVEF,
    EGFRGreaterThan60,
    EGFRBetween31And60,
    EGFRLessThanThirty,
    EFNormal,
    EFMild,
    EFModerate,
    EFSevere,
    cardiogenicshock,
    outofhospitalcardiacarrest,
    Preproceduralintubation,
    ProceduralIntubationrequired,
    bmiscore,
    CASE
      WHEN bmiscore < 18.5 THEN 1
      ELSE 0
    END AS BMIUnderweight,
    CASE
      WHEN bmiscore >= 18.5
      AND bmiscore <= 24.9 THEN 1
      ELSE 0
    END AS BMINormal,
    CASE
      WHEN bmiscore >= 25
      AND bmiscore <= 29.9 THEN 1
      ELSE 0
    END AS BMIOverweight,
    CASE
      WHEN bmiscore >= 30 THEN 1
      ELSE 0
      END AS BMIObese
  FROM (
    SELECT hname,
      pcode,
      hid,
      ncrhid,
      patientid,
      sex,
      inds,
      doa,
      toa,
      age,
      htm,
      wkg,
      bmi,
      dop,
      [top],
      po,
      ncrpo,
      db,
      dbm,
      pvd1,
      pvd2,
      pcabg,
      dpcabg,
      ppci,
      dppci,
      pcr,
      npcr,
      eftp,
      def,
      eft,
      ef,
      efes,
      egfri,
      egfr,
      shock,
      oca,
      pint,
      acs,
      dso,
      tso,
      ntso,
      acst,
      iht,
      phn,
      dbd,
      tbd,
      sor,
      dbdt,
      spr,
      dfmc,
      tfmc,
      sofmc,
      fmctr,
      fmctd,
      decgd,
      tecgd,
      ecgdb,
      inp,
      pci,
      pel,
      pintr,
      vsr,
      lr1_lesion,
      lr1_isr,
      lr1_isrst,
      lr1_lst,
      lr1_sit,
      lr2_lesion,
      lr2_isr,
      lr2_isrst,
      lr2_lst,
      lr2_sit,
      lr3_lesion,
      lr3_isr,
      lr3_isrst,
      lr3_lst,
      lr3_sit,
      lr4_lesion,
      lr4_isr,
      lr4_isrst,
      lr4_lst,
      lr4_sit,
      lr5_lesion,
      lr5_isr,
      lr5_isrst,
      lr5_lst,
      lr5_sit,
      tak,
      dap,
      tft,
      ihmi,
      ihpci,
      ihpcip,
      ihtvr,
      ihtlr,
      ihcab,
      ihpcab,
      ihtvcab,
      ihstr,
      ihstrt,
      ihbl,
      ihblsite,
      ihst,
      dis,
      dod,
      crehab,
      mortc,
      dasp,
      doap,
      dstp,
      doll,
      dfu30,
      stat30,
      dmort30,
      mort30r,
      mi30,
      st30,
      nstr,
      nstrt,
      crh30,
      rhdte,
      pc30,
      pci30,
      tvr30,
      tlr30,
      cab30,
      tvcab30,
      crh30_2,
      rhdte_2,
      pc30_2,
      pci30_2,
      tvr30_2,
      tlr30_2,
      cab30_2,
      tvcab30_2,
      crh30_3,
      rhdte_3,
      pc30_3,
      pci30_3,
      tvr30_3,
      tlr30_3,
      cab30_3,
      tvcab30_3,
      crh30_4,
      rhdte_4,
      pc30_4,
      pci30_4,
      tvr30_4,
      tlr30_4,
      cab30_4,
      tvcab30_4,
      crh30_5,
      rhdte_5,
      pc30_5,
      pci30_5,
      tvr30_5,
      tlr30_5,
      cab30_5,
      tvcab30_5,
      crh30_6,
      rhdte_6,
      pc30_6,
      pci30_6,
      tvr30_6,
      tlr30_6,
      cab30_6,
      tvcab30_6,
      primarypci,
      los,
      CASE 
        WHEN dbdt <= 90
          THEN 1
        ELSE 0
        END AS dbdtgp,
      CASE 
        WHEN (dstp = 1 OR doll = 1)
          THEN 1
        WHEN (dstp > 1 OR doll > 1)
          THEN 2
        ELSE 0
        END AS lltgp,
      CASE 
        WHEN dasp = 1 AND doap = 1
          THEN 1
        WHEN dasp > 1 OR doap > 1
          THEN 2
        ELSE 0
        END AS daptgp,
      CASE 
        WHEN crh30 = 1 AND pc30 = 1
          THEN 1
        WHEN crh30 = - 1 OR pc30 = - 1
          THEN 2
        ELSE 0
        END AS creadgp,
      CASE 
        WHEN (lr1_lesion = 1 OR lr1_lesion = 2)
          THEN 1
        WHEN lr1_lesion = 3 OR lr1_lesion = 5
          THEN 2
        WHEN lr1_lesion = 4
          THEN 3
        WHEN lr1_lesion = 6
          THEN 4
        WHEN lr1_lesion = 7 OR lr1_lesion = 8 OR lr1_lesion = 9
          THEN 5
        ELSE 0
        END AS lesionlocgp,
      CASE 
        WHEN lr1_lesion = 1 OR lr1_lesion = 2
          THEN 'LAD'
        WHEN lr1_lesion = 3 OR lr1_lesion = 5
          THEN 'LCx'
        WHEN lr1_lesion = 4
          THEN 'Leftmain'
        WHEN lr1_lesion = 6
          THEN 'RCA'
        WHEN lr1_lesion = 7 OR lr1_lesion = 8 OR lr1_lesion = 9
          THEN 'Graft'
        ELSE 'Un-Defined'
        END AS lesionlocgptxt,
      CASE 
        WHEN (efes IS NULL AND ef >= 50)
          THEN 1
        WHEN (efes IS NULL AND (ef >= 44 AND ef <= 49))
          THEN 2
        WHEN (efes IS NULL AND (ef >= 35 AND ef <= 44))
          THEN 3
        WHEN (efes IS NULL AND (ef < 35))
          THEN 4
        END AS LVEF,
      CASE 
        WHEN egfr > 60
          THEN 1
        ELSE 0
        END AS EGFRGreaterThan60,
      CASE 
        WHEN egfr >= 31 AND egfr <= 60
          THEN 1
        ELSE 0
        END AS EGFRBetween31And60,
      CASE 
        WHEN egfr <= 30
          THEN 1
        ELSE 0
        END AS EGFRLessThanThirty,
      CASE 
        WHEN (ef >= 50 OR efes = 1)
          THEN 1
        ELSE 0
        END AS EFNormal,
      CASE 
        WHEN ((ef >= 45 AND ef <= 49) OR efes = 2)
          THEN 1
        ELSE 0
        END AS EFMild,
      CASE 
        WHEN ((ef >= 35 AND ef <= 44) OR efes = 3)
          THEN 1
        ELSE 0
        END AS EFModerate,
      CASE 
        WHEN ((ef < 35) OR efes = 4)
          THEN 1
        ELSE 0
        END AS EFSevere,
      CASE 
        WHEN shock = 1
          THEN 1
        ELSE 0
        END AS cardiogenicshock,
      CASE 
        WHEN oca = 1
          THEN 1
        ELSE 0
        END AS outofhospitalcardiacarrest,
      CASE 
        WHEN pint = 1
          THEN 1
        ELSE 0
        END AS Preproceduralintubation,
      CASE 
        WHEN pintr = 1
          THEN 1
        ELSE 0
        END AS ProceduralIntubationrequired,
      CAST(wkg AS DECIMAL) / (CAST(htm AS DECIMAL) * CAST(htm AS DECIMAL)) * 10000 AS bmiscore
    FROM ##vw_quarterleyreportdetailncrboxplot
      ) AS x
  ) AS y
/*
   Create a temp ##vw_quarterleyreportdetailncr table in the DB
*/
;
SELECT *
INTO ##vw_quarterleyreportdetailncr
FROM (
  SELECT /* Box plot measures */ hname,
    publicorprivate PUBPRI,
    CASE 
      WHEN publicorprivate = 1
        THEN 'Public'
      WHEN publicorprivate = 2
        THEN 'Private'
      END PUBPRIlabel,
    pcode,
    sex,
    inds,
    doa,
    toa,
    htm,
    wkg,
    [top],
    po,
    ncrpo,
    dbm,
    pvd1,
    pvd2,
    pcabg,
    dpcabg,
    ppci,
    dppci,
    pcr,
    npcr,
    eftp,
    def,
    eft,
    ef,
    efes,
    egfri,
    egfr,
    acs,
    dso,
    tso,
    ntso,
    acst,
    iht,
    phn,
    dbd,
    tbd,
    sor,
    dbdt,
    spr,
    dfmc,
    tfmc,
    sofmc,
    fmctr,
    fmctd,
    decgd,
    tecgd,
    ecgdb,
    inp,
    pci,
    pel,
    vsr,
    lr1_isr,
    lr1_isrst,
    lr1_lst,
    lr1_sit,
    lr2_lesion,
    lr2_isr,
    lr2_isrst,
    lr2_lst,
    lr2_sit,
    lr3_lesion,
    lr3_isr,
    lr3_isrst,
    lr3_lst,
    lr3_sit,
    lr4_lesion,
    lr4_isr,
    lr4_isrst,
    lr4_lst,
    lr4_sit,
    lr5_lesion,
    lr5_isr,
    lr5_isrst,
    lr5_lst,
    lr5_sit,
    tak,
    dap,
    tft,
    ihpci,
    ihpcip,
    ihtvr,
    ihtlr,
    ihcab,
    ihpcab,
    ihtvcab,
    ihstrt,
    ihbl,
    ihblsite,
    ihst,
    mortc,
    dfu30,
    stat30,
    mort30r,
    mi30,
    st30,
    nstr,
    nstrt,
    rhdte,
    pci30,
    tvr30,
    tlr30,
    cab30,
    tvcab30,
    crh30_2,
    rhdte_2,
    pc30_2,
    pci30_2,
    tvr30_2,
    tlr30_2,
    cab30_2,
    tvcab30_2,
    crh30_3,
    rhdte_3,
    pc30_3,
    pci30_3,
    tvr30_3,
    tlr30_3,
    cab30_3,
    tvcab30_3,
    crh30_4,
    rhdte_4,
    pc30_4,
    pci30_4,
    tvr30_4,
    tlr30_4,
    cab30_4,
    tvcab30_4,
    crh30_5,
    rhdte_5,
    pc30_5,
    pci30_5,
    tvr30_5,
    tlr30_5,
    cab30_5,
    tvcab30_5,
    crh30_6,
    rhdte_6,
    pc30_6,
    pci30_6,
    tvr30_6,
    tlr30_6,
    cab30_6,
    tvcab30_6,
    primarypci,
    dbdtgp,
    lltgp,
    daptgp,
    creadgp,
    lesionlocgp,
    lesionlocgptxt,
    unpltvr,
    st,
    DATEDIFF(mi, ISNULL(DATEADD(HOUR, DATEPART(HOUR, tso), DATEADD(MINUTE, DATEPART(MINUTE, tso), DATEADD(SECOND, DATEPART(SECOND, tso), CONVERT(DATETIME, dso, 23)))), DATEADD(HOUR, DATEPART(HOUR, toa), DATEADD(MINUTE, DATEPART(MINUTE, toa), DATEADD(SECOND, DATEPART(SECOND, toa), CONVERT(DATETIME, doa, 23))))), DATEADD(HOUR, DATEPART(HOUR, toa), DATEADD(MINUTE, DATEPART(MINUTE, toa), DATEADD(SECOND, DATEPART(SECOND, toa), CONVERT(DATETIME, doa, 23))))) s2d,
    patientid,
    stateid,
    CASE 
      WHEN stateid = 1
        THEN 'ACT'
      WHEN stateid = 2
        THEN 'NSW'
      WHEN stateid = 3
        THEN 'VIC'
      WHEN stateid = 4
        THEN 'QLD'
      WHEN stateid = 5
        THEN 'SA'
      WHEN stateid = 6
        THEN 'WA'
      WHEN stateid = 7
        THEN 'TAS'
      WHEN stateid = 8
        THEN 'NT'
      END AS [state],
    0 AS SiteSortOrder,
    db,
    ncrhid,
    1 AS CompletedCase,
    ncrhid AS StudySiteId,
    0 AS IncompleteCase,
    age AS AGE,
    CASE 
      WHEN sex = 2
        THEN 1
      ELSE 0
      END AS [Gender - Female],
    CASE 
      WHEN sex = 1
        THEN 1
      ELSE 0
      END AS [Gender - Male],
    bmiscore,
    CASE 
      WHEN pel = 3
        THEN 1
      ELSE 0
      END AS femoral,
    CASE 
      WHEN pel = 2
        THEN 1
      ELSE 0
      END AS radial,
    dop AS procdate,
    dop,
    ncrhid AS HID,
    empcibase AS empci,
    emcabbase AS emcab,
    ihstr,
    CASE 
      WHEN (lr1_lst = 0 OR lr1_lst IS NULL)
        THEN 0
      WHEN (lr1_lst = 1 OR lr1_lst IS NULL) AND (lr2_lst = 1 OR lr2_lst IS NULL) AND (lr3_lst = 1 OR lr3_lst IS NULL) AND (lr4_lst = 1 OR lr4_lst IS NULL) AND (lr5_lst = 1 OR lr5_lst IS NULL)
        THEN 1
      ELSE 0
      END AS alllesionsuccess,
    CASE 
      WHEN dstp = 1 OR doll = 1
        THEN 1
      ELSE 0
      END dischargedonlipidlowering,
    CASE 
      WHEN dasp = 1 AND doap = 1
        THEN 1
      ELSE 0
      END dischargeondapt,
    CASE 
      WHEN (pcab = 0 AND (lr1_lesion = 5 OR lr2_lesion = 5 OR lr3_lesion = 5 OR lr4_lesion = 5 OR lr5_lesion = 5))
        THEN 1
      ELSE 0
      END AS ulmain,
    CASE 
      WHEN (lr1_sit = 2 OR lr1_sit = 3)
        THEN 1
      WHEN (lr2_sit = 2 OR lr2_sit = 3)
        THEN 1
      WHEN (lr3_sit = 2 OR lr3_sit = 3)
        THEN 1
      WHEN (lr4_sit = 2 OR lr4_sit = 3)
        THEN 1
      WHEN (lr5_sit = 2 OR lr5_sit = 3)
        THEN 1
      END AS anydes,
    los,
    CASE 
      WHEN (dis = 6 OR ihmi = 1 OR unpltvr = 1 OR ihstr = 1 OR majorbl = 1 OR (ihst = 1 OR ihst = 2))
        THEN 1
      ELSE 0
      END AS sigcomplication,
    CASE 
      WHEN (lr1_lesion = 1 OR lr1_lesion = 2)
        THEN 1
      ELSE 0
      END LAD,
    CASE 
      WHEN (lr1_lesion = 3 OR lr1_lesion = 5)
        THEN 1
      ELSE 0
      END LCx,
    CASE 
      WHEN (lr1_lesion = 4)
        THEN 1
      ELSE 0
      END LeftMain,
    CASE 
      WHEN (lr1_lesion = 6)
        THEN 1
      ELSE 0
      END RCA,
    CASE 
      WHEN (lr1_lesion = 7 OR lr1_lesion = 8 OR lr1_lesion = 9)
        THEN 1
      ELSE 0
      END Graft,
    CASE 
      WHEN ((lr1_isr = 1 AND lr1_isrst = 0) OR (lr2_isr = 1 AND lr2_isrst = 0))
        THEN 1
      ELSE 0
      END AS anyISR,
    shock,
    sickohca,
    dis,
    mortdays,
    oca,
    pint,
    pintr,
    dod,
    dmort30,
    doll,
    dstp,
    dasp,
    doap,
    crehab,
    ihmi,
    lr1_lesion,
    crh30,
    pc30,
    CASE 
      WHEN crh30 = 1 OR crh30_2 = 1 OR crh30_3 = 1 OR crh30_4 = 1 OR crh30_5 = 1 OR crh30_6 = 1
        THEN 1
      ELSE 0
      END crh30any,
    CASE 
      WHEN pc30 = 1 OR pc30_2 = 1 OR pc30_3 = 1 OR pc30_4 = 1 OR pc30_5 = 1 OR pc30_6 = 1
        THEN 1
      ELSE 0
      END pc30any,
    CASE 
      WHEN pc30 = 0 OR pc30_2 = 0 OR pc30_3 = 0 OR pc30_4 = 0 OR pc30_5 = 0 OR pc30_6 = 0
        THEN 1
      ELSE 0
      END upc30any,
    CASE 
      WHEN (dis = 6)
        THEN 1
      ELSE 0
      END AS ihmort,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (dis = 6)
        THEN 1
      ELSE 0
      END AS ihmortexcshocksohca,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (mortdays < 31) OR dis = 6
        THEN 1
      ELSE 0
      END AS mort30excshocksohca,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (mort30 = 1 OR ihmi = 1 OR mi30 = 1 OR ihstr = 1 OR str30 = 1 OR ihst = 1 OR ihst = 2 OR st30 = 1 OR st30 = 2 OR unprevasc30new = 1)
        THEN 1
      ELSE 0
      END AS maccenewexcshocksohca,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (dis = 6 OR ihmi = 1 OR ihstr = 1 OR ihst = 1 OR ihst = 2 OR unprevascnew = 1)
        THEN 1
      ELSE 0
      END AS Ihmaccenewexcshocksohca,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (mort30 = 1 OR ihmi = 1 OR mi30 = 1 OR ihst = 1 OR ihst = 2 OR st30 = 1 OR st30 = 2 OR unprevasc30new = 1)
        THEN 1
      ELSE 0
      END AS macenewexcshocksohca,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 0
      WHEN (dis = 6 OR ihmi = 1 OR ihst = 1 OR ihst = 2 OR unprevascnew = 1)
        THEN 1
      ELSE 0
      END AS ihmacenewexcshocksohca,
    CASE 
      WHEN (ihbl = 3 OR ihbl = 4 OR ihbl = 5 OR ihbl = 7 OR ihbl = 8)
        THEN 1
      ELSE 0
      END AS majorbl,
    CASE 
      WHEN (shock = 1 OR sickohca = 1)
        THEN 1
      ELSE 0
      END AS shocksohca,
    CASE 
      WHEN (mortdays < 31) OR (dis = 6)
        THEN 1
      ELSE 0
      END mort30,
    CASE 
      WHEN (mort30 = 1 OR ihmi = 1 OR mi30 = 1 OR ihstr = 1 OR str30 = 1 OR ihst = 1 OR ihst = 2 OR st30 = 1 OR st30 = 2 OR unprevasc30new = 1)
        THEN 1
      ELSE 0
      END maccenew,
    CASE 
      WHEN (mort30 = 1 OR ihmi = 1 OR mi30 = 1 OR ihst = 1 OR ihst = 2 OR st30 = 1 OR st30 = 2 OR unprevasc30new = 1)
        THEN 1
      ELSE 0
      END macenew,
    CASE 
      WHEN (dis = 6 OR ihmi = 1 OR ihstr = 1 OR ihst = 1 OR ihst = 2 OR unprevascnew = 1)
        THEN 1
      ELSE 0
      END ihmaccenew,
    CASE 
      WHEN (dis = 6 OR ihmi = 1 OR ihst = 1 OR ihst = 2 OR unprevascnew = 1)
        THEN 1
      ELSE 0
      END ihmacenew,
    CASE 
      WHEN (ihmi = 1 OR mi30 = 1)
        THEN 1
      ELSE 0
      END mi30_new,
    CASE 
      WHEN (ihstr = 1 OR str30 = 1)
        THEN 1
      ELSE 0
      END stroke30,
    CASE 
      WHEN (unprevascnew = 1 OR empci30 = 1 OR emcab30 = 1)
        THEN 1
      ELSE 0
      END unprevasc30new,
    CASE 
      WHEN (st = 1 OR st30 = 1 OR st30 = 2)
        THEN 1
      ELSE 0
      END st30_new,
    v2.empci30 AS unpci30,
    v2.emcab30 AS uncab30,
    CASE 
      WHEN (mortdays < 31 AND (acs = 1 AND acst = 3))
        THEN 1
      ELSE 0
      END mort30stemi,
    CASE 
      WHEN ((mortdays < 31 AND (acs = 1 AND acst < 3)) OR (mortdays < 31 AND (acs = 0)))
        THEN 1
      ELSE 0
      END mort30nonstemi,
    acsgroup AS acsgroupvis,
    CASE 
      WHEN pvd1 = 1 OR pvd2 = 1
        THEN 1
      ELSE 0
      END AS PVDhistory,
    CASE 
      WHEN ppci = 1
        THEN 1
      ELSE 0
      END AS previouspci,
    bmiunderweight,
    bminormal,
    bmioverweight,
    bmiobese,
    egfrgreaterthan60,
    egfrbetween31and60,
    egfrlessthanthirty,
    lvef,
    efnormal,
    efmild,
    efmoderate,
    efsevere,
    cardiogenicshock,
    outofhospitalcardiacarrest,
    preproceduralintubation,
    proceduralintubationrequired,
    CAST(pcab AS INT) AS pcab
  FROM (
    SELECT *,
      CASE 
        WHEN (acs = 1 AND acst < 3)
          THEN 2
        WHEN (acs = 1 AND acst = 3)
          THEN 3
        WHEN acs = 0
          THEN 1
        END AS acsgroup,
      CASE 
        WHEN (ihbl = 3 OR ihbl = 4 OR ihbl = 5 OR ihbl = 7 OR ihbl = 8)
          THEN 1
        ELSE 0
        END majorbl,
      CASE 
        WHEN (ihst = 1 OR ihst = 2)
          THEN 1
        ELSE 0
        END st,
      CASE 
        WHEN (ihpcip = 0 AND ihtvr = 1) OR (ihpcab = 0 AND ihtvcab = 1)
          THEN 1
        ELSE 0
        END unpltvr,
      CASE 
        WHEN (oca = 1 AND (pint = 1 OR pintr = 1))
          THEN 1
        ELSE 0
        END sickOHCA
    FROM (
      SELECT *,
        CASE 
          WHEN DATEDIFF(D, dod, dmort30) <= 30 OR dis = 6
            THEN 1
          ELSE 0
          END AS Mort30,
        CASE 
          WHEN (unprevascnew = 1 OR empci30 = 1 OR emcab30 = 1)
            THEN 1
          ELSE 0
          END unprevasc30new
      FROM (
        SELECT X.*,
          CASE 
            WHEN st30 = 1
              THEN 1
            ELSE 0
            END AS str30,
          DATEDIFF(D, dod, dmort30) AS mortdays,
          pcabg AS pcab,
          CASE 
            WHEN ((ihpcip = 0) OR (ihpcab = 0 AND ihtvcab = 1))
              THEN 1
            ELSE 0
            END unprevascnew,
          CASE 
            WHEN (pc30 = 0 AND pci30 = 1)
              THEN 1
            WHEN (pc30_2 = 0 AND pci30_2 = 1)
              THEN 1
            WHEN (pc30_3 = 0 AND pci30_3 = 1)
              THEN 1
            WHEN (pc30_4 = 0 AND pci30_4 = 1)
              THEN 1
            WHEN (pc30_5 = 0 AND pci30_5 = 1)
              THEN 1
            WHEN (pc30_6 = 0 AND pci30_6 = 1)
              THEN 1
            ELSE 0
            END empci30,
          CASE 
            WHEN (pc30 = 0 AND cab30 = 1)
              THEN 1
            WHEN (pc30_2 = 0 AND cab30_2 = 1)
              THEN 1
            WHEN (pc30_3 = 0 AND cab30_3 = 1)
              THEN 1
            WHEN (pc30_4 = 0 AND cab30_4 = 1)
              THEN 1
            WHEN (pc30_5 = 0 AND cab30_5 = 1)
              THEN 1
            WHEN (pc30_6 = 0 AND cab30_6 = 1)
              THEN 1
            ELSE 0
            END emcab30,
          CASE 
            WHEN (ihpci = 1 AND ihpcip = 0)
              THEN 1
            WHEN (ihpci = 1 AND ihpcip = 1)
              THEN 2
            ELSE 0
            END AS empcibase,
          CASE 
            WHEN (ihcab = 1 AND ihpcab = 0)
              THEN 1
            WHEN (ihcab = 1 AND ihpcab = 1)
              THEN 2
            ELSE 0
            END AS emcabbase
        FROM (
          SELECT nt.*,
            h.[state] stateid,
            h.publicorprivate
          FROM ##vw_quarterleyreportdetailncrtable nt
          INNER JOIN dim.hospital h ON nt.ncrhid = h.ncrhospitalid
          ) X
        ) v
      ) v1
    ) v2
  ) AS m