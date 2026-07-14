/* Lab events file — adapted from clinical data/lab events data.sas.
   Upstream imports labevents mimic-iv(1).xlsx; the columns are supplied
   inline so the missing-value screen, reference-range flagging, and the
   per-admission aggregation run standalone. */

/* Mock of the MIMIC-IV labevents table */
DATA WORK.IMPORT1;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id hadm_id combined_id $ charttime :datetime20. value valuenum valueuom $ ref_range_lower ref_range_upper;
  FORMAT charttime datetime20.;
  DATALINES;
10001,20001,10001_20001,01JAN2180:09:00:00,4.5,4.5,mmol/L,3.5,5.1
10001,20001,10001_20001,02JAN2180:09:00:00,6.0,6.0,mmol/L,3.5,5.1
10002,20002,10002_20002,10FEB2180:09:00:00,2.9,2.9,mmol/L,3.5,5.1
10003,20003,10003_20003,05MAR2180:09:00:00,4.0,4.0,mmol/L,3.5,5.1
10004,20004,10004_20004,20MAR2180:09:00:00,.,.,mmol/L,3.5,5.1
;
RUN;

/* Delete missing values */
DATA Lab_missingval;
    SET WORK.IMPORT1;
    IF value = . THEN DELETE;
    IF valuenum = . THEN DELETE;
RUN;

/* Binary form flag: -1 below range, +1 above range, 0 within range */
DATA lab_range;
    SET Lab_missingval;
    IF ref_range_lower = . OR ref_range_upper = . THEN flag = .;
    ELSE IF valuenum < ref_range_lower THEN flag = -1;
    ELSE IF valuenum > ref_range_upper THEN flag = 1;
    ELSE flag = 0;
RUN;

/* Aggregate table */
PROC SQL;
CREATE TABLE lab_avg AS
SELECT subject_id,
       hadm_id,
       combined_id,
       AVG(valuenum) AS avg_lab_value,
       MIN(valuenum) AS min_lab_value,
       MAX(valuenum) AS max_lab_value,
       MAX(flag) AS abnormal_flag
FROM lab_range
GROUP BY subject_id, hadm_id, combined_id;
QUIT;

PROC PRINT DATA=lab_range; VAR subject_id valuenum ref_range_lower ref_range_upper flag; RUN;
PROC PRINT DATA=lab_avg; RUN;
