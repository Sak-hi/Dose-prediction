/* Diagnosis_icd file — adapted from clinical data/diagnosis data.sas.
   Upstream imports diagnoses_icd mimic-iv(1).xlsx; the columns are supplied
   inline so the distinct-diagnosis count and back-join run standalone. */

/* Mock of the MIMIC-IV diagnoses_icd table */
DATA WORK.IMPORT1;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id hadm_id seq_num icd_code $ icd_version combined_id $;
  DATALINES;
10001,20001,1,I10,10,10001_20001
10001,20001,2,E119,10,10001_20001
10001,20001,3,I10,10,10001_20001
10002,20002,1,J189,10,10002_20002
10002,20002,2,N179,10,10002_20002
10003,20003,1,I509,10,10003_20003
;
RUN;

/* Count distinct diagnoses per admission */
PROC SQL;
CREATE TABLE diag_count AS
SELECT subject_id,
       hadm_id,
       COUNT(DISTINCT icd_code) AS num_diagnoses
FROM WORK.IMPORT1
GROUP BY subject_id, hadm_id;
QUIT;

/* Combine table */
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

PROC PRINT DATA=diag_count; RUN;
PROC PRINT DATA=diagnosis_final; RUN;
