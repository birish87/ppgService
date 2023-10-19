
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRE_BSC_ExistingMed_Claimed_After_Tier1_Insert', $$Delete from reporting.rpt_bsc_claim_history;
Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;
--INSERT INTO public.rpt_bsc_claim_history
--(patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type, id)
--VALUES('00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', now()- INTERVAL '1 MONTH', '000012285355', '1609963818', '70436001206', 'Desvenlafaxine 50mg ER Tablet', 'N', 'Y', 15382, 'Antidepressants - SNRIs', 20.0, 10, '01', '58180020207520', '58180020', '5818', 50.0, 50.0, now()- INTERVAL '1 MONTH', '1', 1, 'M', 101);


INSERT INTO reporting.rpt_bsc_claim_history
(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(13, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'Tier 1 ', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', '000012285355', '1578544474', '01', '00093914701', 'Venlafaxine 25mg Tablet', 'N', 'Y', 15382, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180090100320', 5.0, 52.22, date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', '1', 1, 'M');

INSERT INTO reporting.rpt_bsc_claim_history
(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(14, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'ChosenMed', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month) + interval '18 DAY', date_trunc('month', current_date - interval '1' month) + interval '18 DAY', '000012285355', '1578544474', '01', '70436001206', 'Desvenlafaxine 50mg ER Tablet', 'N', 'Y', 15382, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180020207520', 5.0, 52.22, date_trunc('month', current_date - interval '1' month) + interval '18 DAY', '1', 1, 'M');
$$);
