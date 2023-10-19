
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Validate_prep_table', $$select "ReportDate" ,"ProductLine", fill_type ,"GeminiTransactionID","TransactionDate","ChangeType","ClaimDrug" ,"ClaimDate" ,"ReportDate" ,
"AnnualTotalSavings",stop_tracking ,mml_record_id,published_date
from reporting.rpt_bsc_dsr_claim_gpi_outcome_prep_data where date("ReportDate")=current_timestamp::date order by  mml_record_id desc$$);
