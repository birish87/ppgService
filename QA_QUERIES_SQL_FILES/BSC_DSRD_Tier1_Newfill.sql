
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Tier1_Newfill', $$Delete from reporting.rpt_bsc_claim_history;
Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;

----select * from aaa_reports ar where ar.transaction_id ='D-QTFA4-91GUS' --- update the inserted_at date to fall within 6 months of the report generation date

--update reporting.rpt_dsrd_transaction_detail rdtd
--set published_date = '2023-03-14 18:01:10'
--where rdtd.transaction_id = 'D-QTFA4-91GUS'--- update the date if it does not work

INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)VALUES(1,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH', '000012285355', '1609963818', '50383023210', 'Dorzolamide 2% Ophth Solution', 'N', 'O', 9268, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802340102020', 5.0, 8.24, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');

-----INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc,concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)VALUES(1,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH', '000012285355', '1609963818', '50383023210', 'Dorzolamide 2% Ophth Solution', 'N', 'O', 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802340102020', 5.0, 8.24, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');



--Delete from reporting.rpt_bsc_claim_history;
--Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;
--INSERT INTO reporting.rpt_bsc_claim_history (id,patient_identifier,new_patient_identifier,carrier_id,account_id,group_id,adjudication_datetime,date_of_service,prescription_service_reference_number,service_provider_id,med_ndc,med_name,med_brand,med_msc,specific_product_id,concept_name,quantity_dispensed,days_supply,fill_number,gpi_14,patient_cost,total_cost,inserted_at,transaction_code,"row_number",med_type) VALUES
--(1,'00433677993333910217343001970-01-01','bsc910217343001970-01-01','DSRD Automation test tier 1',NULL,'E00010022000CMCM0002','2022-11-24 00:00:00.000','2022-11-24 00:00:00.000','000012285355','1609963818','00143929101','Estradiol 200mg/5mL for Inj','N','Y',5983,'estrogens, excluding hormonal contraceptives',20.0,10,'01','24000035201715',1.0,1.0,'2022-11-24 00:00:00.000','1',1,'M');


--INSERT INTO reporting.rpt_bsc_claim_history (id,patient_identifier,new_patient_identifier,carrier_id,account_id,group_id,adjudication_datetime,date_of_service,prescription_service_reference_number,service_provider_id,med_ndc,med_name,med_brand,med_msc,specific_product_id,concept_name,quantity_dispensed,days_supply,fill_number,gpi_14,patient_cost,total_cost,inserted_at,transaction_code,"row_number",med_type) VALUES
--(1,'00433677993333910217343001970-01-01','bsc910217343001970-01-01','DSRD Automation test tier 1',NULL,'E00010022000CMCM0002',date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', date_trunc('month', current_date - interval '1' month)+ interval '15 DAY','000012285355','1609963818','00143929101','Estradiol 200mg/5mL for Inj','N','Y',5983,'estrogens, excluding hormonal contraceptives',20.0,10,'01','24000035201715',1.0,1.0,date_trunc('month', current_date - interval '1' month)+ interval '15 DAY','1',1,'M')
--;
$$);
