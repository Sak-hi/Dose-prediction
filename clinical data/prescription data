# Prescription file
# Import data
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/home/u64405993/mimic files/prescriptions mimic-iv(1).xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

# Select drug
DATA Drug1;
    SET WORK.IMPORT;
    IF drug = 'Aspirin';
RUN;

# Date & time
DATA Precription7;
	SET Drug1;
	STOPTIME = STARTTIME + 7*86400;
	FORMAT STARTTIME STOPTIME DATETIME20.;
RUN;

# Route
DATA Route_oral;
    SET Precription7;
    IF route IN ('PO','NG','PO/NG') THEN route = 'ORAL';
RUN;

# Aggregate table
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

# Combine table
PROC SQL;
    CREATE TABLE outputevents_final AS
    SELECT 
        a.subject_id,
        a.hadm_id,
        a.starttime,
        a.stoptime,
        a.drug_type,
        a.drug,
        a.formulary_drug_cd,
        a.prod_strength,
        a.dose_val_rx,
        a.dose_unit_rx,
        a.form_val_disp,
        a.form_unit_disp,
        a.doses_per_24_hrs,
        a.route,
        a.combined_id,
        b.avg_daily_dose,
        b.max_daily_dose,
        b.total_dose
    FROM Route_oral a
    LEFT JOIN rx_agg b
        ON a.subject_id = b.subject_id
       AND a.hadm_id   = b.hadm_id;
QUIT;

# Selective columns
DATA drug_final;
    SET Route_oral (
        KEEP =
            subject_id
            hadm_id
            starttime
            stoptime
            drug_type
            drug
            formulary_drug_cd
            prod_strength
            dose_val_rx
            dose_unit_rx
            form_val_disp
            form_unit_disp
            doses_per_24_hrs
            route
            combined_id
    );
RUN;

# Export file
PROC EXPORT 
	DATA=work.drug_final
	OUTFILE= "/home/u64405993/mimic files/prescriptions_modified.xlsx"
	DBMS= XLSX 
	REPLACE;
RUN;
