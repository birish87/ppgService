
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('update_bsc_payer_EHR', $$update payers set med_source='ehr' where name = 'BSC'$$);
