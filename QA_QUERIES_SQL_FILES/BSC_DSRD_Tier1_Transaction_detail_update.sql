
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Tier1_Transaction_detail_update', $$update reporting.rpt_dsrd_transaction_detail rdtd set published_date = '2023-08-30 19:00:00'
where transaction_id = 'D-QTFA4-91GUS';$$);
