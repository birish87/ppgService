
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRP_BSC_Tier1_After_Tier2_Insert', $$Delete from rpt_bsc_claim_history;
Delete from rpt_bsc_dsr_claim_gpi_outcome_prep_data;



----INSERT INTO public.rpt_bsc_claim_history
----(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
---VALUES(13, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'Tier 2 ', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', '000012285355', '1578544474', '01', '63304019230', 'Desvenlafaxine 100mg ER Tablet', 'Y', 'N', 20804, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180020007540', 5.0, 52.22, date_trunc('month', current_date - interval '1' month)+ interval '15 DAY', '1', 1, 'M');


INSERT INTO public.rpt_bsc_claim_history
(id, patient_identifier, new_patient_identifier, carrier_id, account_id, group_id, adjudication_datetime, date_of_service, prescription_service_reference_number, service_provider_id, service_provider_id_qualifier, med_ndc, med_name, med_brand, med_msc, specific_product_id, concept_name, quantity_dispensed, days_supply, fill_number, gpi_14, patient_cost, total_cost, inserted_at, transaction_code, "row_number", med_type)
VALUES(14, '00433677993333910217343001970-01-01', 'bsc910217343001970-01-01', 'Tier 1 ', NULL, 'E00010022000CMCM0002', date_trunc('month', current_date - interval '1' month)+ interval '18 DAY', date_trunc('month', current_date - interval '1' month)+ interval '18 DAY', '000012285355', '1578544474', '01', '00093914701', 'Venlafaxine 25mg Tablet', 'N', 'Y', 15382, 'estrogens, excluding hormonal contraceptives', 30.0, 90, '01', '58180090107020', 5.0, 52.22, date_trunc('month', current_date - interval '1' month)+ interval '18 DAY', '1', 1, 'M');

INSERT INTO public.rpt_bsc_dsr_claim_gpi_outcome_prep_data
("ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ExistingDrug", "ExistingDrugQuantity", "ExistingDrugDaysSupply", "ExistingDrugBrand", "ExistingDrugNDC", "ExistingDrugPA", "ExistingDrugSPID", "ExistingDrugConceptName", "ExistingDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID", "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity", "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", "RunName", uid, "ChangeType", org, "ProductLine", "Alt1Drug", "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName", "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand", "Alt3DrugNDC", "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ExistingMedInternalID", requested_existing_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi, requested_existing_patient_pay_amount, requested_existing_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost, alt3_patient_pay_amount, alt3_total_cost, carrier_id, account_id, group_id, requested_existing_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings", line_of_business, fill_type, published_date, mml_record_id, stop_tracking, id, "PA_avoided")
VALUES(current_timestamp, 'P-FSJBT-XIK5F', '004336', '77993333', '2022-10-28 14:58:41.858', 'Smith, John', '1508977059', 'Desvenlafaxine Succinate ER 25 MG Tablet ER 24HR', 30.0, 30, 'N', 70436003604, 'N', 22677, 'serotonin norepinephrine reuptake inhibitor antidepressants, snris - level 1', 'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Desvenlafaxine 100mg ER Tablet', 'Y', '2022-11-16', 63304019230, 20804, 'serotonin norepinephrine reuptake inhibitor antidepressants, snris - level 3', 30.0, 90, 'M', 40.55555555555556, 1036.8838888888888, 202211, NULL, 'P-FSJBT-XIK5F70436003604', 'Tier 2', 'BSC', 'DSR-P', 'Venlafaxine HCl ER 37.5 MG Capsule ER 24HR', 'Venlafaxine Hydrochloride Oral capsule, extended release', 'N', 93738456, 'N', 1411, 'serotonin norepinephrine reuptake inhibitor antidepressants, snris - level 1', 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3188287, '58180020207510', '58180020007540', '58180090107020', NULL, NULL, 5.0, 102.63, 5.0, 52.22, 3.16, 3.16, NULL, NULL, NULL, NULL, 'Tier 2 ', NULL, 'E00010022000CMCM0002', 'Antidepressants - SNRIs', 'Antidepressants - SNRIs', 30.416666666666668, 777.6629166666667, 'Commercial', 'New', NULL, 13, false, 1720, NULL);
$$);
