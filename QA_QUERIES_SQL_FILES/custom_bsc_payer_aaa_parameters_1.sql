
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('custom_bsc_payer_aaa_parameters_1', $$update payers set minimum_stale_days= 1,minimum_interval_days= 5,include_acute_medications=true,include_preferred_medications= true,annual_total_savings_threshold= 250,include_lowest_tier_medications=true,annual_patient_savings_threshold=100 where name = 'BSC' $$);
