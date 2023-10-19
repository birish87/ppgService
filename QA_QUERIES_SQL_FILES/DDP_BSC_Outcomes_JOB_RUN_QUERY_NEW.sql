
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_BSC_Outcomes_JOB_RUN_QUERY_NEW', $$begin;
------------Begin raw dataset of DDP and dedup transaction within same date----------------
--drop table if exists temp_ddp_dedup;

create temp table temp_ddp_dedup as 
select
	max(bt.id) as id
	,ic.bin
	,ic.pcn
	,phy.npi
	,lower(trim(ip.cardholder_id)) as cardholder_id
	,pat.birthdate::date
	,pm.ndc
	,pm.quantity
	,pharm.ncpdp_id
	,bt.inserted_at::date
from public.beacon_transactions bt
	join public.patients pat 
		on bt.patient_id = pat.id
	join public.priced_medications pm 
		on bt.id = pm.beacon_transaction_id
		and pm.chosen_med = true
	join public.providers phy 
		on bt.provider_id = phy.id
	join public.organizations org 
		on phy.organization_id = org.id
	join public.insurance_policies ip 
		on pat.id = ip.patient_id
	join public.insurance_companies ic 
		on ip.insurance_company_id = ic.id
	join public.payers payer 
		on ic.payer_id = payer.id
	join pbm_logs pl 
		on bt.request_id = pl.request_id
		and pl.is_final = true
	left join pharmacies pharm 
		on pm.pharmacy_id = pharm.id
	left join surescripts_ddps ssddp 
		on bt.id = ssddp.beacon_transaction_id
	left join surescripts_crosswalks sc 
		on sc.account_id = ssddp.sender_tertiary_identification
where
	lower(payer."name") = 'bsc'
	and org.ehr_organization_id not in ('1')
	and bt.pbm_called = true
	-- called PBM for info
	and (sc.ehr_name = 'ALL'
		or 'ALL' = 'ALL' )
	--'EPIC - SUTTER HEALTH'
	and cast(bt.inserted_at::date +'120 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date)
group by
	ic.bin
	,ic.pcn
	,phy.npi
	,lower(trim(ip.cardholder_id))
	,pat.birthdate::date
	,pm.ndc
	,pm.quantity
	,pharm.ncpdp_id
	,bt.inserted_at::date
;

create index temp_ddp_dedup_idx1 on
temp_ddp_dedup(id);

------------Begin Member ID Matching ------------------------- 
--drop table if exists temp_ddp;

create temp table temp_ddp as 
select
	tp.*
	,lower(trim(pat.first_name)) as first_name
	,lower(trim(pat.last_name)) as last_name
	,case
		when lower(trim(pat.sex)) = 'male' then '1'
		when lower(trim(pat.sex)) = 'female' then '2'
		when lower(trim(pat.sex)) = 'unknown' then '0'
		else null
	end as gender
from temp_ddp_dedup tp
	join public.beacon_transactions bt 
		on bt.id = tp.id
	join public.patients pat 
		on bt.patient_id = pat.id
;
/*********************************************marcsu to look to match dsr index**************************/
create index temp_ddp_idx1 
	on temp_ddp(id);

create index temp_ddp_idx2 
	on temp_ddp(birthdate,last_name,first_name);
--Cleanup temp data
drop table if exists temp_ddp_dedup;
 
--drop table if exists temp_cm;     
create temp table temp_cm as
select lower(trim(cm.cardholder_id)) as cardholder_id
,cm.date_of_birth::date
,lower(trim(cm.patient_last_name)) as patient_last_name
,lower(trim(cm.patient_first_name)) as patient_first_name
,patient_gender_code
from bsc_claims cm
where cm.date_of_service::date between cast((date_trunc('month', current_date)- '1 second'::interval)- '485 day'::interval as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
group by 1,2,3,4,5
;
create index "_I_temp_cm_idx2" on temp_cm using btree(date_of_birth,cardholder_id)
;
create index "_I_temp_cm_idx1" on temp_cm using btree(date_of_birth,patient_last_name,patient_first_name)
;

-- List of DOB & full last name & first name first 3 characters combo with 1 cardholder ID only
--drop table if exists temp_fn;     
create temp table temp_fn as
select cl.date_of_birth,cl.patient_last_name, cl.patient_first_name_substring, cl.patient_gender_code
from (select birthdate, last_name,substring(first_name, 1, 3) as patient_first_name_substring,gender,COUNT(distinct cardholder_id) as fn_cnt
		from temp_ddp 
		group by 1,2,3,4) al
join (select date_of_birth, patient_last_name, substring(patient_first_name, 1, 3) as patient_first_name_substring,patient_gender_code,COUNT(distinct cardholder_id) as fn_cnt 
		from temp_cm
		group by 1,2,3,4) cl on al.birthdate = cl.date_of_birth and al.last_name = cl.patient_last_name and al.patient_first_name_substring = cl.patient_first_name_substring and al.gender = cl.patient_gender_code
where al.fn_cnt = 1 and cl.fn_cnt = 1
group by 1,2,3,4
;
create index "_I_temp_fn_idx1" on temp_fn using btree(date_of_birth,patient_last_name,patient_first_name_substring,patient_gender_code)
;

--drop table if exists tmp_match_cardholderid;
create temp table tmp_match_cardholderid as
select distinct td.id, trim(cm.cardholder_id) as cardholder_id
from temp_ddp td
left join temp_fn tf on tf.date_of_birth = td.birthdate 
	and tf.patient_last_name = td.last_name 
	and tf.patient_first_name_substring = substring(td.first_name, 1, 3) 
	and tf.patient_gender_code = td.gender
join temp_cm cm on td.birthdate = cm.date_of_birth 
	and (td.cardholder_id = cm.cardholder_id or
			(regexp_replace(td.cardholder_id, '^0+', '') = cm.cardholder_id) or 
			(length(regexp_replace(td.cardholder_id, '^0+', '')) = 9 and regexp_replace(td.cardholder_id, '^0+', '')||'00' = cm.cardholder_id) or
			(substring(td.cardholder_id, 1, length(td.cardholder_id)-2) = cm.cardholder_id) or 
			(regexp_replace(substring(td.cardholder_id, 1, length(td.cardholder_id)-2), '^0+', '') = cm.cardholder_id) or
			(tf.date_of_birth is not null and tf.patient_last_name = cm.patient_last_name and tf.patient_first_name_substring = substring(cm.patient_first_name, 1, 3) and  tf.patient_gender_code = cm.patient_gender_code)
		)
group by 1,2
;

create index tmp_match_cardholderid_idx1 on tmp_match_cardholderid(id);
------------End Member ID Matching ------------------------- 

------------begin Alter List ------------------------- 
--drop table if exists tmp_priced_medications;
create temp table tmp_priced_medications as	
select pm.*
from temp_ddp tp
join public.priced_medications pm on tp.id = pm.beacon_transaction_id
;
create index tmp_priced_medications_idx1 on tmp_priced_medications(beacon_transaction_id,chosen_med,alternate_pharmacy,ehr_presented);
create index tmp_priced_medications_idx2 on tmp_priced_medications(id);
create index tmp_priced_medications_idx3 on tmp_priced_medications(ndc);

-- Create alternative list temp table
--drop table if exists temp_pre_altermedlist;
create temp table temp_pre_altermedlist as	
select distinct 
lower('bsc' || trim(tmc.cardholder_id) || td.birthdate::date)as patient_identifier 
,td.inserted_at::date as report_created_date
,pm.beacon_transaction_id 
,pm.id as med_id
,pm."name" as med_display_name
,pm.ndc as med_ndc
,case
	when pl.brand = true then 'Y'
	when pl.brand = false then 'N'
end as med_brand
,pl.multi_source_code as med_msc
,pl.specific_product_id as med_specific_product_id
,case
	when pl.maintenance = true then 'M'	--Maintenance
	when pl.maintenance = false and pl.periodic = true then 'P'	--Periodic
	when pl.maintenance = false and pl.periodic = false then 'A'	--Acute
end as med_med_type
,pm.quantity as med_quantity
,pm.days_supply as med_days_supply
,pm.pharmacy_type as med_pharmacy_type
,case 
	when pm3.ndc is not null then true
	else false
 end as med_has_fulfillment
,case 
	when pm.days_supply > 30 then pm.days_supply
	else 30
end as med_calculation_days_supply
,pl.gpi as med_gpi_14 --Chosen Med GPI
,substring(pl.gpi,1,12) as med_gpi_12 --Chosen Med GPI12
,pl.super_concept as med_super_concept
,pm.patient_pay_amount as med_patient_pay_amount
,pm.total_cost as med_total_cost
,pm2.id as alt_id
,pm2."name" as alt_display_name
,case
	when pl2.brand = true then 'Y'
	when pl2.brand = false then 'N' 
end as alt_brand
,pl2.multi_source_code as alt_msc
,case 
	when pm2.prior_auth_needed = true then 'Y'
	when pm2.prior_auth_needed = false then 'N' 
end as alt_prior_auth_needed
,pm2.ndc as alt_ndc
,pl2.specific_product_id as alt_specific_product_id
, case
	when pl2.maintenance = true then 'M'	--Maintenance
	when pl2.maintenance = false and pl2.periodic = true then 'P'	--Periodic
	when pl2.maintenance = false and pl2.periodic = false then 'A'	--Acute
end as alt_med_type
,pl2.concept_name as alt_concept_name
,pl2.gpi as alt_gpi_14 --Alt Med GPI14
,substring(pl2.gpi,1,12) as alt_gpi_12 --Alt Med GPI12
,pm2.quantity as alt_quantity
,pm2.days_supply as alt_days_supply
,pl2.generic_drug_item_name as alt_generic_name
,pm2.patient_pay_amount as alt_patient_pay_amount
,pm2.total_cost as alt_total_cost
,pm2.patient_savings as alt_annual_patient_savings_v1
,pm2.total_savings as alt_annual_total_savings_v1
,pm2.pharmacy_type as alt_pharmacy_type
,case 
	when pm4.ndc is not null then true
	else false
 end as alt_has_fulfillment
from temp_ddp td
join tmp_match_cardholderid tmc on tmc.id = td.id
join tmp_priced_medications pm on td.id = pm.beacon_transaction_id and pm.chosen_med = true
join product_lookup pl on pm.ndc = pl.ndc
join tmp_priced_medications pm2 on td.id = pm2.beacon_transaction_id and pm2.chosen_med = false and pm2.alternate_pharmacy = false and pm2.ehr_presented = true
join product_lookup pl2 on pm2.ndc =pl2.ndc
left join rpt_bsc_ddp_claim_gpi_outcome_prep_data rhdcgop on pm.id = rhdcgop."ChosenMedInternalID" and rhdcgop.fill_type = 'New'
--Alternative fulfillment for chosen med
left join tmp_priced_medications pm3 on td.id = pm3.beacon_transaction_id and pm3.chosen_med = false and pm3.alternate_pharmacy = true and pm3.ehr_presented = true and pm.ndc = pm3.ndc
--Alternative fulfillment for alternative med
left join tmp_priced_medications pm4 on td.id = pm4.beacon_transaction_id and pm4.chosen_med = false and pm4.alternate_pharmacy = true and pm4.ehr_presented = true and pm2.ndc = pm4.ndc
where rhdcgop."ChosenMedInternalID" is null -- not identified as CI in the past
;

-- Insert alternative for switch analysis
--drop table if exists temp_altermedlist;
create temp table temp_altermedlist as
select tpa.*,row_number() over (partition by tpa.beacon_transaction_id,tpa.med_id,tpa.alt_id order by tpa.alt_id) as altrow,dense_rank() over (partition by tpa.beacon_transaction_id order by tpa.alt_id) as alt_order
from temp_pre_altermedlist tpa
;

--Free up memory
drop table if exists temp_pre_altermedlist;


create index "_I_temp_altermedlist_patient_identifier" on temp_altermedlist using btree(patient_identifier,report_created_date,med_gpi_12,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_2" on temp_altermedlist using btree(patient_identifier,report_created_date,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_3" on temp_altermedlist using btree(patient_identifier,report_created_date,med_gpi_12,med_super_concept,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_4" on temp_altermedlist using btree(patient_identifier,report_created_date,med_super_concept)
;
create index "_I_temp_altermedlist_med_id" on temp_altermedlist using btree(med_id)
;
create index "_I_temp_altermedlist_alt_order" on temp_altermedlist using btree(alt_order)
;
------------End Alter List----------------

------------Begin Claim History --------------------
--drop table if exists temp_bsc_claims;
create temp table temp_bsc_claims as
select 
	rbch.patient_identifier
	,rbch.new_patient_identifier
	,rbch.carrier_id
	,rbch.account_id
	,rbch.group_id
	,rbch.adjudication_datetime
	,rbch.date_of_service
	,rbch.prescription_service_reference_number
	,rbch.service_provider_id
	,rbch.med_ndc
	,rbch.med_name
	,rbch.med_brand
	,rbch.med_msc
	,rbch.specific_product_id
	,rbch.quantity_dispensed
	,rbch.days_supply
	,rbch.fill_number
	,rbch.gpi_14
	,rbch.patient_cost
	,rbch.total_cost
	,rbch.inserted_at
	,rbch.transaction_code
	,rbch.med_type
	,rbch.id
	,substring(rbch.gpi_14,1,12) as gpi_12
	,pl.concept_name
	,pl.super_concept as med_super_concept
	,case
	when rbch.days_supply > 30 then rbch.days_supply
	else 30
	end as calculation_days_supply
	,pl.manufacturer_name
	,case 
		when pharm.provider_type_code = '05' 
			and (pharm.legal_name ilike '%cvs%' or pharm.legal_name ilike '%caremark%' or pharm.dba_name ilike '%cvs%' or pharm.dba_name ilike '%caremark%')
			and  pharm.legal_name not ilike '%specialty%' 
			and pharm.dba_name not ilike '%specialty%' then 'CVS Mail'
		else null
	end as alt_pharmacy_type
from rpt_bsc_claim_history rbch
	join product_lookup pl 
		on rbch.med_ndc = pl.ndc
	left join pharmacies pharm
		on (rbch.service_provider_id_qualifier = '01' and service_provider_id = pharm.npi) or (rbch.service_provider_id_qualifier = '07' and rbch.service_provider_id = pharm.ncpdp_id) or (rbch.service_provider_id_qualifier = '12' and rbch.service_provider_id = pharm.dea) 
where rbch.date_of_service::date between cast((date_trunc('month', current_date)- '1 second'::interval)- '240 day'::interval as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
;

create index "_I_temp_bsc_claims_patient_identifier_gpi12" on temp_bsc_claims using btree(new_patient_identifier,gpi_12)
;
create index "_I_temp_bsc_claims_patient_identifier_dos_gpi12" on temp_bsc_claims using btree(new_patient_identifier,date_of_service,gpi_12)
;
create index "_I_temp_bsc_claims_patient_identifier_dos_med_super_concept" on temp_bsc_claims using btree(new_patient_identifier,date_of_service,med_super_concept,gpi_12)
;
----------- End Claim History ---------------------


------------Begin Reporting-------------
------------Begin identifying ddp with chosen medication claim found ------------------------------------------------
--drop table if exists temp_bsc_chosen_med_found_list;

create temp table temp_bsc_chosen_med_found_list as
select distinct 
	thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.report_created_date
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,null as alt_spid
	,null as alt_med_type
	,null as alt_concept
	,case 
		when alt.med_patient_pay_amount is null then -0.01
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 365)-((thlmc.patient_cost / thlmc.days_supply)* 365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 135)-((thlmc.patient_cost / thlmc.days_supply)* 135))
		else (alt.med_patient_pay_amount-thlmc.patient_cost)
	end as alt_annual_patient_savings 
	,case
		when alt.med_total_cost is null then -0.01
		when lower(alt.med_med_type) = 'm'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) >= (-250::float8 / alt.med_calculation_days_supply)) then (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply))* 365)
		when lower(alt.med_med_type) = 'p'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) >= (-250::float8 / alt.med_calculation_days_supply)) then (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply))* 135)
		when lower(alt.med_med_type) = 'a'
		and ((alt.med_total_cost-thlmc.total_cost) >= -250::float8) then (alt.med_total_cost-thlmc.total_cost)
		when lower(alt.med_med_type) = 'm'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) < (-250::float8 / alt.med_calculation_days_supply)) then ((-250::float8 / alt.med_calculation_days_supply)* 365)
		when lower(alt.med_med_type) = 'p'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) < (-250::float8 / alt.med_calculation_days_supply)) then ((-250::float8 / alt.med_calculation_days_supply)* 135)
		when lower(alt.med_med_type) = 'a'
		and ((alt.med_total_cost-thlmc.total_cost) < -250::float8) then -250::float8
	end as alt_annual_total_savings
	,null as alt_quantity
	,null as alt_days_supply
	,null as alt_order
	,null as most_savings_order
	,thlmc.id as mml_record_id
	,thlmc.med_name as mml_med 
	,thlmc.med_brand as mml_med_brand 
	,thlmc.date_of_service::date as mml_claim_date
	,thlmc.med_ndc as mml_ndc 
	,thlmc.specific_product_id as mml_spid
	,thlmc.concept_name as mml_concept_name
	,thlmc.quantity_dispensed as mml_quantity
	,thlmc.days_supply as mml_days_supply
	,thlmc.med_type as mml_med_type
	,date_part('year', thlmc.date_of_service)::text || LPAD(date_part('month', thlmc.date_of_service)::text, 2, '0') as switch_change_month
	,'Chosen Medication Found' as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.gpi_12 as mml_gpi_12
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,thlmc.med_super_concept as mml_med_super_concept
	,false as is_first_fill
	,case 
		when lower(alt.med_pharmacy_type) = 'retail' and alt.med_has_fulfillment = true and lower(thlmc.alt_pharmacy_type) ='cvs mail' and thc.new_patient_identifier is null then true
		else false
	end as is_alternative_fulfillment
from temp_altermedlist alt
join temp_bsc_claims thlmc 
	on alt.patient_identifier = thlmc.new_patient_identifier
	and (
			(alt.med_gpi_12 is not null
		and thlmc.gpi_12 is not null
		and (alt.med_gpi_12 = thlmc.gpi_12
			and 
							((upper(alt.med_msc) = 'N'
				and upper(thlmc.med_msc) = 'N')
				or (upper(alt.med_msc) = 'M'
					and upper(thlmc.med_msc) = 'M')
					or (upper(alt.med_msc) = 'O'
						and upper(thlmc.med_msc) = 'O')
						or (upper(alt.med_msc) = 'Y'
							and upper(thlmc.med_msc) in ('O', 'Y')))
					)
		-- Chosen Medication & Resulting Medication with same GPI-12s 
			)
		or trim(lower(alt.med_display_name)) = trim(lower(thlmc.med_name))
		-- Chosen Medication & Resulting Medication with same med name
		)
left join temp_bsc_claims thc 
	on alt.patient_identifier = thc.new_patient_identifier
	and (
			(alt.med_gpi_12 is not null
		and thc.gpi_12 is not null
		and (alt.med_gpi_12 = thc.gpi_12
			and 
							((upper(alt.med_msc) = 'N'
				and upper(thc.med_msc) = 'N')
				or (upper(alt.med_msc) = 'M'
					and upper(thc.med_msc) = 'M')
					or (upper(alt.med_msc) = 'O'
						and upper(thc.med_msc) = 'O')
						or (upper(alt.med_msc) = 'Y'
							and upper(thc.med_msc) in ('O', 'Y')))
					)
		-- Chosen Medication & Resulting Medication with same GPI-12s 
			)
		or trim(lower(alt.med_display_name)) = trim(lower(thc.med_name))
		-- Chosen Medication & Resulting Medication with same med name
		)
	and thc.date_of_service::date < alt.report_created_date::date
	and cast(thc.date_of_service::date + '120 day'::interval as date) >= alt.report_created_date::date
	and lower(thc.alt_pharmacy_type) ='cvs mail'
where
	thlmc.date_of_service::date >= alt.report_created_date::date
	--DDP allow same date DOS 
	and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
	--Only claims for previous month
		or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;
-- Create Key table filtering
--drop table if exists temp_bsc_chosen_med_found_keys;

create temp table temp_bsc_chosen_med_found_keys as
select distinct 
	med_id
	,mml_claim_date
from temp_bsc_chosen_med_found_list
;

create index "_I_temp_bsc_chosen_med_found_keys_med_id" 
	on temp_bsc_chosen_med_found_keys
	using btree(med_id,mml_claim_date)
;
---------------End identifying ddp with chosen medication claim found  ------------------------------------------------
---------------Begin Tier 1 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
--drop table if exists temp_new_tier1_prematches;

create temp table temp_new_tier1_prematches as
select distinct 
	thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.report_created_date
	,alt.alt_display_name as alt_med
	,alt.alt_brand
	,alt.alt_prior_auth_needed as alt_pa
	,alt.alt_ndc
	,alt.alt_specific_product_id as alt_spid
	,alt.alt_med_type
	,alt.alt_concept_name as alt_concept
	,case 
		when alt.med_patient_pay_amount is null then -0.01
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 365)-((thlmc.patient_cost / thlmc.days_supply)* 365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 135)-((thlmc.patient_cost / thlmc.days_supply)* 135))
		else (alt.med_patient_pay_amount-thlmc.patient_cost)
	end as alt_annual_patient_savings 
	,case
		when alt.med_total_cost is null then -0.01
		when lower(alt.med_med_type) = 'm'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) >= (-250::float8 / alt.med_calculation_days_supply)) then (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply))* 365)
		when lower(alt.med_med_type) = 'p'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) >= (-250::float8 / alt.med_calculation_days_supply)) then (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply))* 135)
		when lower(alt.med_med_type) = 'a'
		and ((alt.med_total_cost-thlmc.total_cost) >= -250::float8) then (alt.med_total_cost-thlmc.total_cost)
		when lower(alt.med_med_type) = 'm'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) < (-250::float8 / alt.med_calculation_days_supply)) then ((-250::float8 / alt.med_calculation_days_supply)* 365)
		when lower(alt.med_med_type) = 'p'
		and (((alt.med_total_cost / alt.med_calculation_days_supply)-(thlmc.total_cost / thlmc.calculation_days_supply)) < (-250::float8 / alt.med_calculation_days_supply)) then ((-250::float8 / alt.med_calculation_days_supply)* 135)
		when lower(alt.med_med_type) = 'a'
		and ((alt.med_total_cost-thlmc.total_cost) < -250::float8) then -250::float8
	end as alt_annual_total_savings
	,alt.alt_quantity
	,alt.alt_days_supply
	,alt.alt_order
	,thlmc.id as mml_record_id
	,thlmc.med_name as mml_med 
	,thlmc.med_brand as mml_med_brand 
	,thlmc.date_of_service::date as mml_claim_date
	,thlmc.med_ndc as mml_ndc 
	,thlmc.specific_product_id as mml_spid
	,thlmc.concept_name as mml_concept_name
	,thlmc.quantity_dispensed as mml_quantity
	,thlmc.days_supply as mml_days_supply
	,thlmc.med_type as mml_med_type
	,date_part('year', thlmc.date_of_service)::text || LPAD(date_part('month', thlmc.date_of_service)::text, 2, '0') as switch_change_month
	,'Tier 1' as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.gpi_12 as mml_gpi_12
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,alt.alt_annual_patient_savings_v1
	,alt.alt_annual_total_savings_v1
	,thc.new_patient_identifier
	-- if patient has used the resulting med previous, this column has value
	,alt.report_created_date::date-thc.date_of_service::date as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
	,case 
		when lower(alt.med_pharmacy_type) = 'retail' and alt.alt_has_fulfillment = true and lower(thlmc.alt_pharmacy_type) ='cvs mail' then true
		else false
	end as is_alternative_fulfillment
from temp_altermedlist alt
join temp_bsc_claims thlmc 
	on alt.patient_identifier = thlmc.new_patient_identifier
	and thlmc.date_of_service::date >= alt.report_created_date::date
	and alt.med_gpi_12 is not null
	and thlmc.gpi_12 is not null
	and (alt.med_gpi_12 <> thlmc.gpi_12
		or (alt.med_gpi_12 = thlmc.gpi_12
			and 
					((upper(alt.med_msc) = 'M'
				and upper(thlmc.med_msc) in ('N', 'O', 'Y'))
				or (upper(alt.med_msc) = 'N'
					and upper(thlmc.med_msc) in ('M', 'O', 'Y'))
					or (upper(alt.med_msc) = 'O'
						and upper(thlmc.med_msc) in ('N', 'M', 'Y'))
						or (upper(alt.med_msc) = 'Y'
							and upper(thlmc.med_msc) in ('N', 'M')))
				)
		-- Chosen Medication & Resulting Medication with same GPI-12s 
		)
	and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
	and (alt.alt_gpi_12 is not null
		and thlmc.gpi_12 is not null
		and alt.alt_gpi_12 = thlmc.gpi_12)
	--Only match alternative with GPI12
left join temp_bsc_claims thc 
	on alt.patient_identifier = thc.new_patient_identifier
	and thc.date_of_service::date <= alt.report_created_date::date
	and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
	and ((thlmc.gpi_12 is not null
		and thc.gpi_12 is not null
		and thlmc.gpi_12 = thc.gpi_12
		and upper(thlmc.med_msc) = upper(thc.med_msc))
		)
	--resulting medication was not filled in the past 12
left join temp_bsc_chosen_med_found_keys themdk 
	on alt.med_id = themdk.med_id
	and themdk.mml_claim_date::date >= thlmc.date_of_service::date
where
	cast(alt.report_created_date::date + '120 day'::interval as date) >= thlmc.date_of_service::date
	-- First Fill DOS must be less than or equal to the DDP inserted date + 120 days 
	and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
	--Only claims for previous month
		or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
	and themdk.med_id is null
	-- no Chosen med found after resulting med
;

--drop table if exists temp_new_tier1_matches;

create temp table temp_new_tier1_matches as
select distinct 
	ttp.patient_identifier 
	,ttp.med_id
	,ttp.med_gpi_14
	,ttp.report_created_date
	,ttp.alt_med
	,ttp.alt_brand
	,ttp.alt_pa
	,ttp.alt_ndc
	,ttp.alt_spid
	,ttp.alt_med_type
	,ttp.alt_concept
	,ttp.alt_annual_patient_savings 
	,ttp.alt_annual_total_savings 
	,ttp.alt_quantity
	,ttp.alt_days_supply
	,ttp.alt_order
	,ttp.mml_record_id
	,ttp.mml_med 
	,ttp.mml_med_brand 
	,ttp.mml_claim_date
	,ttp.mml_ndc 
	,ttp.mml_spid
	,ttp.mml_concept_name
	,ttp.mml_quantity
	,ttp.mml_days_supply
	,ttp.mml_med_type
	,ttp.switch_change_month
	,ttp.change_type
	,ttp.mml_patient_cost
	,ttp.mml_total_cost
	,ttp.mml_gpi
	,ttp.carrier_id
	,ttp.account_id
	,ttp.group_id
	,ttp.alt_annual_patient_savings_v1
	,ttp.alt_annual_total_savings_v1
	,ttp.mml_med_super_concept
	,ttp.is_alternative_fulfillment
	,ttp.report_created_date || LPAD(round(ttp.alt_annual_total_savings)::text, 10, '0')|| ttp.med_id as priority_index
from
	temp_new_tier1_prematches ttp
left join temp_new_tier1_prematches ttpf 
	on ttp.med_id = ttpf.med_id
	and ttpf.lookback_days > 0
	and ttpf.lookback_days < 120
where
	ttp.new_patient_identifier is null
	or ttpf.med_id is null
;
--If a claim matched mulitple T1 CI, pick most recent T1 transaction and then highest savings
--drop table if exists temp_t1_multi_ddp_same_claim;

create temp table temp_t1_multi_ddp_same_claim as
select
	cttm.mml_record_id
	,max(cttm.priority_index) as max_priority_index
from temp_new_tier1_matches cttm
group by
	cttm.mml_record_id
;

create index "_I_temp_t1_multi_ddp_same_claim_mml_record_id" 
	on temp_t1_multi_ddp_same_claim
	using btree(mml_record_id)
;

create index "_I_temp_t1_multi_ddp_same_claim_max_priority_index" 
	on temp_t1_multi_ddp_same_claim
	using btree(max_priority_index)
;
--In case the claim match multiple alternative of an chosen medication, select the most saving (smallest alternative older)
--drop table if exists temp_t1_list;

create temp table temp_t1_list as
select distinct 
	trm.*
	,row_number() over (partition by trm.med_id,trm.mml_claim_date order by trm.alt_annual_total_savings desc) as most_savings_order
from temp_new_tier1_matches trm
join temp_t1_multi_ddp_same_claim trmdsc 
	on trm.priority_index = trmdsc.max_priority_index
	and trm.mml_record_id = trmdsc.mml_record_id
;

create index "_I_temp_t1_list_med_id_most_savings_order" 
	on temp_t1_list
	using btree(med_id,most_savings_order)
;
-- Insert Key  for T1
--drop table if exists temp_ci_keys;

create temp table temp_ci_keys as
select distinct 
	med_id
from temp_t1_list
;
---------------End  Tier 1 ------------------------------------------------
---------------Begin Tier 2 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
--drop table if exists temp_tier2_prematches;

create temp table temp_tier2_prematches as
select distinct 
	thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.report_created_date
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,0 as alt_spid
	,null as alt_med_type
	,null as alt_concept
	,case 
		when alt.med_patient_pay_amount is null then -0.01
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 365)-((thlmc.patient_cost / thlmc.days_supply)* 365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount / alt.med_days_supply)* 135)-((thlmc.patient_cost / thlmc.days_supply)* 135))
		else (alt.med_patient_pay_amount-thlmc.patient_cost)
	end as alt_annual_patient_savings 
	,case 
		when alt.med_total_cost is null then -0.01
		when lower(alt.med_med_type) = 'm' then (((alt.med_total_cost / alt.med_calculation_days_supply)* 365)-((thlmc.total_cost / thlmc.calculation_days_supply)* 365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_total_cost / alt.med_calculation_days_supply)* 135)-((thlmc.total_cost / thlmc.calculation_days_supply)* 135))
		else (alt.med_total_cost-thlmc.total_cost)
	end as alt_annual_total_savings 
	,0 as alt_quantity
	,0 as alt_days_supply
	,0 as alt_order
	,thlmc.id as mml_record_id
	,thlmc.med_name as mml_med 
	,thlmc.med_brand as mml_med_brand 
	,thlmc.date_of_service::date as mml_claim_date
	,thlmc.med_ndc as mml_ndc 
	,thlmc.specific_product_id as mml_spid
	,thlmc.concept_name as mml_concept_name
	,thlmc.quantity_dispensed as mml_quantity
	,thlmc.days_supply as mml_days_supply
	,thlmc.med_type as mml_med_type
	,date_part('year', thlmc.date_of_service)::text || LPAD(date_part('month', thlmc.date_of_service)::text, 2, '0') as switch_change_month
	,'Tier 2' as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.gpi_12 as mml_gpi_12
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,250 as alt_annual_patient_savings_v1
	,900 as alt_annual_total_savings_v1
	,thc.new_patient_identifier
	,alt.report_created_date::date-thc.date_of_service::date as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
	,case 
		when lower(alt.med_pharmacy_type) = 'retail' and alt.med_has_fulfillment = true and lower(thlmc.alt_pharmacy_type) ='cvs mail' then true
		else false
	end as is_alternative_fulfillment
from temp_altermedlist alt
join temp_bsc_claims thlmc 
	on alt.patient_identifier = thlmc.new_patient_identifier
	and thlmc.date_of_service::date >= alt.report_created_date::date
	and ( alt.med_gpi_12 is not null
		and thlmc.gpi_12 is not null
		and (alt.med_gpi_12 <> thlmc.gpi_12)
		)
	and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
	and (alt.med_super_concept is not null
		and thlmc.med_super_concept is not null
		and upper(alt.med_super_concept) = upper(thlmc.med_super_concept))
	--Super Concept match between chosen and Claim Med (resulting med)
left join temp_bsc_claims thc 
	on alt.patient_identifier = thc.new_patient_identifier
	and thc.date_of_service::date <= alt.report_created_date::date
	and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
	and (thlmc.gpi_12 is not null
		and thc.gpi_12 is not null
		and thlmc.gpi_12 = thc.gpi_12
		and upper(thlmc.med_msc) = upper(thc.med_msc)
	)
	--resulting medication was not filled in the past 120
left join temp_bsc_chosen_med_found_keys themdk 
	on alt.med_id = themdk.med_id
	and themdk.mml_claim_date::date >= thlmc.date_of_service::date
	--for indentifying Tier 1 and chosen Med Found within same month
left join temp_t1_multi_ddp_same_claim tt1mdsc 
	on thlmc.id = tt1mdsc.mml_record_id
where
	cast(alt.report_created_date::date + '120 day'::interval as date) >= thlmc.date_of_service::date
	-- First Fill DOS must be less than or equal to the DDP inserted date + 120 days 
	and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
	--Only claims for previous month
		or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
	and themdk.med_id is null
	-- no chosen med found after resulting med
	and tt1mdsc.mml_record_id is null
	--claim was not used for T1 CI previously
;

--drop table if exists temp_tier2_matches;

create temp table temp_tier2_matches as
select
	distinct ttp.patient_identifier 
	,ttp.med_id
	,ttp.med_gpi_14
	,ttp.report_created_date
	,ttp.alt_med
	,ttp.alt_brand
	,ttp.alt_pa
	,ttp.alt_ndc
	,ttp.alt_spid
	,ttp.alt_med_type
	,ttp.alt_concept
	,ttp.alt_annual_patient_savings 
	,ttp.alt_annual_total_savings 
	,ttp.alt_quantity
	,ttp.alt_days_supply
	,ttp.alt_order
	,ttp.mml_record_id
	,ttp.mml_med 
	,ttp.mml_med_brand 
	,ttp.mml_claim_date
	,ttp.mml_ndc 
	,ttp.mml_spid
	,ttp.mml_concept_name
	,ttp.mml_quantity
	,ttp.mml_days_supply
	,ttp.mml_med_type
	,ttp.switch_change_month
	,ttp.change_type
	,ttp.mml_patient_cost
	,ttp.mml_total_cost
	,ttp.mml_gpi
	,ttp.carrier_id
	,ttp.account_id
	,ttp.group_id
	,ttp.alt_annual_patient_savings_v1
	,ttp.alt_annual_total_savings_v1
	,ttp.mml_med_super_concept
	,ttp.is_alternative_fulfillment
	,ttp.report_created_date || LPAD(round(ttp.alt_annual_total_savings)::text, 10, '0')|| ttp.med_id as priority_index
from temp_tier2_prematches ttp
left join temp_tier2_prematches ttpf 
	on ttp.med_id = ttpf.med_id
	and ttpf.lookback_days > 0
	and ttpf.lookback_days < 120
where
	ttp.alt_annual_total_savings >= 0
	and (ttp.new_patient_identifier is null
		or ttpf.med_id is null)
;
--If a claim matched mulitple CI, pick most recent T2 transaction.
--drop table if exists temp_t2_multi_ddp_same_claim;

create temp table temp_t2_multi_ddp_same_claim as
select
	cttm.mml_record_id
	,max(cttm.priority_index) as max_priority_index
from
	temp_tier2_matches cttm
group by
	cttm.mml_record_id
;

create index "_I_temp_t2_multi_ddp_same_claim_mml_record_id" on
temp_t2_multi_ddp_same_claim
	using btree(mml_record_id)
;

create index "_I_temp_t2_multi_ddp_same_claim_max_priority_index" on
temp_t2_multi_ddp_same_claim
	using btree(max_priority_index)
;
--In case the claim match multiple alternative of an chosen medication, select the most saving (smallest alternative older)
--drop table if exists temp_t2_list;

create temp table temp_t2_list as
select distinct 
	trm.*
	,row_number() over (partition by trm.med_id
	,trm.mml_claim_date
order by
	trm.alt_annual_total_savings desc) as most_savings_order
from temp_tier2_matches trm
join temp_t2_multi_ddp_same_claim trmdsc	
	on trm.priority_index = trmdsc.max_priority_index
	and trm.mml_record_id = trmdsc.mml_record_id
;

create index "_I_temp_t2_list_med_id_most_savings_order" 
	on temp_t2_list
	using btree(med_id,most_savings_order)
;
-- Insert Key  for T2
insert into temp_ci_keys 
	select distinct med_id
	from temp_t2_list
;
---------------End  Tier 2 ------------------------------------------------
---------------Begin Add chosen Med found records----------------------------------
insert into temp_ci_keys
	select distinct themdk.med_id
	from temp_bsc_chosen_med_found_keys themdk
	left join temp_ci_keys tck	
		on themdk.med_id = tck.med_id
	where tck.med_id is null
;
---------------End Add chosen Med found records----------------------------------
--Add Index back
create index "_I_temp_ci_keys" 
	on temp_ci_keys
	using btree(med_id)
;
--------------- New Tier 1 & 2 Result Consolidation ---------------
--drop table if exists temp_new_ci_pre_list;

create temp table temp_new_ci_pre_list as
select
	ttl.*
	,row_number() over (partition by ttl.med_id order by ttl.mml_claim_date, ttl.change_type, ttl.most_savings_order) as fil_type_code
from
	(select
		*
	from temp_t1_list
union
	select
		*
	from temp_t2_list) ttl
;

--drop table if exists temp_new_ci_list;

create temp table temp_new_ci_list as
select
	tncpl1.*
from temp_new_ci_pre_list tncpl1
left join temp_new_ci_pre_list tncpl2 
	on tncpl1.med_id = tncpl2.med_id
	and tncpl2.change_type = 'Tier 1'
	and tncpl2.fil_type_code = 1
where
	tncpl2.med_id is null
	or (tncpl2.med_id is not null
		and tncpl1.change_type = 'Tier 1')
;
---------------------------------------------------------------
----------------Begin Temp public.insurance_policies----------------------------------------------
--drop table if exists temp_insurance_policies;

create temp table temp_insurance_policies as
select
	patient_id,
	line_of_business,
	insurance_company_id
from public.insurance_policies
;

create index "_I_temp_insurance_policies" 
	on temp_insurance_policies
	using btree(patient_id)
;

create index "_I_temp_insurance_policies_insurance_company_id" 
	on temp_insurance_policies
	using btree(insurance_company_id)
;
----------------End temp public.insurance_policies-----------------------------------------------
---------------Begin Create ddp Raw data ------------------------------------
--drop table if exists temp_ddp_dedup_report;

create temp table temp_ddp_dedup_report as
select distinct 
	org.ehr_organization_id
	,bt.id as transaction_id
	,pm.id as med_id
	,bt.inserted_at
	,phy.last_name || ', ' || phy.first_name as prescriber_name
	,phy.npi as prescriber_npi
	,case
		when sc.ehr_name is not null then sc.ehr_name --if txn is from SS, it will show SS ehr name
		when lower(u.client_name) = 'centerx' or org.ehr_organization_id = '1234' or org.ehr_organization_id ilike 'CX%' then 'CRX - '||org."name" --if txn is from centerx, it will show CRX prefix
		when lower(u.client_name) = 'arrive_health' then 'AH - '||org."name" --if txn is from arrive health, it will show AH prefix
		else coalesce(org."name",'') -- all others will just show organization name from Beacon config.
	end as org_name
	,pl.name as requested_chosen_medication
	,pm.quantity
	,pm.days_supply
	,pharm.npi as pharmacy_npi
	,case
			when pl.brand = true then 'Y'
			when pl.brand = false then 'N'
		end as requested_chosen_brand
	,case
			when pm.prior_auth_needed = true then 'Y'
			when pm.prior_auth_needed = false then 'N'
		end as requested_chosen_pa
	,pm.ndc as requested_chosen_ndc
	,pm.patient_pay_amount as requested_chosen_patient_pay_amount
	,pm.total_cost as requested_chosen_total_cost
	,pl.specific_product_id as requested_chosen_spid
	,case
			when pl.maintenance = true then 'M'
			--Maintenance
			when pl.maintenance = false
			and pl.periodic = true then 'P'
			--Periodic
			when pl.maintenance = false
			and pl.periodic = false then 'A'
			--Acute
		end as requested_chosen_med_type
	,pl.gpi as requested_chosen_gpi
	,pe.concept_name as requested_chosen_concept_name
	,pat.emr_patient_id as ehr_patient_id
	,ic.bin as bin
	,ic.pcn as pcn
	--ALT 1
	,alt1.alt_display_name as alt1_med
	,alt1.alt_generic_name as alt1_generic_name
	,alt1.alt_days_supply as alt1_days_supply
	,alt1.alt_quantity as alt1_medication_quantity
	,alt1.alt_brand as alt1_brand
	,alt1.alt_prior_auth_needed as alt1_pa
	,alt1.alt_ndc as alt1_ndc
	,alt1.alt_specific_product_id as alt1_spid
	,alt1.alt_gpi_14 as alt1_gpi
	,alt1.alt_concept_name as alt1_concept
	,alt1.alt_patient_pay_amount as alt1_patient_pay_amount
	,alt1.alt_total_cost as alt1_total_cost
	--ALT 2
	,alt2.alt_display_name as alt2_med
	,alt2.alt_generic_name as alt2_generic_name
	,alt2.alt_days_supply as alt2_days_supply
	,alt2.alt_quantity as alt2_medication_quantity
	,alt2.alt_brand as alt2_brand
	,alt2.alt_prior_auth_needed as alt2_pa
	,alt2.alt_ndc as alt2_ndc
	,alt2.alt_specific_product_id as alt2_spid
	,alt2.alt_gpi_14 as alt2_gpi
	,alt2.alt_concept_name as alt2_concept
	,alt2.alt_patient_pay_amount as alt2_patient_pay_amount
	,alt2.alt_total_cost as alt2_total_cost
	--ALT 3
	,alt3.alt_display_name as alt3_med
	,alt3.alt_generic_name as alt3_generic_name
	,alt3.alt_days_supply as alt3_days_supply
	,alt3.alt_quantity as alt3_medication_quantity
	,alt3.alt_brand as alt3_brand
	,alt3.alt_prior_auth_needed as alt3_pa
	,alt3.alt_ndc as alt3_ndc
	,alt3.alt_specific_product_id as alt3_spid
	,alt3.alt_gpi_14 as alt3_gpi
	,alt3.alt_concept_name as alt3_concept
	,alt3.alt_patient_pay_amount as alt3_patient_pay_amount
	,alt3.alt_total_cost as alt3_total_cost
	,pe.super_concept as requested_chosen_super_concept
	,ip.line_of_business
	,case
		--when u.id = any(string_to_array(:v2_users,',')::int[]) then true
		when u.id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,450,483,549) then true
		else false
	end as is_v2
	--is_v2 is temp logic because we don't have other way to identify V1 or V2
	--Once CenterX is using V2, we will need to include CenterX
from public.beacon_transactions bt
	join public.patients pat 
		on bt.patient_id = pat.id
	join public.priced_medications pm 
		on bt.id = pm.beacon_transaction_id
		and pm.chosen_med = true
	join public.providers phy 
		on bt.provider_id = phy.id
	join temp_insurance_policies ip 
		on pat.id = ip.patient_id
	join public.insurance_companies ic 
		on ip.insurance_company_id = ic.id
	join pbm_logs pls 
		on bt.request_id = pls.request_id
		and pls.is_final = true
	join temp_ci_keys ett 
		on pm.id = ett.med_id
		--Matched results chosen_med_found + Tier 1 + Tier 2
	join payers pay 
		on ic.payer_id = pay.id
	join organizations org 
		on phy.organization_id = org.id
	join public.user_organizations uo
		on org.id = uo.organization_id
	join public.users u
		on u.id = uo.user_id
	join product_lookup pl 
		on pm.ndc = pl.ndc
	left join product_equivalencies pe 
		on pl.specific_product_id = pe.specific_product_id
	left join pharmacies pharm 
		on pm.pharmacy_id = pharm.id
	left join surescripts_ddps ssddp 
		on bt.id = ssddp.beacon_transaction_id
	left join surescripts_crosswalks sc 
		on sc.account_id = ssddp.sender_tertiary_identification
	left join (select
				alter1.med_id
				,alter1.alt_display_name
				,alter1.alt_ndc
				,alter1.alt_days_supply
				,alter1.alt_quantity
				,alter1.alt_id
				,alter1.alt_brand
				,alter1.alt_prior_auth_needed
				,alter1.alt_specific_product_id
				,alter1.alt_order
				,alter1.alt_gpi_14
				,alter1.alt_generic_name
				,alter1.alt_concept_name
				,alter1.alt_patient_pay_amount
				,alter1.alt_total_cost
			from temp_altermedlist alter1
			where alter1.alt_order = 1) alt1 
			on pm.id = alt1.med_id
	left join (select
				alter2.med_id
				,alter2.alt_display_name
				,alter2.alt_ndc
				,alter2.alt_days_supply
				,alter2.alt_quantity
				,alter2.alt_id
				,alter2.alt_brand
				,alter2.alt_prior_auth_needed
				,alter2.alt_specific_product_id
				,alter2.alt_order
				,alter2.alt_gpi_14
				,alter2.alt_generic_name
				,alter2.alt_concept_name
				,alter2.alt_patient_pay_amount
				,alter2.alt_total_cost
			from
				temp_altermedlist alter2
			where alter2.alt_order = 2) alt2 
				on pm.id = alt2.med_id
	left join (select
			alter3.med_id
			,alter3.alt_display_name
			,alter3.alt_ndc
			,alter3.alt_days_supply
			,alter3.alt_quantity
			,alter3.alt_id
			,alter3.alt_brand
			,alter3.alt_prior_auth_needed
			,alter3.alt_specific_product_id
			,alter3.alt_order
			,alter3.alt_gpi_14
			,alter3.alt_generic_name
			,alter3.alt_concept_name
			,alter3.alt_patient_pay_amount
			,alter3.alt_total_cost
		from temp_altermedlist alter3
		where alter3.alt_order = 3) alt3 
		on pm.id = alt3.med_id
where
	lower(pay."name") = 'bsc'
	and org.ehr_organization_id not in ('1')
	and bt.pbm_called = true
	-- called PBM for info
	and cast(bt.inserted_at::date + '120 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date)
;

create index "_I_temp_ddp_dedup_report_1" 
	on temp_ddp_dedup_report
	using btree(med_id)
;
---------------End Create ddp Raw data ----------------------------------------
---------------Begin Chosen Med Found Prep ----------------------------------------
--drop table if exists temp_emf_prep;

create temp table temp_emf_prep as
select
	ef.mml_record_id
	,max(ef.report_created_date::text || ef.med_id::text) as most_recent_ci
from temp_bsc_chosen_med_found_list ef
left join temp_new_ci_list tncpl 
	on ef.med_id = tncpl.med_id
	or ef.mml_record_id = tncpl.mml_record_id
where tncpl.med_id is null
group by ef.mml_record_id
;

create index "_I_temp_emf_prep" 
	on temp_emf_prep
	using btree(most_recent_ci)
;
---------------End Chosen Med Found Prep ----------------------------------------
---------------Begin Generate Output Report -----------------------------------
--drop table if exists temp_output;

create temp table temp_output as
select
	now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_chosen_medication as "ChosenDrug"
	,tdr.quantity as "ChosenDrugQuantity"
	,tdr.days_supply as "ChosenDrugDaysSupply"
	,tdr.requested_chosen_brand as "ChosenDrugBrand"
	,tdr.requested_chosen_ndc::int8 as "ChosenDrugNDC"
	,tdr.requested_chosen_pa as "ChosenDrugPA"
	,tdr.requested_chosen_spid as "ChosenDrugSPID"
	,tdr.requested_chosen_concept_name as "ChosenDrugConceptName"
	,tdr.requested_chosen_med_type as "ChosenDrugMaintenancePeriodic"
	,null as "AltDrug"
	,null as "AltDrugBrand"
	,null as "AltDrugNDC"
	,null as "AltDrugPA"
	,null as "AltDrugSPID"
	,null as "AltDrugConceptName"
	,null as "AltDrugQuantity"
	,null as "AltDrugDaysSupply"
	,ef.mml_med as "ClaimDrug"
	,ef.mml_med_brand as "ClaimDrugBrand"
	,ef.mml_claim_date as "ClaimDate"
	,ef.mml_ndc::int8 as "ClaimDrugNDC"
	,ef.mml_spid as "ClaimDrugSPID"
	,ef.mml_concept_name as "ClaimDrugConceptName"
	,ef.mml_quantity as "ClaimDrugQuantity"
	,ef.mml_days_supply as "ClaimDrugDaysSupply"
	,ef.mml_med_type as "ClaimDrugMaintenancePeriodic"
	,case 
		when ef.is_alternative_fulfillment then ef.alt_annual_patient_savings
		else null
	end as "AnnualPatientSavings"
	,case 
		when ef.is_alternative_fulfillment then ef.alt_annual_total_savings
		else null
	end as "AnnualTotalSavings"
	,ef.switch_change_month::int8 as "SwitchChangeMonth"
	,tdr.transaction_id::text || tdr.requested_chosen_ndc::int8 as "uid"
	,ef.change_type as "ChangeType"
	,tdr.org_name as "org"
	,'DDP' as "ProductLine"
	--ALT 1
	,tdr.alt1_med as "Alt1Drug"
	,tdr.alt1_generic_name as "Alt1DrugGenericName"
	,tdr.alt1_brand as "Alt1DrugBrand"
	,tdr.alt1_ndc::int8 as "Alt1DrugNDC"
	,tdr.alt1_pa as "Alt1DrugPA"
	,tdr.alt1_spid as "Alt1DrugSPID"
	,tdr.alt1_concept as "Alt1DrugConceptName"
	,tdr.alt1_medication_quantity as "Alt1DrugQuantity"
	,tdr.alt1_days_supply as "Alt1DrugDaysSupply"
	--ALT 2
	,tdr.alt2_med as "Alt2Drug"
	,tdr.alt2_generic_name as "Alt2DrugGenericName"
	,tdr.alt2_brand as "Alt2DrugBrand"
	,tdr.alt2_ndc::int8 as "Alt2DrugNDC"
	,tdr.alt2_pa as "Alt2DrugPA"
	,tdr.alt2_spid as "Alt2DrugSPID"
	,tdr.alt2_concept as "Alt2DrugConceptName"
	,tdr.alt2_medication_quantity as "Alt2DrugQuantity"
	,tdr.alt2_days_supply as "Alt2DrugDaysSupply"
	--ALT 3
	,tdr.alt3_med as "Alt3Drug"
	,tdr.alt3_generic_name as "Alt3DrugGenericName"
	,tdr.alt3_brand as "Alt3DrugBrand"
	,tdr.alt3_ndc::int8 as "Alt3DrugNDC"
	,tdr.alt3_pa as "Alt3DrugPA"
	,tdr.alt3_spid as "Alt3DrugSPID"
	,tdr.alt3_concept as "Alt3DrugConceptName"
	,tdr.alt3_medication_quantity as "Alt3DrugQuantity"
	,tdr.alt3_days_supply as "Alt3DrugDaysSupply"
	,tdr.med_id as "ChosenMedInternalID"
	,tdr.requested_chosen_gpi
	,ef.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_chosen_patient_pay_amount
	,tdr.requested_chosen_total_cost
	,ef.mml_patient_cost
	,ef.mml_total_cost
	,tdr.alt1_patient_pay_amount
	,tdr.alt1_total_cost
	,tdr.alt2_patient_pay_amount
	,tdr.alt2_total_cost
	,tdr.alt3_patient_pay_amount
	,tdr.alt3_total_cost
	,ef.carrier_id
	,ef.account_id
	,ef.group_id
	,tdr.requested_chosen_super_concept
	,ef.mml_med_super_concept
	,case 
		when ef.is_alternative_fulfillment then ef.alt_annual_patient_savings
		else null
	end as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_chosen_med_type) = 'm'
			and ef.is_alternative_fulfillment
			and ef.alt_annual_total_savings > 30000 then 30000
		when lower(tdr.requested_chosen_med_type) = 'p'
			and ef.is_alternative_fulfillment
			and ef.alt_annual_total_savings > 11250 then 11250
		when lower(tdr.requested_chosen_med_type) = 'a'
			and ef.is_alternative_fulfillment
			and ef.alt_annual_total_savings > 2500 then 2500
		when ef.is_alternative_fulfillment then ef.alt_annual_total_savings
		else null
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,null as fill_type
	,ef.mml_record_id
	,ef.is_alternative_fulfillment
from temp_ddp_dedup_report tdr
	join temp_bsc_chosen_med_found_list ef 
		on tdr.med_id = ef.med_id
	join temp_emf_prep tep 
		on ef.report_created_date::text || ef.med_id::text = tep.most_recent_ci
	left join temp_new_ci_list tncpl 
		on ef.med_id = tncpl.med_id
		or ef.mml_record_id = tncpl.mml_record_id
where tncpl.med_id is null
union all 
select
	now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_chosen_medication as "chosenDrug"
	,tdr.quantity as "chosenDrugQuantity"
	,tdr.days_supply as "chosenDrugDaysSupply"
	,tdr.requested_chosen_brand as "chosenDrugBrand"
	,tdr.requested_chosen_ndc::int8 as "chosenDrugNDC"
	,tdr.requested_chosen_pa as "chosenDrugPA"
	,tdr.requested_chosen_spid as "chosenDrugSPID"
	,tdr.requested_chosen_concept_name as "chosenDrugConceptName"
	,tdr.requested_chosen_med_type as "chosenDrugMaintenancePeriodic"
	,t1.alt_med as "AltDrug"
	,t1.alt_brand as "AltDrugBrand"
	,t1.alt_ndc::int8 as "AltDrugNDC"
	,t1.alt_pa as "AltDrugPA"
	,t1.alt_spid as "AltDrugSPID"
	,t1.alt_concept as "AltDrugConceptName"
	,t1.alt_quantity as "AltDrugQuantity"
	,t1.alt_days_supply as "AltDrugDaysSupply"
	,t1.mml_med as "ClaimDrug"
	,t1.mml_med_brand as "ClaimDrugBrand"
	,t1.mml_claim_date as "ClaimDate"
	,t1.mml_ndc::int8 as "ClaimDrugNDC"
	,t1.mml_spid as "ClaimDrugSPID"
	,t1.mml_concept_name as "ClaimDrugConceptName"
	,t1.mml_quantity as "ClaimDrugQuantity"
	,t1.mml_days_supply as "ClaimDrugDaysSupply"
	,t1.mml_med_type as "ClaimDrugMaintenancePeriodic"
	,t1.alt_annual_patient_savings as "AnnualPatientSavings"
	,t1.alt_annual_total_savings as "AnnualTotalSavings"
	,t1.switch_change_month::int8 as "SwitchChangeMonth"
	,tdr.transaction_id::text || tdr.requested_chosen_ndc::int8 as "uid"
	,t1.change_type as "ChangeType"
	,tdr.org_name as "org"
	,'DDP' as "ProductLine"
	--ALT 1
	,tdr.alt1_med as "Alt1Drug"
	,tdr.alt1_generic_name as "Alt1DrugGenericName"
	,tdr.alt1_brand as "Alt1DrugBrand"
	,tdr.alt1_ndc::int8 as "Alt1DrugNDC"
	,tdr.alt1_pa as "Alt1DrugPA"
	,tdr.alt1_spid as "Alt1DrugSPID"
	,tdr.alt1_concept as "Alt1DrugConceptName"
	,tdr.alt1_medication_quantity as "Alt1DrugQuantity"
	,tdr.alt1_days_supply as "Alt1DrugDaysSupply"
	--ALT 2
	,tdr.alt2_med as "Alt2Drug"
	,tdr.alt2_generic_name as "Alt2DrugGenericName"
	,tdr.alt2_brand as "Alt2DrugBrand"
	,tdr.alt2_ndc::int8 as "Alt2DrugNDC"
	,tdr.alt2_pa as "Alt2DrugPA"
	,tdr.alt2_spid as "Alt2DrugSPID"
	,tdr.alt2_concept as "Alt2DrugConceptName"
	,tdr.alt2_medication_quantity as "Alt2DrugQuantity"
	,tdr.alt2_days_supply as "Alt2DrugDaysSupply"
	--ALT 3
	,tdr.alt3_med as "Alt3Drug"
	,tdr.alt3_generic_name as "Alt3DrugGenericName"
	,tdr.alt3_brand as "Alt3DrugBrand"
	,tdr.alt3_ndc::int8 as "Alt3DrugNDC"
	,tdr.alt3_pa as "Alt3DrugPA"
	,tdr.alt3_spid as "Alt3DrugSPID"
	,tdr.alt3_concept as "Alt3DrugConceptName"
	,tdr.alt3_medication_quantity as "Alt3DrugQuantity"
	,tdr.alt3_days_supply as "Alt3DrugDaysSupply"
	,tdr.med_id as "ChosenMedInternalID"
	,tdr.requested_chosen_gpi
	,t1.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_chosen_patient_pay_amount
	,tdr.requested_chosen_total_cost
	,t1.mml_patient_cost
	,t1.mml_total_cost
	,tdr.alt1_patient_pay_amount
	,tdr.alt1_total_cost
	,tdr.alt2_patient_pay_amount
	,tdr.alt2_total_cost
	,tdr.alt3_patient_pay_amount
	,tdr.alt3_total_cost
	,t1.carrier_id
	,t1.account_id
	,t1.group_id
	,tdr.requested_chosen_super_concept
	,t1.mml_med_super_concept
	,t1.alt_annual_patient_savings as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_chosen_med_type) = 'm'
		and t1.alt_annual_total_savings > 30000 then 30000
		when lower(tdr.requested_chosen_med_type) = 'p'
		and t1.alt_annual_total_savings > 11250 then 11250
		when lower(tdr.requested_chosen_med_type) = 'a'
		and t1.alt_annual_total_savings > 2500 then 2500
		else t1.alt_annual_total_savings
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,'New' as fill_type
	,t1.mml_record_id
	,case 
		when tdr.is_v2 then t1.is_alternative_fulfillment
		else false
	end as is_alternative_fulfillment
from temp_ddp_dedup_report tdr
	join temp_new_ci_list t1 
		on tdr.med_id = t1.med_id
		and t1.most_savings_order = 1
		and t1.change_type = 'Tier 1'
where t1.fil_type_code = 1
union all 
select
	now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_chosen_medication as "chosenDrug"
	,tdr.quantity as "chosenDrugQuantity"
	,tdr.days_supply as "chosenDrugDaysSupply"
	,tdr.requested_chosen_brand as "chosenDrugBrand"
	,tdr.requested_chosen_ndc::int8 as "chosenDrugNDC"
	,tdr.requested_chosen_pa as "chosenDrugPA"
	,tdr.requested_chosen_spid as "chosenDrugSPID"
	,tdr.requested_chosen_concept_name as "chosenDrugConceptName"
	,tdr.requested_chosen_med_type as "chosenDrugMaintenancePeriodic"
	,null as "AltDrug"
	,null as "AltDrugBrand"
	,null as "AltDrugNDC"
	,null as "AltDrugPA"
	,null as "AltDrugSPID"
	,null as "AltDrugConceptName"
	,null as "AltDrugQuantity"
	,null as "AltDrugDaysSupply"
	,t2.mml_med as "ClaimDrug"
	,t2.mml_med_brand as "ClaimDrugBrand"
	,t2.mml_claim_date as "ClaimDate"
	,t2.mml_ndc::int8 as "ClaimDrugNDC"
	,t2.mml_spid as "ClaimDrugSPID"
	,t2.mml_concept_name as "ClaimDrugConceptName"
	,t2.mml_quantity as "ClaimDrugQuantity"
	,t2.mml_days_supply as "ClaimDrugDaysSupply"
	,t2.mml_med_type as "ClaimDrugMaintenancePeriodic"
	,t2.alt_annual_patient_savings as "AnnualPatientSavings"
	,t2.alt_annual_total_savings as "AnnualTotalSavings"
	,t2.switch_change_month::int8 as "SwitchChangeMonth"
	,tdr.transaction_id::text || tdr.requested_chosen_ndc::int8 as "uid"
	,t2.change_type as "ChangeType"
	,tdr.org_name as "org"
	,'DDP' as "ProductLine"
	--ALT 1
	,tdr.alt1_med as "Alt1Drug"
	,tdr.alt1_generic_name as "Alt1DrugGenericName"
	,tdr.alt1_brand as "Alt1DrugBrand"
	,tdr.alt1_ndc::int8 as "Alt1DrugNDC"
	,tdr.alt1_pa as "Alt1DrugPA"
	,tdr.alt1_spid as "Alt1DrugSPID"
	,tdr.alt1_concept as "Alt1DrugConceptName"
	,tdr.alt1_medication_quantity as "Alt1DrugQuantity"
	,tdr.alt1_days_supply as "Alt1DrugDaysSupply"
	--ALT 2
	,tdr.alt2_med as "Alt2Drug"
	,tdr.alt2_generic_name as "Alt2DrugGenericName"
	,tdr.alt2_brand as "Alt2DrugBrand"
	,tdr.alt2_ndc::int8 as "Alt2DrugNDC"
	,tdr.alt2_pa as "Alt2DrugPA"
	,tdr.alt2_spid as "Alt2DrugSPID"
	,tdr.alt2_concept as "Alt2DrugConceptName"
	,tdr.alt2_medication_quantity as "Alt2DrugQuantity"
	,tdr.alt2_days_supply as "Alt2DrugDaysSupply"
	--ALT 3
	,tdr.alt3_med as "Alt3Drug"
	,tdr.alt3_generic_name as "Alt3DrugGenericName"
	,tdr.alt3_brand as "Alt3DrugBrand"
	,tdr.alt3_ndc::int8 as "Alt3DrugNDC"
	,tdr.alt3_pa as "Alt3DrugPA"
	,tdr.alt3_spid as "Alt3DrugSPID"
	,tdr.alt3_concept as "Alt3DrugConceptName"
	,tdr.alt3_medication_quantity as "Alt3DrugQuantity"
	,tdr.alt3_days_supply as "Alt3DrugDaysSupply"
	,tdr.med_id as "ChosenMedInternalID"
	,tdr.requested_chosen_gpi
	,t2.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_chosen_patient_pay_amount
	,tdr.requested_chosen_total_cost
	,t2.mml_patient_cost
	,t2.mml_total_cost
	,tdr.alt1_patient_pay_amount
	,tdr.alt1_total_cost
	,tdr.alt2_patient_pay_amount
	,tdr.alt2_total_cost
	,tdr.alt3_patient_pay_amount
	,tdr.alt3_total_cost
	,t2.carrier_id
	,t2.account_id
	,t2.group_id
	,tdr.requested_chosen_super_concept
	,t2.mml_med_super_concept
	,t2.alt_annual_patient_savings * 0.75 as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_chosen_med_type) = 'm'
		and t2.alt_annual_total_savings * 0.75 > 30000 then 30000
		when lower(tdr.requested_chosen_med_type) = 'p'
		and t2.alt_annual_total_savings * 0.75 > 11250 then 11250
		when lower(tdr.requested_chosen_med_type) = 'a'
		and t2.alt_annual_total_savings * 0.75 > 2500 then 2500
		else t2.alt_annual_total_savings * 0.75
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,'New' as fill_type
	,t2.mml_record_id
	,case 
		when tdr.is_v2 then t2.is_alternative_fulfillment
		else false
	end as is_alternative_fulfillment
from temp_ddp_dedup_report tdr
	join temp_new_ci_list t2 
		on tdr.med_id = t2.med_id
		and t2.most_savings_order = 1
		and t2.change_type = 'Tier 2'
where t2.fil_type_code = 1
;
---------------End Generate Output Report -----------------------------------
--drop table if exists rpt_bsc_ddp_claim_gpi_outcome_prep_data;
--create table rpt_bsc_ddp_claim_gpi_outcome_prep_data as
INSERT INTO public.rpt_bsc_ddp_claim_gpi_outcome_prep_data
	(
		"ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ChosenDrug", "ChosenDrugQuantity", "ChosenDrugDaysSupply", "ChosenDrugBrand"
		, "ChosenDrugNDC", "ChosenDrugPA", "ChosenDrugSPID", "ChosenDrugConceptName", "ChosenDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID"
		, "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity"
		, "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", uid, "ChangeType", org, "ProductLine", "Alt1Drug"
		, "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName"
		, "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand"
		, "Alt3DrugNDC", "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ChosenMedInternalID", requested_chosen_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi
		, requested_chosen_patient_pay_amount, requested_chosen_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost
		, alt3_patient_pay_amount, alt3_total_cost, carrier_id, account_id, group_id, requested_chosen_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings"
		, line_of_business, fill_type, mml_record_id, "PA_avoided",is_alternative_fulfillment
	)
	select distinct 
	t."ReportDate"
	,t."GeminiTransactionID"
	,t."BIN"
	,t."PCN"
	,t."TransactionDate"
	,t."PrescriberName"
	,t."PrescriberNPI"
	,t."ChosenDrug"
	,t."ChosenDrugQuantity"
	,t."ChosenDrugDaysSupply"
	,t."ChosenDrugBrand"
	,t."ChosenDrugNDC"
	,t."ChosenDrugPA"
	,t."ChosenDrugSPID"
	,t."ChosenDrugConceptName"
	,t."ChosenDrugMaintenancePeriodic"
	,t."AltDrug"
	,t."AltDrugBrand"
	,t."AltDrugNDC"
	,t."AltDrugPA"
	,t."AltDrugSPID"
	,t."AltDrugConceptName"
	,t."AltDrugQuantity"
	,t."AltDrugDaysSupply"
	,t."ClaimDrug"
	,t."ClaimDrugBrand"
	,t."ClaimDate"
	,t."ClaimDrugNDC"
	,t."ClaimDrugSPID"
	,t."ClaimDrugConceptName"
	,t."ClaimDrugQuantity"
	,t."ClaimDrugDaysSupply"
	,t."ClaimDrugMaintenancePeriodic"
	,t."AnnualPatientSavings"
	,t."AnnualTotalSavings"
	,t."SwitchChangeMonth"
	,t."uid"
	,t."ChangeType"
	,t."org"
	,t."ProductLine"
	,t."Alt1Drug"
	,t."Alt1DrugGenericName"
	,t."Alt1DrugBrand"
	,t."Alt1DrugNDC"
	,t."Alt1DrugPA"
	,t."Alt1DrugSPID"
	,t."Alt1DrugConceptName"
	,t."Alt1DrugQuantity"
	,t."Alt1DrugDaysSupply"
	,t."Alt2Drug"
	,t."Alt2DrugGenericName"
	,t."Alt2DrugBrand"
	,t."Alt2DrugNDC"
	,t."Alt2DrugPA"
	,t."Alt2DrugSPID"
	,t."Alt2DrugConceptName"
	,t."Alt2DrugQuantity"
	,t."Alt2DrugDaysSupply"
	,t."Alt3Drug"
	,t."Alt3DrugGenericName"
	,t."Alt3DrugBrand"
	,t."Alt3DrugNDC"
	,t."Alt3DrugPA"
	,t."Alt3DrugSPID"
	,t."Alt3DrugConceptName"
	,t."Alt3DrugQuantity"
	,t."Alt3DrugDaysSupply"
	,t."ChosenMedInternalID"
	,t."requested_chosen_gpi"
	,t."mml_gpi"
	,t."alt1_gpi"
	,t."alt2_gpi"
	,t."alt3_gpi"
	,t."requested_chosen_patient_pay_amount"
	,t."requested_chosen_total_cost"
	,t."mml_patient_cost"
	,t."mml_total_cost"
	,t."alt1_patient_pay_amount"
	,t."alt1_total_cost"
	,t."alt2_patient_pay_amount"
	,t."alt2_total_cost"
	,t."alt3_patient_pay_amount"
	,t."alt3_total_cost"
	,t."carrier_id"
	,t."account_id"
	,t."group_id"
	,t."requested_chosen_super_concept"
	,t."mml_med_super_concept"
	,t."AdjustedPatientSavings"
	,t."AdjustedTotalSavings"
	,t."line_of_business"
	,t."fill_type"
	,t."mml_record_id"
	,case 	when t."ChosenDrugPA" = 'Y' and t."AltDrugPA" = 'N' then 'Y'  
			when t."ChosenDrugPA" = 'Y' and t."AltDrugPA" = 'Y' then 'N' 
			when t."ChosenDrugPA" = 'N' and t."AltDrugPA" = 'Y' then 'N'
			else null
	end as "PA_avoided"
	,t.is_alternative_fulfillment
from temp_output t
		left join rpt_bsc_ddp_claim_gpi_outcome_prep_data rhdcgop 
			on t.mml_record_id = rhdcgop.mml_record_id
	where rhdcgop."ChosenMedInternalID" is null
;
--create index "_I_rpt_bsc_ddp_claim_gpi_outcome_prep_data" on rpt_bsc_ddp_claim_gpi_outcome_prep_data using btree("ChosenMedInternalID","SwitchChangeMonth")
--;
--create index "_I_rpt_bsc_ddp_claim_gpi_outcome_prep_data_mml_record_id" on rpt_bsc_ddp_claim_gpi_outcome_prep_data using btree(mml_record_id)
--;

-- Remove DDP Brand to Generic
--drop table if exists temp_remove_BtoC;
create temp table temp_remove_BtoC as
select distinct rbd.uid
from public.rpt_bsc_ddp_claim_gpi_outcome_prep_data rbd
left join product_lookup pl on rbd."ChosenDrugNDC"::int8 = pl.ndc::int8
left join product_lookup pl2 on rbd."ClaimDrugNDC"::int8 = pl2.ndc::int8
where substring(requested_chosen_gpi,1,12)  =   substring(mml_gpi,1,12)
	and lower(pl.multi_source_code) = 'o' 
	and lower(pl2.multi_source_code) = 'y'
	and rbd.fill_type = 'New'
	and "ChangeType" in ('Tier 1','Tier 2');
	
--Set NAS for invalid switches
UPDATE rpt_bsc_ddp_claim_gpi_outcome_prep_data
SET "ChangeType" = 'NAS' 
FROM temp_remove_BtoC
WHERE temp_remove_BtoC.uid = rpt_bsc_ddp_claim_gpi_outcome_prep_data.uid
	and rpt_bsc_ddp_claim_gpi_outcome_prep_data."ChangeType" in ('Tier 1','Tier 2');

--Track first fill of alternative fulfillment
create temp table temp_update_chosen_med_alt_fill as
select uid, min("ClaimDate"::text||"mml_record_id") as first_alt_fill_claim
from public.rpt_bsc_ddp_claim_gpi_outcome_prep_data rbd
where "ChangeType" = 'Chosen Medication Found'
	and rbd.is_alternative_fulfillment
group by uid;

UPDATE rpt_bsc_ddp_claim_gpi_outcome_prep_data
SET "fill_type" = 'New' 
FROM temp_update_chosen_med_alt_fill
WHERE temp_update_chosen_med_alt_fill.uid = rpt_bsc_ddp_claim_gpi_outcome_prep_data.uid
	and rpt_bsc_ddp_claim_gpi_outcome_prep_data."ChangeType" = 'Chosen Medication Found'
	and temp_update_chosen_med_alt_fill.first_alt_fill_claim = rpt_bsc_ddp_claim_gpi_outcome_prep_data."ClaimDate"::text||rpt_bsc_ddp_claim_gpi_outcome_prep_data."mml_record_id"
;

------------End Reporting-------------
commit;$$);
