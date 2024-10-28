-- extract icu stays with at least one measurement of creatinine or urine output into kdigo_stages_measured.csv
COPY (
    SELECT * 
    FROM mimiciii.kdigo_stages 
    WHERE icustay_id IN (
        SELECT icustay_id 
        FROM mimiciii.kdigo_stages 
        WHERE (creat IS NOT NULL OR uo_rt_6hr IS NOT NULL OR uo_rt_12hr IS NOT NULL OR uo_rt_24hr IS NOT NULL) 
        AND aki_stage IS NOT NULL 
        GROUP BY icustay_id 
        HAVING COUNT(*) > 0
    )
) 
TO '/path/to/data/kdigo_stages_measured.csv' WITH CSV HEADER DELIMITER ';';


-- extract demographics of patients with at least one measurement of creatinine or urine output into icustay_detail-kdigo_stages_measured.csv
COPY (
    SELECT * 
    FROM mimiciii.icustay_detail 
    WHERE icustay_id IN (
        SELECT icustay_id 
        FROM mimiciii.kdigo_stages 
        WHERE (creat IS NOT NULL OR uo_rt_6hr IS NOT NULL OR uo_rt_12hr IS NOT NULL OR uo_rt_24hr IS NOT NULL) 
        AND aki_stage IS NOT NULL 
        GROUP BY icustay_id 
        HAVING COUNT(*) > 0
    )
) 
TO '/path/to/data/icustay_detail-kdigo_stages_measured.csv' WITH CSV HEADER DELIMITER ';';
 
-- extract vitals of icu stays with at least one measurement of creatinine or urine output and an AKI label into vitals-kdigo_stages_measured.csv
COPY (
    SELECT * 
    FROM mimiciii.vitals 
    WHERE icustay_id IN (
        SELECT icustay_id 
        FROM mimiciii.kdigo_stages 
        WHERE (creat IS NOT NULL OR uo_rt_6hr IS NOT NULL OR uo_rt_12hr IS NOT NULL OR uo_rt_24hr IS NOT NULL) 
        AND aki_stage IS NOT NULL 
        GROUP BY icustay_id 
        HAVING COUNT(*) > 0
    )
) 
TO '/path/to/data/vitals-kdigo_stages_measured.csv' WITH CSV HEADER DELIMITER ';';
 
-- extract labs of icu stays with at least one measurement of creatinine or urine output and an AKI label into labs-kdigo_stages_measured.csv
COPY (
    SELECT * 
    FROM mimiciii.labs 
    WHERE icustay_id IN (
        SELECT icustay_id 
        FROM mimiciii.kdigo_stages 
        WHERE (creat IS NOT NULL OR uo_rt_6hr IS NOT NULL OR uo_rt_12hr IS NOT NULL OR uo_rt_24hr IS NOT NULL) 
        AND aki_stage IS NOT NULL 
        GROUP BY icustay_id 
        HAVING COUNT(*) > 0
    )
) 
TO '/path/to/data/labs-kdigo_stages_measured.csv' WITH CSV HEADER DELIMITER ';';

-- extract ventilations, vasopressor, and sedatives of icu stays with at least one measurement of creatinine or urine output and an AKI label into vents-vasopressor-sedatives-kdigo_stages_measured.csv 
COPY (
    SELECT ve.icustay_id, ve.charttime, ve.vent, va.vasopressor, s.sedative
    FROM mimiciii.vent_kdigo_stages_labs_vitals_charttime ve
    JOIN mimiciii.vasopressor_kdigo_stages_labs_vitals_charttime va ON ve.icustay_id = va.icustay_id AND ve.charttime = va.charttime
    JOIN mimiciii.sedatives_kdigo_stages_labs_vitals_charttime s ON va.icustay_id = s.icustay_id AND va.charttime = s.charttime
    WHERE ve.icustay_id IN (
        SELECT icustay_id 
        FROM mimiciii.kdigo_stages 
        WHERE (creat IS NOT NULL OR uo_rt_6hr IS NOT NULL OR uo_rt_12hr IS NOT NULL OR uo_rt_24hr IS NOT NULL) 
        AND aki_stage IS NOT NULL 
        GROUP BY icustay_id 
        HAVING COUNT(*) > 0
    )
    ORDER BY ve.icustay_id, ve.charttime
) 
TO '/path/to/data/vents-vasopressor-sedatives-kdigo_stages_measured.csv' WITH CSV HEADER DELIMITER ';';
