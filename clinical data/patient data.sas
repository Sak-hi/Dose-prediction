# Patient file
# Import files
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/home/u64405993/patients mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; 
RUN;
%web_open_table(WORK.IMPORT);
 

# Mean
PROC MEANS DATA=WORK.IMPORT;
RUN;
 

# Modify binary
DATA patient_step1;
    SET WORK.IMPORT;
    IF gender = 'M' THEN gender_num = 1;
    ELSE IF gender = 'F' THEN gender_num = 0;

    IF dod = . THEN death_flag = 0;
    ELSE death_flag = 1;
    DROP gender dod;
RUN;
 
# Export file
PROC EXPORT 
	DATA=work.patient_step1
	OUTFILE= "/home/u64405993/mimic files/patient_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
