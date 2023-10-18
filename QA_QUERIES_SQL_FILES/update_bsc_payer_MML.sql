
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('update_bsc_payer_MML', $$update payers set med_source='mml' where name = 'BSC'$$);
