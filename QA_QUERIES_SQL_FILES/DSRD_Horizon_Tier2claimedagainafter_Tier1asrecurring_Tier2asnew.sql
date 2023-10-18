
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRD_Horizon_Tier2claimedagainafter_Tier1asrecurring_Tier2asnew', $$delete from reporting.rpt_hzn_claim_history;
delete from reporting.rpt_hzn_dsrd_claim_gpi_outcome_prep_data;
INSERT INTO reporting.rpt_hzn_dsrd_claim_gpi_outcome_prep_data
("ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ExistingDrug", "ExistingDrugQuantity", "ExistingDrugDaysSupply", "ExistingDrugBrand", "ExistingDrugNDC", "ExistingDrugPA", "ExistingDrugSPID", "ExistingDrugConceptName", "ExistingDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID", "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity", "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", "RunName", uid, "ChangeType", org, "ProductLine", "Alt1Drug", "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName", "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand", "Alt3DrugNDC", "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ExistingMedInternalID", requested_existing_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi, requested_existing_patient_pay_amount, requested_existing_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost, alt3_patient_pay_amount, alt3_total_cost, patient_name, member_id, carrier_id, account_id, group_id, requested_existing_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings", line_of_business, fill_type, published_date, mml_record_id)
VALUES('2022-03-03 16:35:20.456', 'D-HEYN4-MSKBD', '016499', 'HZRX', '2021-12-01 22:31:01.434', 'Johnson, ', '1386878445', 'LAMICTAL 200mg Tablet', 60.0, 30, 'Y', 173064460, 'N', 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 'M', 'Lamotrigine 200mg Tablet', 'N', 55111022360, 'N', 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, 'Lamotrigine 200mg Tablet', 'N', '2022-02-04', 378425491, 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, 'M', 415.735, 13619.123333333333, 202202, NULL, 'D-HEYN4-MSKBD173064460', 'Tier 1', 'BSS Org', 'DSR-D', 'Lamotrigine 200mg Tablet', 'Lamotrigine Oral tablet', 'N', 55111022360, 'N', 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, 'Lamotrigine 200mg ODT', 'Lamotrigine Oral disintegrating tablet', 'N', 49884048711, 'N', 16500, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2623594, '72600040000340', '72600040000340', '72600040000340', '72600040007250', NULL, 35.0, 1121.32, 0.83, 1.94, 10.0, 12.01, 10.0, 508.07, NULL, NULL, 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', 'Anticonvulsants - Lamotrigine', 'Anticonvulsants - Lamotrigine', 415.735, 13619.123333333333, 'HORIZON PDP', 'Recurring', '2021-12-06', 703);
INSERT INTO reporting.rpt_hzn_dsrd_claim_gpi_outcome_prep_data
("ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ExistingDrug", "ExistingDrugQuantity", "ExistingDrugDaysSupply", "ExistingDrugBrand", "ExistingDrugNDC", "ExistingDrugPA", "ExistingDrugSPID", "ExistingDrugConceptName", "ExistingDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID", "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity", "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", "RunName", uid, "ChangeType", org, "ProductLine", "Alt1Drug", "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName", "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand", "Alt3DrugNDC", "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ExistingMedInternalID", requested_existing_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi, requested_existing_patient_pay_amount, requested_existing_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost, alt3_patient_pay_amount, alt3_total_cost, patient_name, member_id, carrier_id, account_id, group_id, requested_existing_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings", line_of_business, fill_type, published_date, mml_record_id)
VALUES('2022-03-03 16:36:47.935', 'D-HEYN4-MSKBD', '016499', 'HZRX', '2021-12-01 22:31:01.434', 'Johnson, ', '1386878445', 'LAMICTAL 200mg Tablet', 60.0, 30, 'Y', 173064460, 'N', 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Lamotrigine 200mg ER Tablet', 'N', '2022-02-03', 52817024330, 16562, 'anticonvulsants, miscellaneous - lamotrigine - 4', 60.0, 30, 'M', 415.735, 13619.123333333333, 202202, NULL, 'D-HEYN4-MSKBD173064460', 'Tier 2', 'BSS Org', 'DSR-D', 'Lamotrigine 200mg Tablet', 'Lamotrigine Oral tablet', 'N', 55111022360, 'N', 1368, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, 'Lamotrigine 200mg ODT', 'Lamotrigine Oral disintegrating tablet', 'N', 49884048711, 'N', 16500, 'anticonvulsants, miscellaneous - lamotrigine - 6', 60.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2623594, '72600040000340', '72600040007540', '72600040000340', '72600040007250', NULL, 35.0, 1121.32, 0.83, 1.94, 10.0, 12.01, 10.0, 508.07, NULL, NULL, 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', 'Anticonvulsants - Lamotrigine', 'Anticonvulsants - Lamotrigine', 311.80125, 10214.342499999999, 'HORIZON PDP', 'New', '2021-12-06', 702);
INSERT INTO reporting.rpt_hzn_claim_history(id,patient_identifier, new_patient_identifier, patient_name, member_id, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(704,'016499hzrxprj000710422221957-11-16', 'hznprj000710422221957-11-16', 'RTBCGEMHMN7,TURQUFEM1', 'PRJ00071042222', 'HZRX', 'JUMBO', 'ENJS5993', NOW() - INTERVAL '1 Month'- Interval '1 Day', NOW() - INTERVAL '1 Month' + interval '1 day', '010920200104', '1427091255', '52817024330', 'Lamotrigine 200mg ER Tablet', 'N', 'Y', 16562, 60.0, 30, '00', '72600040007540', '72600040', '7260', 0.83, 1.94, NOW() - INTERVAL '1 MONTH', 'B', 1, 'M');

$$);