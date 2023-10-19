
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('Horizon_Claim_Medications_DataSeed_1', $$INSERT INTO horizon_claim_medications (patient_gender,patient_first_name,patient_last_name,concept_name,ndc,product_name,specific_product_id,quantity,days_supply,maintenance_indicator,date_of_service,prescriber_id,prescriber_last_name,service_provider_id,bin_number,processor_control_number,cardholder_id,person_code,date_of_birth,prescriber_id_qualifier,service_provider_id_qualifier,active,daw_product_selection_code,payer_id,pharmacy_id,inserted_at,updated_at,periodic_indicator,total_cost,patient_pay_amount,member_id) SELECT '2','CAROL','HARTMAN','selective serotonin reuptake inhibitor antidepressants, ssris','99999970000','Test-Symbicort 160-4.5mcg/act Inh',9700,30.0,30,true,'2020-07-09','1978973502','HILL','1427091255','016499','HZRX','TEST8888884444',NULL,'1980-04-01','01','01',false,'1',7,108288,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'TEST8888884444' WHERE NOT EXISTS(SELECT id from horizon_claim_medications where cardholder_id = 'TEST8888884444' and date_of_birth = '1980-04-01'); INSERT INTO horizon_claim_medications (patient_gender,patient_first_name,patient_last_name,concept_name,ndc,product_name,specific_product_id,quantity,days_supply,maintenance_indicator,date_of_service,prescriber_id,prescriber_last_name,service_provider_id,bin_number,processor_control_number,cardholder_id,person_code,date_of_birth,prescriber_id_qualifier,service_provider_id_qualifier,active,daw_product_selection_code,payer_id,pharmacy_id,inserted_at,updated_at,periodic_indicator,total_cost,patient_pay_amount,member_id) SELECT '1','JACOB','NORRIS','selective serotonin reuptake inhibitor antidepressants, ssris','99999970002','Test-AirDuo RespiClick 113/14 Inh',9702,30.0,30,true,'2020-07-09','1978973502','HILL','1427091255','016499','HZRX','TEST8888885555',NULL,'1980-05-01','01','01',false,'1',7,108288,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'TEST8888885555' WHERE NOT EXISTS(SELECT id from horizon_claim_medications where cardholder_id = 'TEST8888885555' and date_of_birth = '1980-05-01');INSERT INTO horizon_claim_medications (patient_gender,patient_first_name,patient_last_name,concept_name,ndc,product_name,specific_product_id,quantity,days_supply,maintenance_indicator,date_of_service,prescriber_id,prescriber_last_name,service_provider_id,bin_number,processor_control_number,cardholder_id,person_code,date_of_birth,prescriber_id_qualifier,service_provider_id_qualifier,active,daw_product_selection_code,payer_id,pharmacy_id,inserted_at,updated_at,periodic_indicator,total_cost,patient_pay_amount,member_id) SELECT '2','AUTO_LN12','AUTO_FN12','selective serotonin reuptake inhibitor antidepressants, ssris','99999970000','Test-Symbicort 160-4.5mcg/act Inh',9700,30.0,30,true,'2020-07-09','1978973502','HILL','1427091255','016499','HZRX','TEST99999999940',NULL,'1980-04-01','01','01',false,'1',7,108288,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'TEST99999999940' WHERE NOT EXISTS(SELECT id from horizon_claim_medications where cardholder_id = 'TEST99999999940' and date_of_birth = '1980-04-01');$$);