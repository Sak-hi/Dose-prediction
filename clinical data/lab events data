# Lab events file
# Import file
%web_drop_table(WORK.IMPORT1);
FILENAME REFFILE '/home/u64405993/mimic files/labevents mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT1; RUN;
%web_open_table(WORK.IMPORT1);

# Delete missing values
DATA Lab_missingval;
    SET WORK.IMPORT1;
    IF value = . THEN DELETE;
    IF valuenum = . THEN DELETE;
RUN; 

# Binary form flag
DATA lab_range;
    SET Lab_missingval;
    IF ref_range_lower = . OR ref_range_upper = . THEN flag = .;
    ELSE IF valuenum < ref_range_lower THEN flag = -1;
    ELSE IF valuenum > ref_range_upper THEN flag = 1;
    ELSE flag = 0;
RUN;

# Count 
PROC SQL;
    SELECT valueuom,
           COUNT(*) AS unit_count
    FROM lab_range
    WHERE valueuom IS NOT NULL
    GROUP BY valueuom
    ORDER BY unit_count DESC;
QUIT;

# Unit imputation
DATA lab_unit;
    SET lab_range;
    IF valueuom = . then= '%';
RUN;

# Aggregate table
PROC SQL;
CREATE TABLE lab_avg AS
SELECT subject_id,
       hadm_id,
       combined_id,
       AVG(valuenum) AS avg_lab_value,
       MIN(valuenum) AS min_lab_value,
       MAX(valuenum) AS max_lab_value,
       MAX(flag) AS abnormal_flag
FROM lab_unit
GROUP BY subject_id, hadm_id, combined_id;
QUIT;

# Combined table
PROC SQL;
CREATE TABLE lab_final AS
SELECT a.*,
       b.charttime,
       b.storetime,
       b.value,
       b.valueuom,
       b.ref_range_lower,
       b.ref_range_upper
FROM lab_avg a
LEFT JOIN lab_unit b
ON a.subject_id = b.subject_id
AND a.hadm_id   = b.hadm_id
AND a.combined_id = b.combined_id
AND b.charttime = (
        SELECT MIN(charttime)
        FROM lab_unit c
        WHERE c.subject_id = a.subject_id
          AND c.hadm_id = a.hadm_id
          AND c.combined_id = a.combined_id
    );
QUIT;

# Export file
PROC EXPORT 
	DATA=work.lab_final
	OUTFILE= "/home/u64405993/mimic files/labevents_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
