
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_BSC_ChosenMedDOS_After_Tier1DOS_Insert', $$Delete from reporting.rpt_bsc_claim_history;
delete from reporting.rpt_bsc_ddp_claim_gpi_outcome_prep_data;
INSERT INTO reporting.rpt_bsc_claim_history
(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(101, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'test', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month) + interval '1 DAY', date_trunc('month', current_date - interval '1' month) + interval '1 DAY', '000012285355', '1578544474', '01', '00093738598', 'Venlafaxine 75mg ER Capsule', 'N', 'Y', 12532, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180090107030', 5.0, 52.22, date_trunc('month', current_date - interval '1' month) + interval '1 DAY', '1', 1, 'M');

INSERT INTO reporting.rpt_bsc_claim_history
(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(102, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'test', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month) + interval '15 DAY', date_trunc('month', current_date - interval '1' month) + interval '15 DAY', '000012285355', '1578544474', '01', '70436001206', 'Desvenlafaxine 50mg ER Tablet', 'N', 'Y', 15382, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180020207520', 5.0, 52.22, date_trunc('month', current_date - interval '1' month) + interval '15 DAY', '1', 1, 'M');
$$);
