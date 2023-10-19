
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('dtpTransactionReportQueryDropTmpTables', $$drop table temp_alt_med_list;
drop table temp_prescription_orders$$);
