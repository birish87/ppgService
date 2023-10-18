
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_Horizon_Tier2_DifferentDOS_Insert', $$
Delete from reporting.rpt_hzn_claim_history;
Delete from reporting.rpt_hzn_ddp_claim_gpi_outcome_prep_data;
INSERT INTO reporting.rpt_hzn_claim_history
(id,patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(200,'016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', date_trunc('month', current_date - interval '1' month) + interval '15 DAY', date_trunc('month', current_date - interval '1' month) + interval '15 DAY', '010920200104', '1427091255', '68968201001', 'Pexeva 10mg Tablet', 'Y', 'O', 46, 30.0, 15, '00', '58160060300310', '58160034', '5816', 10.0, 10.0, date_trunc('month', current_date - interval '1' month) + interval '15 DAY', 'B', 1, 'M');
INSERT INTO reporting.rpt_hzn_claim_history
(id,patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(400,'016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', date_trunc('month', current_date - interval '1' month) + interval '18 DAY', current_date - interval '1' month) + interval '18 DAY', '010920200104', '1427091255', '68968201001', 'Pexeva 10mg Tablet', 'Y', 'O', 46, 30.0, 15, '00', '58160060300310', '58160034', '5816', 10.0, 10.0, date_trunc(current_date - interval '1' month) + interval '18 DAY', 'B', 1, 'M');
$$);
