
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('dtpTransactionReportQuerySeed', $$create table temp_alt_med_list as
select distinct pm.beacon_transaction_id, pm.name, pm.ndc,pl.specific_product_id,pe.concept_name,pm.quantity,pm.days_supply,pm.total_savings,pm.patient_savings, pbmm.status_code, row_number() over (partition by pm.beacon_transaction_id order by pm.id) as altorder
from public.priced_medications pm
join public.beacon_transactions bt on pm.beacon_transaction_id = bt.id
join public.product_lookup pl on pm.ndc = pl.ndc
join public.product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
join public.pbm_logs pbml on bt.request_id = pbml.request_id
left join public.pbm_medications pbmm on pbml.id = pbmm.pbm_log_id and pm.ndc = pbmm.ndc
where pm.chosen_med = false and pm.alternate_pharmacy = false and pm.ehr_presented = true
and pm.inserted_at between (now() - '9 day'::interval)::timestamp::date and (now() + '2 day'::interval)::timestamp::date;

create table temp_prescription_orders as
select distinct ei.ehr_organization_id,dei.inserted_at,ic.bin, ic.pcn, eip.cardholder_id, ep.dob, ep.first_name,em.ndc,pl.specific_product_id,pe.concept_name,dei.institution_id
from public.dtp_encounter_infos dei
join public.encounter_infos ei on dei.encounter_info_id = ei.id
join public.encounter_medications em on dei.encounter_info_id = em.encounter_info_id
join public.encounter_patients ep on ei.encounter_patient_id = ep.id
join public.encounter_prescribers epr on ei.encounter_prescriber_id = epr.id
join public.encounter_insurance_policies eip on ep.id = eip.encounter_patient_id
join public.insurance_companies ic on eip.insurance_company_id = ic.id
join public.product_lookup pl on em.ndc = pl.ndc
join public.product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
where (dei.transaction_type = 'P' or dei.transaction_type = 'p') and dei.inserted_at between (now() - '9 day'::interval)::timestamp::date and (now() + '1 day'::interval)::timestamp::date;$$);
