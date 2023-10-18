
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRD_Horizon_DOS_Not_In_ReportingMonth', $$Delete from reporting.rpt_hzn_claim_history;
INSERT INTO public.rpt_hzn_claim_history(patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES('016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', NOW() - INTERVAL '20 DAY', NOW() - INTERVAL '50 DAY', '010920200104', '1427091255', '00378425491', 'Lamotrigine 200mg Tablet', 'N', 'Y', 1368, 60.0, 30, '00', '72600040000340', '72600040', '7260', 0.83, 1.94, NOW() - INTERVAL '20 DAY', 'B', 1, 'M');
$$);
