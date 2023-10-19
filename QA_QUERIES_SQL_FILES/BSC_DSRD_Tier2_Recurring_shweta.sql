
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Tier2_Recurring_shweta', $$Delete from rpt_bsc_claim_history;
--Delete from rpt_bsc_dsr_claim_gpi_outcome_prep_data;
INSERT INTO public.rpt_bsc_claim_history
(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(11,'00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'DSRD Automation test tier 2 recurring Fill', NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH'+ interval '1 day', NOW()- INTERVAL '1 MONTH'+interval '1 day', '000012285355', '1609963818', '00378145201', 'Estradiol 0.5mg Tablet', 'N', 'Y', 60, 'estrogens, oral, excluding hormonal contraceptives - 2', 20.0, 10, '01', '24000035000303', 1.0, 1.0, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');$$);
