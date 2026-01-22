# Input events file
# Import 
%web_drop_table(WORK.IMPORT3);
FILENAME REFFILE '/home/u64405993/inputevents mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT3;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT3; RUN;
%web_open_table(WORK.IMPORT3);


# Median 
PROC MEANS DATA=WORK.IMPORT3 MEDIAN;
RUN;

# Median impute
DATA INPUT_IMPUTE3;
	SET WORK.IMPORT3;
	IF RATE = . THEN RATE = 4.915;
RUN;

# Frequent values of variables
PROC FREQ DATA= INPUT_IMPUTE3;
	TABLE RATEUOM;
RUN;

# Unit impute
DATA RATEUOM_IMPUTE3;
	SET INPUT_IMPUTE3;
	IF RATEUOM = " " THEN RATEUOM = 'mL/hour';
RUN;

# Date & Time format
DATA INPUT_ENDTIME7;
	SET RATEUOM_IMPUTE3;
	ENDTIME = STARTTIME + 7*86400;
	FORMAT STARTTIME ENDTIME DATETIME20.;
RUN;

# Dose duration 
DATA INPUT_DOSEDURATION;
	SET INPUT_ENDTIME7;
	DOSE_DURATION_HR = (ENDTIME-STARTTIME)/3600;
RUN;

# Rateuom impute
DATA inputevents_rateuom;
    SET WORK.IMPORT;
    IF strip(rateuom) = 'mL/hour';
RUN;

# Aggregate
PROC SQL;
CREATE TABLE input_agg AS
SELECT subject_id,
             hadm_id,

       AVG(dose_duration_hr) AS avg_dose_per_hr,
       MAX(dose_duration_hr) AS max_dose_per_hr,
       SUM(dose_duration_hr) AS total_duration_hrs
FROM WORK.IMPORT
GROUP BY subject_id, hadm_id;
QUIT;

# Combine table
PROC SQL;
    CREATE TABLE inputevents_final AS
    SELECT 
        a.subject_id,
        a.hadm_id,
        a.starttime,
        a.endtime,
        a.storetime,
        a.amount,
        a.amountuom,
        a.rate,
        a.rateuom,
        a.ordercategoryname,
        a.combined_id,
        a.dose_duration_hr,
        b.avg_dose_per_hr,
        b.max_dose_per_hr,
        b.total_duration_hrs
    FROM WORK.IMPORT a
    LEFT JOIN input_agg b
        ON a.subject_id = b.subject_id
       AND a.hadm_id   = b.hadm_id;
QUIT;

# Export file
PROC EXPORT 
	DATA=WORK.INPUT_DOSEDURATION 
	OUTFILE= "/home/u64405993/mimic files/inputevents_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
