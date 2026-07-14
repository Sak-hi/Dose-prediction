/* Prescription file — adapted from clinical data/prescription data.sas.
   Upstream imports prescriptions mimic-iv(1).xlsx; the columns the script
   reads are supplied inline so the drug subset, datetime math, route recode
   and PROC SQL aggregation run standalone. */

/* Mock of the MIMIC-IV prescriptions table */
DATA WORK.IMPORT;
  INFILE DATALINES DSD DLM=',';
  INPUT subject_id hadm_id drug $ starttime :datetime20. drug_type $ doses_per_24_hrs route $ combined_id $;
  FORMAT starttime datetime20.;
  DATALINES;
10001,20001,Aspirin,01JAN2180:08:00:00,MAIN,2,PO,10001_20001
10001,20001,Aspirin,02JAN2180:08:00:00,MAIN,2,NG,10001_20001
10002,20002,Aspirin,10FEB2180:12:00:00,MAIN,1,PO/NG,10002_20002
10003,20003,Aspirin,05MAR2180:22:00:00,MAIN,3,PO,10003_20003
10004,20004,Warfarin,20MAR2180:03:00:00,MAIN,1,PO,10004_20004
;
RUN;

/* Select drug */
DATA Drug1;
    SET WORK.IMPORT;
    IF drug = 'Aspirin';
RUN;

/* Date & time */
DATA Precription7;
	SET Drug1;
	STOPTIME = STARTTIME + 7*86400;
	FORMAT STARTTIME STOPTIME DATETIME20.;
RUN;

/* Route */
DATA Route_oral;
    SET Precription7;
    IF route IN ('PO','NG','PO/NG') THEN route = 'ORAL';
RUN;

/* Aggregate table */
PROC SQL;
CREATE TABLE rx_agg AS
SELECT subject_id,
       hadm_id,
       drug,
       AVG(doses_per_24_hrs) AS avg_daily_dose,
       MAX(doses_per_24_hrs) AS max_daily_dose,
       SUM(doses_per_24_hrs) AS total_dose
FROM Route_oral
GROUP BY subject_id, hadm_id, drug;
QUIT;

PROC PRINT DATA=rx_agg; RUN;
