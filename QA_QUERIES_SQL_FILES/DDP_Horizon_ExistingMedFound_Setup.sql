
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_Horizon_ExistingMedFound_Setup', $$update rpt_hzn_claim_history rhch
set date_of_service = date_trunc('month', current_date)
where patient_identifier ='016499hzrxprj000710422221957-11-16'
--and med_ndc ='55289098490';

update rpt_hzn_claim_history rhch
set inserted_at = date_trunc('month', current_date)
where patient_identifier ='016499hzrxprj000710422221957-11-16'
--and med_ndc ='55289098490';

update rpt_hzn_claim_history rhch
set date_of_service = date_trunc('month', current_date) - '10 day'::interval
where patient_identifier ='016499hzrxprj000710422221957-11-16'
and med_ndc ='00006020754';

update rpt_hzn_claim_history rhch
set inserted_at = date_trunc('month', current_date) - '10 day'::interval
where patient_identifier ='016499hzrxprj000710422221957-11-16'
and med_ndc ='00006020754';

delete from rpt_hzn_ddp_claim_gpi_switches;
$$);
