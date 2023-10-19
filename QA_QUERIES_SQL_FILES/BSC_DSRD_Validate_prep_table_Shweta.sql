
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_Validate_prep_table_Shweta', $$select "GeminiTransactionID","ExistingDrug","ExistingDrugPA","ClaimDrug","AltDrug","AltDrugPA","ChangeType","ProductLine",fill_type,mml_record_id,"PA_avoided"
from rpt_bsc_dsr_claim_gpi_outcome_prep_data where date("ReportDate")=current_timestamp::date order by "ReportDate" desc$$);
