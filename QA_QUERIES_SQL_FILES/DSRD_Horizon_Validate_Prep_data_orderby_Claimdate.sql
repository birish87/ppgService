
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DSRD_Horizon_Validate_Prep_data_orderby_Claimdate', $$select "GeminiTransactionID" ,fill_type,"ChangeType" ,mml_record_id , "AnnualTotalSavings", "ReportDate", 
"ClaimDrug" ,"ClaimDate"  from reporting.rpt_hzn_dsrd_claim_gpi_outcome_prep_data rhdcgopd 
where date("ReportDate")=current_timestamp::date order by "ClaimDate" desc$$);
