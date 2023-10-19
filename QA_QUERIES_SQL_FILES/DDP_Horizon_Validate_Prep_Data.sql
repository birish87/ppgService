
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_Horizon_Validate_Prep_Data', $$select "ReportDate", "GeminiTransactionID",
"TransactionDate",
"ClaimDrug",
"ClaimDate",
"ChangeType",
"ProductLine",
"requested_chosen_gpi",
"mml_gpi",
"alt1_gpi",
"alt2_gpi",
"alt3_gpi",
"fill_type",
"mml_record_id",
"PA_avoided" ,
mml_record_id
from reporting.rpt_hzn_ddp_claim_gpi_outcome_prep_data
where date("ReportDate")=current_timestamp::date order by "ReportDate" desc;$$);
