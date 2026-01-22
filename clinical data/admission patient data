# Admission data
# Import file
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/home/u64405993/mimic files/admissions mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

# Dose duration
DATA ADMISSION_DOSEDURATION;
	SET WORK.IMPORT;
	DOSE_DURATION_HR = (DISCHTIME-ADMITTIME)/3600;
RUN;

# Length of stay in days & hours
DATA Length_of_stay;
    SET ADMISSION_DOSEDURATION;
    los_days = (dischtime - admittime) / 86400;
RUN;

DATA los_HR;
    SET Length_of_stay;
    los_hours = (dischtime - admittime) / 3600;
RUN;

# Export file
PROC EXPORT 
	DATA=WORK.ADMISSION_DOSEDURATION 
	OUTFILE= "/home/u64405993/mimic files/admission_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
