# Output events file
# Import file
%web_drop_table(WORK.IMPORT1);
FILENAME REFFILE '/home/u64405993/mimic files/outputevents mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT1; RUN;
%web_open_table(WORK.IMPORT1);

# Aggregation table
PROC SQL;
    CREATE TABLE output_value AS
    SELECT subject_id,
           hadm_id,
           SUM(value) AS total_urine_ml,
           MEAN(value) AS avg_urine_ml
    FROM WORK.IMPORT1
    GROUP BY subject_id, hadm_id;
QUIT;

# Combine table
PROC SQL;
    CREATE TABLE outputevents_final AS
    SELECT 
        a.subject_id,
        a.hadm_id,
        a.charttime,
        a.storetime,
        a.value,
        a.valueuom,
        a.combined_id,
        b.total_urine_ml,
        b.avg_urine_ml
    FROM WORK.IMPORT1 a
    LEFT JOIN output_value b
        ON a.subject_id = b.subject_id
       AND a.hadm_id   = b.hadm_id;
QUIT;

# Export file
PROC EXPORT 
	DATA=work.outputevents_final 
	OUTFILE= "/home/u64405993/mimic files/outputevents_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
