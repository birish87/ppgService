
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_existingmedclaimedafter_tier1new', $$Delete from rpt_bsc_claim_history;
INSERT INTO public.rpt_bsc_claim_history(patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES('00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH'+ interval '2 day', NOW()- INTERVAL '1 MONTH'+interval '2 day', '000012285355', '1609963818', '00065027515', 'Azopt 1% Ophthalmic Suspension', 'Y', 'O', 20900, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802320001820', '86802320', '8680', 230.52, 979.82, NOW()-INTERVAL'1 MONTH'+interval '1 day', '1', 1, 'M');$$);
