# Combined the master table
PROC SQL;
CREATE TABLE final_ml_table AS
SELECT
    a.subject_id,
    a.hadm_id,

    /* patients */
    p.anchor_age AS age,
    p.gender_num AS sex,
    p.death_flag,

    /* admissions */
    a.los_hours,
    a.admission_type,

    /* prescriptions */
    pr.doses_per_24_hrs,
    pr.starttime,
    pr.stoptime,
    pr.avg_daily_dose,
    pr.max_daily_dose,
    pr.total_dose,

    /* inputevents */
    ie.dose_duration_hr,
    ie.rate,
    ie.avg_dose_per_hr,
    ie.max_dose_per_hr,
    ie.total_duration_hrs,

    /* outputevents */
    oe.total_urine_ml,
    oe.avg_urine_ml,

    /* chartevents */
    ce.avg_value,
    ce.min_value,
    ce.max_value,
    
     /* labevents */
    le.avg_lab_value,
    le.min_lab_value,
    le.max_lab_value,
    le.abnormal_flag,
    
     /* diagnose_icd */
    d.num_diagnoses

FROM WORK.IMPORT2 p

LEFT JOIN WORK.IMPORT3 a
    ON p.subject_id = a.subject_id

LEFT JOIN WORK.IMPORT6 pr
    ON p.subject_id = pr.subject_id

LEFT JOIN WORK.IMPORT8 ie
    ON p.subject_id = ie.subject_id

LEFT JOIN WORK.IMPORT5 oe
    ON p.subject_id = oe.subject_id

LEFT JOIN WORK.IMPORT7 ce
    ON p.subject_id = ce.subject_id
   
LEFT JOIN WORK.IMPORT9 le
    ON p.subject_id = le.subject_id
   
LEFT JOIN WORK.IMPORT10 d
    ON p.subject_id = d.subject_id;
QUIT;

# Export file
PROC EXPORT 
	DATA=work.final_ml_1000
	OUTFILE= "/home/u64405993/mimic files/Combined_table.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
