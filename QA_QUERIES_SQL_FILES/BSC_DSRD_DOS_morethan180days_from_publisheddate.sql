
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_DOS_morethan180days_from_publisheddate', $$Delete from reporting.rpt_bsc_claim_history;
Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;
INSERT INTO reporting.rpt_bsc_claim_history
(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(40,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02x', NULL, NULL, 'E00010022000CMCM0002', now()-interval '1 month', now()-interval '1 month', '000012285355', '1609963818', '00006054354', 'Zocor 80mg Tablet', 'N', 'Y', 184, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '39400075000360', 100.0, 100.0, now()- interval'1 month', '1', 1, 'M');
$$);
