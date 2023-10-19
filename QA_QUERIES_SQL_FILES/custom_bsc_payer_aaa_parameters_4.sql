
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('custom_bsc_payer_aaa_parameters_4', $$update payers set minimum_stale_days= 1,minimum_interval_days= 5,include_acute_medications=false,include_preferred_medications= false,annual_total_savings_threshold= 250,include_lowest_tier_medications=false,annual_patient_savings_threshold=100,minimum_medication_patient_savings=20,minimum_medication_total_savings=100 where name = 'BSC' $$);
