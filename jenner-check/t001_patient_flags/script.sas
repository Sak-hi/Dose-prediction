/* Patient file — adapted from clinical data/patient data.sas.
   The upstream script imports patients mimic-iv(1).xlsx; here the same
   columns are supplied inline so the binary-flag logic runs standalone. */

/* Mock of the MIMIC-IV patients table this script imports */
DATA WORK.IMPORT;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id gender $ anchor_age dod :yymmdd10.;
  FORMAT dod yymmdd10.;
  DATALINES;
10001,M,67,.
10002,F,54,2180-05-03
10003,M,72,.
10004,F,45,.
10005,M,80,2179-11-20
10006,F,61,.
10007,M,58,.
10008,F,90,2181-01-15
;
RUN;

/* Mean */
PROC MEANS DATA=WORK.IMPORT;
RUN;

/* Modify binary */
DATA patient_step1;
    SET WORK.IMPORT;
    IF gender = 'M' THEN gender_num = 1;
    ELSE IF gender = 'F' THEN gender_num = 0;

    IF dod = . THEN death_flag = 0;
    ELSE death_flag = 1;
    DROP gender dod;
RUN;

PROC PRINT DATA=patient_step1; RUN;
