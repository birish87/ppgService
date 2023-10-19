
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRD_Horizon_ResultingMed1Tier1DOS_Before_ResultingMed2Tier2DOS', $$delete from reporting.rpt_hzn_claim_history;
delete from reporting.rpt_hzn_dsrd_claim_gpi_outcome_prep_data;
INSERT INTO reporting.rpt_hzn_claim_history
(id,patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(1,'016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', date_trunc('day', now()) - interval '1 MONTH' , now() - interval '1 MONTH', '010920200104', '1427091255', '00378425491', 'Lamotrigine 200mg Tablet', 'N', 'Y', 1368, 60.0, 30, '00', '72600040000340', '72600040', '7260', 0.83, 1.94,  now() - interval '1 MONTH', 'B', 1, 'M');
INSERT INTO reporting.rpt_hzn_claim_history
(id,patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(2,'016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', date_trunc('day', now()) - interval '1 MONTH' ,  now() - interval '1 MONTH' + INTERVAL '1 DAY', '010920200104', '1427091255', '52817024330', 'Lamotrigine 200mg ER Tablet', 'N', 'Y', 16562, 60.0, 30, '00', '72600040007540', '72600040', '7260', 0.83, 1.94,  now() - interval '1 MONTH', 'B', 1, 'M');
$$);
