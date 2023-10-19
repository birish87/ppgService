
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_DOS_sameas_DSRpublicationdate', $$Delete from reporting.rpt_bsc_claim_history;
Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;
--INSERT INTO public.rpt_bsc_claim_history(patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
--VALUES('00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', '2022-02-09 13:14:15.342', '2021-12-30 13:14:15.342', '000012285355', '1609963818', '62332020730', 'Amlod/Valsartan 5mg-320mg Tab', 'N', 'Y', 14586, 'low ccb / high arb combination', 20.0, 10, '01', '36993002100320', '36993002', '3699', 5.0, 8.24, '2022-02-08 13:14:15.342', '1', 1, 'M');


----update the published date manually for this test to run.set DOS same as published date and the adjudication and inserted date in the reporting month.Prep data table will be empty. 
INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(1,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', '2023-03-14 13:14:15.342', '2023-03-14 13:14:15.342', '000012285355', '1609963818', '62332020730', 'Amlod/Valsartan 5mg-320mg Tab', 'N', 'Y', 14586, 'low ccb / high arb combination', 20.0, 10, '01', '36993002100320',5.0, 8.24, '2023-03-14 13:14:15.342', '1', 1, 'M');
$$);
