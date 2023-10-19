
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_Horizon_Tier1_Setup2', $$update rpt_hzn_claim_history rhch
set date_of_service = date_trunc('month', current_date)
where new_patient_identifier in 
('hznprj000710422221957-11-16',
'hznprj000710422221957-11-17',
'hznprj000710433331986-04-28',
'hzrxprj000710411111956-12-18');


update rpt_hzn_claim_history rhch
set inserted_at = date_trunc('month', current_date)
where new_patient_identifier in 
('hznprj000710422221957-11-16',
'hznprj000710422221957-11-17',
'hznprj000710433331986-04-28',
'hzrxprj000710411111956-12-18');


update rpt_hzn_claim_history rhch set date_of_service = date_trunc('month', current_date) - '10 day'::interval where patient_identifier ='016499hzrxprj000710422221957-11-16' and med_ndc ='68180055809';
update rpt_hzn_claim_history rhch set inserted_at = date_trunc('month', current_date) - '10 day'::interval where patient_identifier ='016499hzrxprj000710422221957-11-16' and med_ndc ='68180055809';

delete from rpt_hzn_ddp_claim_gpi_switches;
$$);
