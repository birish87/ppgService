
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Tier2_New', $$Delete from reporting.rpt_bsc_claim_history;
Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;
---INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
---VALUES(10,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH', '000012285355', '1609963818', '13668034430', 'Telmis/Amlodipine 80mg-5mg Tab', 'N', 'Y', 16849, 'low ccb / high arb combination', 20.0, 10, '01', '36993002700340', '36993002', '3699', 20, 30, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');

INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14,  patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(10,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH', '000012285355', '1609963818', '13668034430', 'Telmis/Amlodipine 80mg-5mg Tab', 'N', 'Y', 16849, 'low ccb / high arb combination', 20.0, 10, '01', '36993002700340', 20, 30, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');
$$);
