
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_MostRecentDSRpublisheddate_isselected', $$Delete from rpt_bsc_claim_history;
Delete from rpt_bsc_dsr_claim_gpi_outcome_prep_data;
update rpt_dsrd_transaction_detail set published_date= published_date::date + interval '1 day' where transaction_id='D-QTFA4-91GUS' and dsrd_med_ndc='00065027515';
INSERT INTO public.rpt_bsc_claim_history(patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES('00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH', '000012285355', '1609963818', '50383023210', 'Dorzolamide 2% Ophth Solution', 'N', 'O', 9268, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802340102020', '86802340', '8680', 5.0, 8.24, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');
$$);
