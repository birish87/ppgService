
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('update_bsc_payer_aaa_parameters', $$update payers set minimum_stale_days= 1,minimum_interval_days= 5,include_preferred_medications= true,annual_total_savings_threshold= 250,include_lowest_tier_medications=true,annual_patient_savings_threshold=100 where name = 'BSC' $$);
