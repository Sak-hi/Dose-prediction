/* Admission data — adapted from clinical data/admission patient data.sas.
   Upstream imports admissions mimic-iv(1).xlsx; the admit/discharge datetime
   columns are supplied inline so the interval math runs standalone. */

/* Mock of the MIMIC-IV admissions table */
DATA WORK.IMPORT;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id hadm_id admittime :datetime20. dischtime :datetime20. admission_type $;
  FORMAT admittime dischtime datetime20.;
  DATALINES;
10001,20001,01JAN2180:08:00:00,04JAN2180:14:00:00,EMERGENCY
10002,20002,10FEB2180:12:30:00,12FEB2180:09:15:00,ELECTIVE
10003,20003,05MAR2180:22:00:00,09MAR2180:06:45:00,URGENT
10004,20004,20MAR2180:03:10:00,21MAR2180:18:00:00,EMERGENCY
;
RUN;

/* Dose duration */
DATA ADMISSION_DOSEDURATION;
	SET WORK.IMPORT;
	DOSE_DURATION_HR = (DISCHTIME-ADMITTIME)/3600;
RUN;

/* Length of stay in days & hours */
DATA Length_of_stay;
    SET ADMISSION_DOSEDURATION;
    los_days = (dischtime - admittime) / 86400;
RUN;

DATA los_HR;
    SET Length_of_stay;
    los_hours = (dischtime - admittime) / 3600;
RUN;

PROC PRINT DATA=los_HR; VAR subject_id dose_duration_hr los_days los_hours; RUN;
