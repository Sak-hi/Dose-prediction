# Diagnosis_icd file
# Import file
%web_drop_table(WORK.IMPORT1);
FILENAME REFFILE '/home/u64405993/mimic files/diagnoses_icd mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT1; RUN;
%web_open_table(WORK.IMPORT1);

# Count
PROC SQL;
CREATE TABLE diag_count AS
SELECT subject_id,
       hadm_id,
       COUNT(DISTINCT icd_code) AS num_diagnoses
FROM WORK.IMPORT1
GROUP BY subject_id, hadm_id;
QUIT;

# Distinct 
PROC SQL;
CREATE TABLE diag_count AS
SELECT subject_id,
       hadm_id,
       COUNT(DISTINCT icd_code) AS num_diagnoses
FROM WORK.IMPORT1
GROUP BY subject_id, hadm_id;
QUIT;

# Combine table
PROC SQL;
    CREATE TABLE diagnosis_final AS
    SELECT 
        a.subject_id,
        a.hadm_id,
        a.seq_num,
        a.icd_code,
        a.icd_version,
        a.combined_id,
        b.num_diagnoses
    FROM WORK.IMPORT1 a
    LEFT JOIN diag_count b
        ON a.subject_id = b.subject_id
       AND a.hadm_id   = b.hadm_id;
QUIT;

# Export file
PROC EXPORT 
	DATA= work.diagnosis_final
	OUTFILE= "/home/u64405993/mimic files/diagnosis_icd_modified(1).xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
