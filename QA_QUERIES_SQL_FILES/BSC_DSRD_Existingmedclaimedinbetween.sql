
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Existingmedclaimedinbetween', $$Delete from reporting.rpt_bsc_claim_history;

Delete from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data;

INSERT INTO reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data("ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ExistingDrug", "ExistingDrugQuantity", "ExistingDrugDaysSupply", "ExistingDrugBrand", "ExistingDrugNDC", "ExistingDrugPA", "ExistingDrugSPID", "ExistingDrugConceptName", "ExistingDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID", "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity", "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", "RunName", uid, "ChangeType", org, "ProductLine", "Alt1Drug", "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName", "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand", "Alt3DrugNDC", "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ExistingMedInternalID", requested_existing_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi, requested_existing_patient_pay_amount, requested_existing_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost, alt3_patient_pay_amount, alt3_total_cost, carrier_id, account_id, group_id, requested_existing_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings", line_of_business, fill_type, published_date, mml_record_id, stop_tracking)
VALUES('2022-03-08 15:11:42.784', 'D-QTFA4-91GUS', '004336', '77993333', '2021-07-30 13:20:13.991', 'CHANGA, ', '1134165195', 'Azopt 1% Ophthalmic Suspension', 30.0, 30, 'Y', 65027515, 'N', 20900, 'carbonic anhydrase inhibitors, ophthalmic', 'M', 'Dorzolamide 2% Ophth Solution', 'N', 50383023210, 'N', 9268, 'carbonic anhydrase inhibitors, ophthalmic', 10.0, 30, 'Dorzolamide 2% Ophth Solution', 'N', '2022-02-08', 50383023210, 9268, 'carbonic anhydrase inhibitors, ophthalmic', 20.0, 10, 'M', 2622.16, 11820.889999999998, 202202, NULL, 'D-QTFA4-91GUS65027515', 'Tier 1', 'BSS Org', 'DSR-D', 'Dorzolamide 2% Ophth Solution', 'Dorzolamide Hydrochloride Ophthalmic drops, solution', 'N', 50383023210, 'N', 9268, 'carbonic anhydrase inhibitors, ophthalmic', 10.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2350367, '86802320001820', '86802340102020', '86802340102020', NULL, NULL, 230.52, 979.8199999999999, 5.0, 8.24, 5.0, 8.24, NULL, NULL, NULL, NULL, NULL, NULL, 'E00010022000CMCM0002', 'Ophthalmic Agents - Carbonic Anhydrase Inhibitors', 'Ophthalmic Agents - Carbonic Anhydrase Inhibitors', 2622.16, 11820.889999999998, 'CalPERS', 'New', '2021-12-30', 344, false);

INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(345,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH', NOW()- INTERVAL '1 MONTH'+interval'1 day', '000012285355', '1609963818', '50383023210', 'Dorzolamide 2% Ophth Solution', 'N', 'O', 9268, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802340102020', 5.0, 8.24, NOW()-INTERVAL'1 MONTH', '1', 1, 'M');
INSERT INTO reporting.rpt_bsc_claim_history(id,patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, gpi_8, gpi_4, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(346,'00433677993333910217345001970-01-02', 'bsc910217345001970-01-02', NULL, NULL, 'E00010022000CMCM0002', now()- INTERVAL '1 MONTH'+interval '2 day', now()- INTERVAL '1 MONTH'+interval '2 day', '000012285355', '1609963818', '00065027515', 'Azopt 1% Ophthalmic Suspension', 'Y', 'O', 20900, 'psychostimulants, amphetamines, extended release - level 1', 20.0, 10, '01', '86802320001820', 230.52, 979.82, now()- INTERVAL '1 MONTH'+interval '1 day', '1', 1, 'M');$$);