/* Input events file — adapted from clinical data/inputevents data.sas.
   Upstream imports inputevents mimic-iv(1).xlsx; the columns are supplied
   inline so the median/unit imputation, PROC FREQ, and dose-duration math
   run standalone. */

/* Mock of the MIMIC-IV inputevents table */
DATA WORK.IMPORT3;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id hadm_id starttime :datetime20. rate rateuom $ amount amountuom $ combined_id $;
  FORMAT starttime datetime20.;
  DATALINES;
10001,20001,01JAN2180:08:00:00,4.915,mL/hour,50,mL,10001_20001
10002,20002,10FEB2180:12:00:00,.,mL/hour,30,mL,10002_20002
10003,20003,05MAR2180:22:00:00,6.2,mL/hour,80,mL,10003_20003
10004,20004,20MAR2180:03:00:00,.,,40,mL,10004_20004
;
RUN;

/* Median impute */
DATA INPUT_IMPUTE3;
	SET WORK.IMPORT3;
	IF RATE = . THEN RATE = 4.915;
RUN;

/* Frequent values of variables */
PROC FREQ DATA= INPUT_IMPUTE3;
	TABLE RATEUOM;
RUN;

/* Unit impute */
DATA RATEUOM_IMPUTE3;
	SET INPUT_IMPUTE3;
	IF RATEUOM = " " THEN RATEUOM = 'mL/hour';
RUN;

/* Date & Time format */
DATA INPUT_ENDTIME7;
	SET RATEUOM_IMPUTE3;
	ENDTIME = STARTTIME + 7*86400;
	FORMAT STARTTIME ENDTIME DATETIME20.;
RUN;

/* Dose duration */
DATA INPUT_DOSEDURATION;
	SET INPUT_ENDTIME7;
	DOSE_DURATION_HR = (ENDTIME-STARTTIME)/3600;
RUN;

PROC PRINT DATA=INPUT_DOSEDURATION; VAR subject_id rate rateuom dose_duration_hr; RUN;
