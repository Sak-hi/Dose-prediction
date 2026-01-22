# Chart events data
# Import file
%web_drop_table(WORK.IMPORT1);
FILENAME REFFILE '/home/u64405993/mimic files/chartevents mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT1; RUN;
%web_open_table(WORK.IMPORT1);

# Median
PROC MEANS DATA=WORK.IMPORT1 MEDIAN;

# Median impute
DATA chart_median;
	SET WORK.IMPORT1;
	IF valuenum = . THEN valuenum = 17;
RUN;

# Count
PROC SQL;
    CREATE TABLE unit_count AS
    SELECT valueuom,
           COUNT(*) AS freq
    FROM chart_median
    WHERE valueuom IS NOT NULL
    GROUP BY valueuom
    ORDER BY freq DESC;
QUIT;

# Unit impute
DATA chart_unit;
    SET chart_median;
    IF valueuom =. Then= '%';
RUN;

# Aggregate table
PROC SQL;
    CREATE TABLE chart_avg AS
    SELECT subject_id,
           hadm_id,
           AVG(valuenum) AS avg_value,
           MIN(valuenum) AS min_value,
           MAX(valuenum) AS max_value
    FROM chart_unit
    GROUP BY subject_id, hadm_id;
QUIT;

# Combine 
PROC SQL;
    CREATE TABLE outputevents_final AS
    SELECT 
        a.subject_id,
        a.hadm_id,
        a.stay_id,
        a.charttime,
        a.storetime,
        a.valuenum,
        a.valueuom,
        a.combined_id,
        b.avg_value,
        b.min_value,
        b.max_value
    FROM chart_unit a
    LEFT JOIN chart_avg b
        ON a.subject_id = b.subject_id
       AND a.hadm_id   = b.hadm_id;
QUIT;

# Export file
PROC EXPORT 
	DATA= work.outputevents_final
	OUTFILE= "/home/u64405993/mimic files/chartevents_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
