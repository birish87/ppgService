
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('BSC_DSRD_job_run_query_newnew', $$-- 'd' = e/d/p
-- 'bsc' = bsc
BEGIN;
------------Begin Previorus CI ------------------------- 
drop table if exists temp_previous_record;
create temp table temp_previous_record as
select "ExistingMedInternalID",bool_or(stop_tracking) as stop_tracking,min("ClaimDate") as "ClaimDate",min(mml_gpi) as mml_gpi,min("ChangeType") as "ChangeType"
from rpt_bsc_dsr_claim_gpi_outcome_prep_data
where fill_type = 'New' and "ProductLine" = upper('DSR-'|| 'd')
group by "ExistingMedInternalID"
;
------------End Previorus CI ------------------------- 

------------Begin Member ID Matching ------------------------- 
drop table if exists temp_aaa;
create temp table temp_aaa as
select aaa.id
,lower(trim(ip.cardholder_id)) as cardholder_id
,pat.birthdate::date as dob
,lower(trim(pat.last_name)) as patient_last_name
,lower(trim(pat.first_name)) as patient_first_name
,case 
	when lower(trim(pat.sex)) = 'male' then '1'
	when lower(trim(pat.sex)) = 'female' then '2' 
	when lower(trim(pat.sex)) = 'unknown' then '0'
	else null
end as gender
from aaa_reports aaa
join insurance_companies ic  on aaa.insurance_bin = ic.bin and aaa.insurance_pcn = ic.pcn
join payers pay on ic.payer_id = pay.id
join aaa_report_medications aaam on aaa.id = aaam.aaa_report_id and aaam.is_prescribed = true
join product_lookup ppl on aaam.ndc = ppl.ndc
join aaa_report_medications aaamed2 on aaam.id = aaamed2.prescribed_id and aaamed2.is_prescribed = false 
join product_lookup pl on aaamed2.ndc = pl.ndc
join patients pat on aaa.patient_id  = pat.id
join insurance_policies ip on pat.id = ip.patient_id
left join rpt_dsrd_transaction_detail rdtd on aaa.transaction_id = rdtd.transaction_id and lower(aaa.dsr_type) = 'd' and rdtd.dsrd_status_id = '5' and rdtd.published_date is not null and rdtd.is_removal is false--published DSRD
left join temp_previous_record rhdcgop on aaam.id = rhdcgop."ExistingMedInternalID"
where aaa.meets_criteria = true --only DSR with saving
	and lower(pay."name") = 'bsc'
	and lower(aaa.dsr_type) = 'd'
	and aaa.ehr_organization_id not in ('1','39') 
	and aaa.ehr_organization_id not ilike ('%test%') --exclude test data
	and ((rhdcgop."ExistingMedInternalID" is null and lower(aaa.dsr_type) = 'd' and rdtd.transaction_id is not null and cast(rdtd.published_date::date +'180 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date))
		or (rhdcgop."ExistingMedInternalID" is null and lower(aaa.dsr_type) in ('e','p') and cast(aaa.inserted_at::date +'180 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date))
		or (rhdcgop."ExistingMedInternalID" is not null and rhdcgop.stop_tracking = false and cast(rhdcgop."ClaimDate"::date +'365 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date)))
group by 1,2,3,4,5,6
;

create index "_I_temp_aaa_idx1" on temp_aaa using btree(dob,cardholder_id)
;
create index "_I_temp_aaa_idx2" on temp_aaa using btree(dob,patient_last_name,patient_first_name)
;

drop table if exists temp_cm;     
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
drop table if exists temp_fn;     
create temp table temp_fn as
select cl.date_of_birth,cl.patient_last_name, cl.patient_first_name_substring, cl.patient_gender_code
from (select dob, patient_last_name,substring(patient_first_name, 1, 3) as patient_first_name_substring,gender,COUNT(distinct cardholder_id) as fn_cnt
		from temp_aaa 
		group by 1,2,3,4) al
join (select date_of_birth, patient_last_name, substring(patient_first_name, 1, 3) as patient_first_name_substring,patient_gender_code,COUNT(distinct cardholder_id) as fn_cnt 
		from temp_cm
		group by 1,2,3,4) cl on al.dob = cl.date_of_birth and al.patient_last_name = cl.patient_last_name and al.patient_first_name_substring = cl.patient_first_name_substring and al.gender = cl.patient_gender_code
where al.fn_cnt = 1 and cl.fn_cnt = 1
group by 1,2,3,4
;
create index "_I_temp_fn_idx1" on temp_fn using btree(date_of_birth,patient_last_name,patient_first_name_substring,patient_gender_code)
;

drop table if exists tmp_match_cardholderid;
create temp table tmp_match_cardholderid as
select aaa.id, trim(cm.cardholder_id) as cardholder_id
from temp_aaa aaa
left join temp_fn tf on tf.date_of_birth = aaa.dob 
	and tf.patient_last_name = aaa.patient_last_name 
	and tf.patient_first_name_substring = substring(aaa.patient_first_name, 1, 3) 
	and tf.patient_gender_code = aaa.gender
join temp_cm cm on aaa.dob = cm.date_of_birth 
	and (aaa.cardholder_id = cm.cardholder_id or
			(regexp_replace(aaa.cardholder_id, '^0+', '') = cm.cardholder_id) or 
			(length(regexp_replace(aaa.cardholder_id, '^0+', '')) = 9 and regexp_replace(aaa.cardholder_id, '^0+', '')||'00' = cm.cardholder_id) or
			(substring(aaa.cardholder_id, 1, length(aaa.cardholder_id)-2) = cm.cardholder_id) or 
			(regexp_replace(substring(aaa.cardholder_id, 1, length(aaa.cardholder_id)-2), '^0+', '') = cm.cardholder_id) or
			(tf.date_of_birth is not null and tf.patient_last_name = cm.patient_last_name and tf.patient_first_name_substring = substring(cm.patient_first_name, 1, 3) and  tf.patient_gender_code = cm.patient_gender_code)
		)
group by 1,2
;

create index tmp_match_cardholderid_idx1 on tmp_match_cardholderid(id);
------------End Member ID Matching ------------------------- 


------------Begin Alter List----------------
-- Create alternative list temp table
drop table if exists temp_altermedlist;
create temp table temp_altermedlist
(patient_identifier varchar(255),
report_created_date date,
published_date date,
med_id int8,
med_display_name varchar(255),
med_ndc varchar(255),
med_brand varchar(1),
med_msc varchar(1),
med_specific_product_id int4,
med_med_type varchar(255),
med_quantity float8,
med_days_supply int,
med_calculation_days_supply int,
med_gpi_14 varchar(255),
med_gpi_12 varchar(255),
med_super_concept varchar(255),
med_patient_pay_amount float8,
med_total_cost float8,
med_manufacturer_name varchar(255),
alt_id int8,
alt_display_name varchar(255),
alt_brand varchar(1),
alt_msc varchar(1),
alt_prior_auth_needed varchar(1),
alt_ndc varchar(255),
alt_specific_product_id int4,
alt_med_type varchar(255),
alt_concept_name varchar(255),
alt_gpi_14 varchar(255),
alt_gpi_12 varchar(255),
alt_order int4,
alt_quantity float8,
alt_days_supply int,
alt_generic_name varchar(255),
alt_patient_pay_amount float8,
alt_total_cost float8,
alt_annual_patient_savings_v1 float8,
alt_annual_total_savings_v1 float8,
is_first_fill boolean,
first_fill_gpi_12 varchar(255),
first_fill_claim_date date,
first_fill_change_type varchar(255)
)
;

-- Insert alternative for switch analysis
insert into temp_altermedlist
select distinct 
lower(pay."name"||trim(tmc.cardholder_id)||aaa.dob::date) as patient_identifier
,aaa.inserted_at::date as report_created_date
,rdtd.published_date::date as published_date
,aaam.id as med_id
,aaam.display_name as med_display_name
,aaam.ndc as med_ndc
,case
	when ppl.brand = true then 'Y'
	when ppl.brand = false then 'N'
end as med_brand
,ppl.multi_source_code as med_msc
,ppl.specific_product_id as med_specific_product_id
,case
	when ppl.maintenance = true then 'M'	--Maintenance
	when ppl.maintenance = false and ppl.periodic = true then 'P'	--Periodic
	when ppl.maintenance = false and ppl.periodic = false then 'A'	--Acute
end as med_med_type
,aaam.quantity as med_quantity
,aaam.days_supply as med_days_supply
,case 
	when aaam.days_supply > 30 then aaam.days_supply
	else 30
end as med_calculation_days_supply
,ppl.gpi as med_gpi_14 --Existing Med GPI
,substring(ppl.gpi,1,12) as med_gpi_12 --Existing Med GPI12
,ppe.super_concept as med_super_concept
,aaam.patient_pay_amount as med_patient_pay_amount
,aaam.total_cost as med_total_cost
,ppl.manufacturer_name as med_manufacturer_name
,aaamed2.id as alt_id
,aaamed2.display_name as alt_display_name
,case
	when pl.brand = true then 'Y'
	when pl.brand = false then 'N' 
end as alt_brand
,pl.multi_source_code as alt_msc
,case 
	when aaamed2.prior_auth_needed = true then 'Y'
	when aaamed2.prior_auth_needed = false then 'N' 
end as alt_prior_auth_needed
,aaamed2.ndc as alt_ndc
,pl.specific_product_id as alt_specific_product_id
, case
	when pl.maintenance = true then 'M'	--Maintenance
	when pl.maintenance = false and pl.periodic = true then 'P'	--Periodic
	when pl.maintenance = false and pl.periodic = false then 'A'	--Acute
end as alt_med_type
,pe.concept_name as alt_concept_name
,pl.gpi as alt_gpi_14 --Alt Med GPI14
,substring(pl.gpi,1,12) as alt_gpi_12 --Alt Med GPI12
,aaamed2.display_order_number as alt_order
,aaamed2.quantity as alt_quantity
,aaamed2.days_supply as alt_days_supply
,pe.generic_drug_item_name as alt_generic_name
,aaamed2.patient_pay_amount as alt_patient_pay_amount
,aaamed2.total_cost as alt_total_cost
,aaamed2.annual_patient_savings as alt_annual_patient_savings_v1
,aaamed2.annual_total_savings as alt_annual_total_savings_v1
,case
	when rhdcgop."ExistingMedInternalID" is not null then true
	else false
end as is_first_fill
,case 
	when rhdcgop.mml_gpi is not null then substring(rhdcgop.mml_gpi,1,12) 
	else null
end as first_fill_gpi_12
,rhdcgop."ClaimDate" as first_fill_claim_date
,rhdcgop."ChangeType" as first_fill_change_type
from aaa_reports aaa
join tmp_match_cardholderid tmc on tmc.id = aaa.id
join insurance_companies ic  on aaa.insurance_bin = ic.bin and aaa.insurance_pcn = ic.pcn
join payers pay on ic.payer_id = pay.id
join aaa_report_medications aaam on aaa.id = aaam.aaa_report_id and aaam.is_prescribed = true
join product_lookup ppl on aaam.ndc = ppl.ndc
join aaa_report_medications aaamed2 on aaam.id = aaamed2.prescribed_id and aaamed2.is_prescribed = false 
join product_lookup pl on aaamed2.ndc = pl.ndc
left join rpt_dsrd_transaction_detail rdtd on aaa.transaction_id = rdtd.transaction_id and lower(aaa.dsr_type) = 'd' and rdtd.dsrd_status_id = '5' and rdtd.published_date is not null and rdtd.is_removal is false--published DSRD
left join product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
left join product_equivalencies ppe on ppl.specific_product_id = ppe.specific_product_id
left join temp_previous_record rhdcgop on aaam.id = rhdcgop."ExistingMedInternalID"
where aaa.meets_criteria = true --only DSR with saving
	and lower(pay."name") = 'bsc'
	and lower(aaa.dsr_type) = 'd'
	and aaa.ehr_organization_id not in ('1','39') 
	and aaa.ehr_organization_id not ilike ('%test%') --exclude test data
	and ((rhdcgop."ExistingMedInternalID" is null and lower(aaa.dsr_type) = 'd' and rdtd.transaction_id is not null and cast(rdtd.published_date::date +'180 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date))
		or (rhdcgop."ExistingMedInternalID" is null and lower(aaa.dsr_type) in ('e','p') and cast(aaa.inserted_at::date +'180 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date))
		or (rhdcgop."ExistingMedInternalID" is not null and rhdcgop.stop_tracking = false and cast(rhdcgop."ClaimDate"::date +'365 day'::interval as date) >= cast(date_trunc('month', current_date - '1 month'::interval) as date)))
;

create index "_I_temp_altermedlist_patient_identifier" on temp_altermedlist using btree(patient_identifier,published_date,med_gpi_12,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_2" on temp_altermedlist using btree(patient_identifier,published_date,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_3" on temp_altermedlist using btree(patient_identifier,published_date,med_gpi_12,med_super_concept,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_4" on temp_altermedlist using btree(patient_identifier,published_date,med_super_concept)
;
create index "_I_temp_altermedlist_patient_identifier_5" on temp_altermedlist using btree(patient_identifier,report_created_date,med_gpi_12,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_6" on temp_altermedlist using btree(patient_identifier,report_created_date,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_7" on temp_altermedlist using btree(patient_identifier,report_created_date,med_gpi_12,med_super_concept,alt_gpi_12)
;
create index "_I_temp_altermedlist_patient_identifier_8" on temp_altermedlist using btree(patient_identifier,report_created_date,med_super_concept)
;
create index "_I_temp_altermedlist_med_id" on temp_altermedlist using btree(med_id)
;
create index "_I_temp_altermedlist_alt_order" on temp_altermedlist using btree(alt_order)
;
------------End Alter List----------------

------------Begin Claim History  --------------------
drop table if exists temp_bsc_claims;
create temp table temp_bsc_claims as
select rbch.patient_identifier
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
,pe.concept_name
,pe.super_concept as med_super_concept
,case 
	when rbch.days_supply > 30 then rbch.days_supply
	else 30
end as calculation_days_supply
,pl.manufacturer_name 
from rpt_bsc_claim_history rbch
join product_lookup pl on rbch.med_ndc = pl.ndc
left join product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
where rbch.date_of_service::date between cast((date_trunc('month', current_date)- '1 second'::interval)- '485 day'::interval as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
;

create index "_I_temp_bsc_claims_patient_identifier_gpi12" on temp_bsc_claims using btree(new_patient_identifier,gpi_12)
;
create index "_I_temp_bsc_claims_patient_identifier_dos_gpi12" on temp_bsc_claims using btree(new_patient_identifier,date_of_service,gpi_12)
;
create index "_I_temp_bsc_claims_patient_identifier_dos_med_super_concept" on temp_bsc_claims using btree(new_patient_identifier,date_of_service,med_super_concept,gpi_12)
;
----------- End Claim History ---------------------

------------Begin Reporting-------------
------------Begin identifying DSR with existing medication claim found ------------------------------------------------
drop table if exists temp_bsc_existing_med_found_list;
create temp table temp_bsc_existing_med_found_list as
select distinct thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.published_date
	,alt.report_created_date::date as report_created_date
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,null as alt_spid
	,null as alt_med_type
	,null as alt_concept
	--,null as alt_annual_patient_savings 
	--,null as alt_annual_total_savings 
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
	,date_part('year',thlmc.date_of_service)::text || LPAD(date_part('month',thlmc.date_of_service)::text, 2, '0') as switch_change_month
	,'Existing Medication Found' as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.gpi_12 as mml_gpi_12
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,thlmc.med_super_concept as mml_med_super_concept
	,false as is_first_fill
from temp_altermedlist alt
join temp_bsc_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and (
			(alt.med_gpi_12 is not null 
				and thlmc.gpi_12 is not null 
				and (alt.med_gpi_12 = thlmc.gpi_12 and 
							((upper(alt.med_msc) = 'N' and upper(thlmc.med_msc) = 'N')
							or (upper(alt.med_msc) = 'M' and upper(thlmc.med_msc) = 'M')
							or (upper(alt.med_msc) = 'O' and upper(thlmc.med_msc) = 'O')
							or (upper(alt.med_msc) = 'Y' and upper(thlmc.med_msc) in ('O','Y')))
					)-- Existing Medication & Resulting Medication with same GPI-12s 
			)
			or trim(lower(alt.med_display_name)) = trim(lower(thlmc.med_name)) -- Existing Medication & Resulting Medication with same med name
		)
where 
	(('d' in ('e','p') and thlmc.date_of_service::date >= alt.report_created_date::date) or ('d' = 'd' and thlmc.date_of_service::date > alt.published_date::date)) --DSR is not possible in user hand on DSR create date because clinical review
	and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;

-- Create Key table filtering
drop table if exists temp_bsc_existing_med_found_keys;
create temp table temp_bsc_existing_med_found_keys as
select distinct med_id,mml_claim_date
from temp_bsc_existing_med_found_list
;

create index "_I_temp_bsc_existing_med_found_keys_med_id" on temp_bsc_existing_med_found_keys using btree(med_id,mml_claim_date)
;

--If existing med found after First Fill, set stop_tracking
update rpt_bsc_dsr_claim_gpi_outcome_prep_data rbdcgipd
set stop_tracking = true
from temp_bsc_existing_med_found_keys tbemdk
where tbemdk.med_id = rbdcgipd."ExistingMedInternalID" and rbdcgipd.fill_type = 'New' and rbdcgipd."ProductLine" = upper('DSR-'||'d') and rbdcgipd.stop_tracking = false;
---------------End Remove No Switch ------------------------------------------------

--------------- Begin Recurring Fill Monitoring --------------------------------------
drop table if exists temp_recurring_prematches;
create temp table temp_recurring_prematches as
select distinct thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.published_date
	,alt.report_created_date::date as report_created_date
	,alt.alt_display_name as alt_med
	,alt.alt_brand
	,alt.alt_prior_auth_needed  as alt_pa
	,alt.alt_ndc
	,alt.alt_specific_product_id as alt_spid
	,alt.alt_med_type
	,alt.alt_concept_name as alt_concept
	,case 
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount/alt.med_days_supply)*365)-((thlmc.patient_cost/thlmc.days_supply)*365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount/alt.med_days_supply)*135)-((thlmc.patient_cost/thlmc.days_supply)*135))
	end as alt_annual_patient_savings 
	,case 
		when lower(alt.med_med_type) = 'm' and (alt.first_fill_change_type is null or alt.first_fill_change_type = 'Tier 1') and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) >= (-250::float8/alt.med_calculation_days_supply)) then (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply))*365)
		when lower(alt.med_med_type) = 'p' and (alt.first_fill_change_type is null or alt.first_fill_change_type = 'Tier 1') and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) >= (-250::float8/alt.med_calculation_days_supply)) then (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply))*135)
		when lower(alt.med_med_type) = 'm' and (alt.first_fill_change_type is null or alt.first_fill_change_type = 'Tier 1') and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) < (-250::float8/alt.med_calculation_days_supply)) then ((-250::float8/alt.med_calculation_days_supply)*365)
		when lower(alt.med_med_type) = 'p' and (alt.first_fill_change_type is null or alt.first_fill_change_type = 'Tier 1') and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) < (-250::float8/alt.med_calculation_days_supply)) then ((-250::float8/alt.med_calculation_days_supply)*135)
		when lower(alt.med_med_type) = 'm' and alt.first_fill_change_type is not null and alt.first_fill_change_type = 'Tier 2' then (((alt.med_total_cost/alt.med_calculation_days_supply)*365)-((thlmc.total_cost/thlmc.calculation_days_supply)*365))
		when lower(alt.med_med_type) = 'p' and alt.first_fill_change_type is not null and alt.first_fill_change_type = 'Tier 2' then (((alt.med_total_cost/alt.med_calculation_days_supply)*135)-((thlmc.total_cost/thlmc.calculation_days_supply)*135))
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
	,date_part('year',thlmc.date_of_service)::text || LPAD(date_part('month',thlmc.date_of_service)::text, 2, '0') as switch_change_month
	,case 
		--when alt.first_fill_change_type is not null and alt.first_fill_gpi_12 = thlmc.gpi_12 and alt.first_fill_change_type = 'Tier 2' and ex.id is not null and not ex.inactive then 'Switch Exclusion' 
		when alt.first_fill_change_type is not null and alt.first_fill_gpi_12 = thlmc.gpi_12 then alt.first_fill_change_type
		else 'Tier 1'
	end as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.gpi_12 as mml_gpi_12
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,alt.alt_annual_patient_savings_v1
	,alt.alt_annual_total_savings_v1
	,thc.new_patient_identifier -- if patient has used the resulting med previous, this column has value
	,case 
		when 'd' = 'd' then alt.published_date::date-thc.date_of_service::date 
		when 'd' in ('e','p') then alt.report_created_date::date-thc.date_of_service::date 
	end as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
	,alt.is_first_fill
from temp_altermedlist alt
join temp_bsc_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and (('d' in ('e','p') and thlmc.date_of_service::date >= alt.report_created_date::date) or ('d' = 'd' and thlmc.date_of_service::date > alt.published_date::date))
	and alt.med_gpi_12 is not null 
	and thlmc.gpi_12 is not null 
	and (alt.med_gpi_12 <> thlmc.gpi_12
			or (alt.med_gpi_12 = thlmc.gpi_12 and 
					((upper(alt.med_msc) = 'M' and upper(thlmc.med_msc) in ('N','O','Y'))
					or (upper(alt.med_msc) = 'N' and upper(thlmc.med_msc) in ('M','O','Y'))
					or (upper(alt.med_msc) = 'O' and upper(thlmc.med_msc) in ('N','M','Y'))
					or (upper(alt.med_msc) = 'Y' and upper(thlmc.med_msc) in ('N','M')))
				) -- Existing Medication & Resulting Medication with same GPI-12s 
		)
	and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
	and (	(alt.first_fill_gpi_12 is not null
				and thlmc.gpi_12 is not null 
				and alt.first_fill_gpi_12 = thlmc.gpi_12)--match first fill with GPI12
			or 
			(alt.alt_gpi_12 is not null 
				and thlmc.gpi_12 is not null 
				and alt.alt_gpi_12 = thlmc.gpi_12)--match alternative with GPI12
		) 
left join temp_bsc_claims thc on alt.patient_identifier = thc.new_patient_identifier 
    and (('d' in ('e','p') and thc.date_of_service::date < alt.report_created_date::date) or ('d' = 'd' and thc.date_of_service::date <= alt.published_date::date))
	and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
	and ((thlmc.gpi_12 is not null 
			and thc.gpi_12 is not null 
			and thlmc.gpi_12 = thc.gpi_12
			and upper(thlmc.med_msc) = upper(thc.med_msc)) or (thlmc.med_name = thc.med_name)) --resulting medication was not filled in the past 120 days
left join temp_bsc_existing_med_found_keys themdk on alt.med_id = themdk.med_id and to_char(themdk.mml_claim_date::date, 'YYYY-MM') = to_char(thlmc.date_of_service::date, 'YYYY-MM') --Existing can't happen during recurring
/*left join rpt_exclusion_list ex on upper(trim(alt.med_gpi_14)) = upper(trim(ex.existing_med_gpi14))
		and lower(trim(alt.med_manufacturer_name)) = lower(trim(ex.existing_med_manufacturer)) --Existing Med & Excluded Med with same GPI14 and Manufacturer Name AND
		and upper(trim(thlmc.gpi_14)) = upper(trim(ex.resulting_med_gpi14))
		and lower(trim(thlmc.manufacturer_name)) = lower(trim(ex.resulting_med_manufacturer)) --Resulting Med & Excluded Med with same GPI14 and Manufacturer Name 
*/
where alt.is_first_fill
		and thlmc.date_of_service::date > alt.first_fill_claim_date -- Recurring Fill DOS must be greater than the First Fill DOS 
		and cast(alt.first_fill_claim_date +'365 day'::interval as date) >= thlmc.date_of_service::date-- Recurring Fill DOS must be less than or equal to the First Fill DOS + 365 days
		and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			)
		and themdk.med_id is null -- no existing med found after resulting med
;

drop table if exists temp_recurring_matches;
create temp table temp_recurring_matches as
select distinct ttp.patient_identifier 
	,ttp.med_id
	,ttp.med_gpi_14
	,ttp.published_date
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
	,ttp.mml_gpi_12
	,ttp.carrier_id
	,ttp.account_id
	,ttp.group_id
	,ttp.alt_annual_patient_savings_v1
	,ttp.alt_annual_total_savings_v1
	,ttp.mml_med_super_concept
	,ttp.is_first_fill
	,case 
		when 'd' = 'd' and ttp.change_type = 'Tier 1' then ttp.published_date||'z'||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
		when 'd' = 'd' then ttp.published_date||'a'||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
		when 'd' in ('e','p') and ttp.change_type = 'Tier 1' then ttp.report_created_date||'z'||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
		when 'd' in ('e','p') then ttp.report_created_date||'a'||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
	end as priority_index
from temp_recurring_prematches ttp
left join temp_recurring_prematches ttpf on ttp.med_id = ttpf.med_id and ttpf.lookback_days < 120
where ttp.new_patient_identifier is null or ttpf.med_id is null
;
create index "_I_temp_recurring_matches_mml_record_id" on temp_recurring_matches using btree(mml_record_id)
;
create index "_I_temp_recurring_matches_priority_index" on temp_recurring_matches using btree(priority_index)
;


--If a claim matched mulitple recurring CI, pick most recent T1 transaction. If not then most recent T2
drop table if exists temp_recurring_multi_dsr_same_claim;
create temp table temp_recurring_multi_dsr_same_claim as
select cttm.mml_record_id, max(cttm.priority_index) as max_priority_index
from temp_recurring_matches cttm
group by cttm.mml_record_id
;

create index "_I_temp_recurring_multi_dsr_same_claim_mml_record_id" on temp_recurring_multi_dsr_same_claim using btree(mml_record_id)
;
create index "_I_temp_recurring_multi_dsr_same_claim_max_priority_index" on temp_recurring_multi_dsr_same_claim using btree(max_priority_index)
;

--In case the claim match multiple alternative of an existing medication, select the most saving (smallest alternative older)
drop table if exists temp_recurring_list;
create temp table temp_recurring_list as
select distinct trm.*,row_number() over (partition by trm.med_id, trm.mml_claim_date order by trm.alt_annual_total_savings desc) as most_savings_order
from temp_recurring_matches trm
join temp_recurring_multi_dsr_same_claim trmdsc on trm.priority_index = trmdsc.max_priority_index
;
create index "_I_temp_recurring_list_med_id_most_savings_order" on temp_recurring_list using btree(med_id,most_savings_order)
;

-- Create Key table for recurring
drop table if exists temp_ci_keys;
create temp table temp_ci_keys as
select distinct med_id
from temp_recurring_list
;
--------------- End Recurring Fill Checking ----------------------------------------

---------------Begin Tier 1 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
drop table if exists temp_new_tier1_prematches;
create temp table temp_new_tier1_prematches as
select distinct thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.published_date
	,alt.report_created_date::date as report_created_date
	,alt.alt_display_name as alt_med
	,alt.alt_brand
	,alt.alt_prior_auth_needed  as alt_pa
	,alt.alt_ndc
	,alt.alt_specific_product_id as alt_spid
	,alt.alt_med_type
	,alt.alt_concept_name as alt_concept
	,case 
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount/alt.med_days_supply)*365)-((thlmc.patient_cost/thlmc.days_supply)*365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount/alt.med_days_supply)*135)-((thlmc.patient_cost/thlmc.days_supply)*135))
	end as alt_annual_patient_savings 
	,case 
		when lower(alt.med_med_type) = 'm' and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) >= (-250::float8/alt.med_calculation_days_supply)) then (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply))*365)
		when lower(alt.med_med_type) = 'p' and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) >= (-250::float8/alt.med_calculation_days_supply)) then (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply))*135)
		when lower(alt.med_med_type) = 'm' and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) < (-250::float8/alt.med_calculation_days_supply)) then ((-250::float8/alt.med_calculation_days_supply)*365)
		when lower(alt.med_med_type) = 'p' and (((alt.med_total_cost/alt.med_calculation_days_supply)-(thlmc.total_cost/thlmc.calculation_days_supply)) < (-250::float8/alt.med_calculation_days_supply)) then ((-250::float8/alt.med_calculation_days_supply)*135)
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
	,date_part('year',thlmc.date_of_service)::text || LPAD(date_part('month',thlmc.date_of_service)::text, 2, '0') as switch_change_month
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
	,thc.new_patient_identifier -- if patient has used the resulting med previous, this column has value
	,case 
		when 'd' = 'd' then alt.published_date::date-thc.date_of_service::date 
		when 'd' in ('e','p') then alt.report_created_date::date-thc.date_of_service::date 
	end as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
	,alt.is_first_fill
from temp_altermedlist alt
join temp_bsc_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and (('d' in ('e','p') and thlmc.date_of_service::date >= alt.report_created_date::date) or ('d' = 'd' and thlmc.date_of_service::date > alt.published_date::date))
	and alt.med_gpi_12 is not null 
	and thlmc.gpi_12 is not null 
	and (alt.med_gpi_12 <> thlmc.gpi_12
			or (alt.med_gpi_12 = thlmc.gpi_12 and 
					((upper(alt.med_msc) = 'M' and upper(thlmc.med_msc) in ('N','O','Y'))
					or (upper(alt.med_msc) = 'N' and upper(thlmc.med_msc) in ('M','O','Y'))
					or (upper(alt.med_msc) = 'O' and upper(thlmc.med_msc) in ('N','M','Y'))
					or (upper(alt.med_msc) = 'Y' and upper(thlmc.med_msc) in ('N','M')))
				) -- Existing Medication & Resulting Medication with same GPI-12s 
		)
	and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
	and (alt.alt_gpi_12 is not null 
			and thlmc.gpi_12 is not null 
			and alt.alt_gpi_12 = thlmc.gpi_12) --Only match alternative with GPI12
left join temp_bsc_claims thc on alt.patient_identifier = thc.new_patient_identifier 
	and (('d' in ('e','p') and thc.date_of_service::date < alt.report_created_date::date) or ('d' = 'd' and thc.date_of_service::date <= alt.published_date::date))
	and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
	and ((thlmc.gpi_12 is not null 
			and thc.gpi_12 is not null 
			and thlmc.gpi_12 = thc.gpi_12
			and upper(thlmc.med_msc) = upper(thc.med_msc)) or (thlmc.med_name = thc.med_name)) --resulting medication was not filled in the past 12
left join temp_bsc_existing_med_found_keys themdk on alt.med_id = themdk.med_id and themdk.mml_claim_date::date >= thlmc.date_of_service::date
left join temp_recurring_multi_dsr_same_claim trmdsc on thlmc.id = trmdsc.mml_record_id
where alt.is_first_fill = false --no first fill yet
		and (('d' = 'd' and cast(alt.published_date::date +'180 day'::interval as date) >= thlmc.date_of_service::date) 
			or ('d' in ('e','p') and cast(alt.report_created_date::date +'180 day'::interval as date) >= thlmc.date_of_service::date))
		and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
		and themdk.med_id is null -- no existing med found after resulting med
		and trmdsc.mml_record_id is null --claim was not used for CI previously
;

drop table if exists temp_new_tier1_matches;
create temp table temp_new_tier1_matches as
select distinct ttp.patient_identifier 
	,ttp.med_id
	,ttp.med_gpi_14
	,ttp.published_date
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
	,ttp.is_first_fill
	,case 
		when 'd' = 'd' then ttp.published_date||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
		when 'd' in ('e','p') then ttp.report_created_date||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
	end as priority_index
from temp_new_tier1_prematches ttp
left join temp_new_tier1_prematches ttpf on ttp.med_id = ttpf.med_id and ttpf.lookback_days < 120
where ttp.new_patient_identifier is null or ttpf.med_id is null
;

--If a claim matched mulitple recurring CI, pick most recent T1 transaction. If not then most recent T2
drop table if exists temp_t1_multi_dsr_same_claim;
create temp table temp_t1_multi_dsr_same_claim as
select cttm.mml_record_id, max(cttm.priority_index) as max_priority_index
from temp_new_tier1_matches cttm
group by cttm.mml_record_id
;
create index "_I_temp_t1_multi_dsr_same_claim_mml_record_id" on temp_t1_multi_dsr_same_claim using btree(mml_record_id)
;
create index "_I_temp_t1_multi_dsr_same_claim_max_priority_index" on temp_t1_multi_dsr_same_claim using btree(max_priority_index)
;

--In case the claim match multiple alternative of an existing medication, select the most saving (smallest alternative older)
drop table if exists temp_t1_list;
create temp table temp_t1_list as
select distinct trm.*,row_number() over (partition by trm.med_id, trm.mml_claim_date order by trm.alt_annual_total_savings desc) as most_savings_order
from temp_new_tier1_matches trm
join temp_t1_multi_dsr_same_claim trmdsc on trm.priority_index = trmdsc.max_priority_index and trm.mml_record_id = trmdsc.mml_record_id
;
create index "_I_temp_t1_list_med_id_most_savings_order" on temp_t1_list using btree(med_id,most_savings_order)
;

-- Insert Key  for T1
insert into temp_ci_keys 
select distinct med_id
from temp_t1_list
;
---------------End  Tier 1 ------------------------------------------------

---------------Begin Tier 2 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
drop table if exists temp_tier2_prematches;
create temp table temp_tier2_prematches as
select distinct thlmc.new_patient_identifier as patient_identifier
	,alt.med_id
	,alt.med_gpi_14
	,alt.published_date
	,alt.report_created_date::date as report_created_date
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,0 as alt_spid
	,null as alt_med_type
	,null as alt_concept
	,case 
		when lower(alt.med_med_type) = 'm' then (((alt.med_patient_pay_amount/alt.med_days_supply)*365)-((thlmc.patient_cost/thlmc.days_supply)*365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_patient_pay_amount/alt.med_days_supply)*135)-((thlmc.patient_cost/thlmc.days_supply)*135))
	end as alt_annual_patient_savings 
	,case 
		when lower(alt.med_med_type) = 'm' then (((alt.med_total_cost/alt.med_calculation_days_supply)*365)-((thlmc.total_cost/thlmc.calculation_days_supply)*365))
		when lower(alt.med_med_type) = 'p' then (((alt.med_total_cost/alt.med_calculation_days_supply)*135)-((thlmc.total_cost/thlmc.calculation_days_supply)*135))
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
	,date_part('year',thlmc.date_of_service)::text || LPAD(date_part('month',thlmc.date_of_service)::text, 2, '0') as switch_change_month
	--,case when ex.id is not null and not ex.inactive then 'Switch Exclusion' else 'Tier 2' end as change_type
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
	,case 
		when 'd' = 'd' then alt.published_date::date-thc.date_of_service::date 
		when 'd' in ('e','p') then alt.report_created_date::date-thc.date_of_service::date 
	end as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
	,alt.is_first_fill
from temp_altermedlist alt
join temp_bsc_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and (('d' in ('e','p') and thlmc.date_of_service::date >= alt.report_created_date::date) or ('d' = 'd' and thlmc.date_of_service::date > alt.published_date::date))
	and ( alt.med_gpi_12 is not null 
			and thlmc.gpi_12 is not null 
			and (alt.med_gpi_12 <> thlmc.gpi_12)
		)
	and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
	and (alt.med_super_concept is not null
			and thlmc.med_super_concept is not null
			and upper(alt.med_super_concept) = upper(thlmc.med_super_concept)) --Super Concept match between Existing and Claim Med (resulting med)
left join temp_bsc_claims thc on alt.patient_identifier = thc.new_patient_identifier 
	and (('d' in ('e','p') and thc.date_of_service::date < alt.report_created_date::date) or ('d' = 'd' and thc.date_of_service::date <= alt.published_date::date))
	and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
	and ((thlmc.gpi_12 is not null 
		and thc.gpi_12 is not null 
		and thlmc.gpi_12 = thc.gpi_12
		and upper(thlmc.med_msc) = upper(thc.med_msc)) or (thlmc.med_name = thc.med_name))  --resulting medication was not filled in the past 120
left join temp_bsc_existing_med_found_keys themdk on alt.med_id = themdk.med_id and themdk.mml_claim_date::date >= thlmc.date_of_service::date --for indentifying Tier 1 and Existing Med Found within same month
left join temp_recurring_multi_dsr_same_claim trmdsc on thlmc.id = trmdsc.mml_record_id
left join temp_t1_multi_dsr_same_claim tt1mdsc on thlmc.id = tt1mdsc.mml_record_id
where alt.is_first_fill = false
		and (('d' = 'd' and cast(alt.published_date::date +'180 day'::interval as date) >= thlmc.date_of_service::date) 
			or ('d' in ('e','p') and cast(alt.report_created_date::date +'180 day'::interval as date) >= thlmc.date_of_service::date))-- First Fill DOS must be less than or equal to the published date + 180 days 
		and ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.adjudication_datetime::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		) 
		and themdk.med_id is null -- no existing med found after resulting med
		and trmdsc.mml_record_id is null --claim was not used for recurring CI previously
		and tt1mdsc.mml_record_id is null --claim was not used for T1 CI previously
;

drop table if exists temp_tier2_matches;
create temp table temp_tier2_matches as
select distinct ttp.patient_identifier 
	,ttp.med_id
	,ttp.med_gpi_14
	,ttp.published_date
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
	,ttp.is_first_fill
	,case 
		when 'd' = 'd' then ttp.published_date||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
		when 'd' in ('e','p') then ttp.report_created_date||LPAD(ttp.alt_annual_total_savings::text,10,'0')||ttp.med_id
	end as priority_index
from temp_tier2_prematches ttp
left join temp_tier2_prematches ttpf on ttp.med_id = ttpf.med_id and ttpf.lookback_days < 120
where ttp.alt_annual_total_savings >= 0 and (ttp.new_patient_identifier is null or ttpf.med_id is null)
;

--If a claim matched mulitple recurring CI, pick most recent T1 transaction. If not then most recent T2
drop table if exists temp_t2_multi_dsr_same_claim;
create temp table temp_t2_multi_dsr_same_claim as
select cttm.mml_record_id, max(cttm.priority_index) as max_priority_index
from temp_tier2_matches cttm
group by cttm.mml_record_id
;

create index "_I_temp_t2_multi_dsr_same_claim_mml_record_id" on temp_t2_multi_dsr_same_claim using btree(mml_record_id)
;
create index "_I_temp_t2_multi_dsr_same_claim_max_priority_index" on temp_t2_multi_dsr_same_claim using btree(max_priority_index)
;

--In case the claim match multiple alternative of an existing medication, select the most saving (smallest alternative older)
drop table if exists temp_t2_list;
create temp table temp_t2_list as
select distinct trm.*,row_number() over (partition by trm.med_id, trm.mml_claim_date order by trm.alt_annual_total_savings desc) as most_savings_order
from temp_tier2_matches trm
join temp_t2_multi_dsr_same_claim trmdsc on trm.priority_index = trmdsc.max_priority_index and trm.mml_record_id = trmdsc.mml_record_id
;
create index "_I_temp_t2_list_med_id_most_savings_order" on temp_t2_list using btree(med_id,most_savings_order)
;

-- Insert Key  for T2
insert into temp_ci_keys 
select distinct med_id
from temp_t2_list
;
---------------End  Tier 2 ------------------------------------------------

---------------Begin Add Existing Med found records----------------------------------
insert into temp_ci_keys
select distinct themdk.med_id
from temp_bsc_existing_med_found_keys themdk
left join temp_ci_keys tck on themdk.med_id = tck.med_id
where tck.med_id is null
;
---------------End Add Existing Med found records----------------------------------

--Add Index back
create index "_I_temp_ci_keys" on temp_ci_keys using btree(med_id)
;

--------------- New Tier 1 & 2 Result Consolidation ---------------
drop table if exists temp_new_ci_pre_list;
create temp table temp_new_ci_pre_list as
select ttl.*,row_number() over (partition by ttl.med_id order by ttl.mml_claim_date,ttl.change_type,ttl.most_savings_order) as fil_type_code
from (select *
from temp_t1_list
union 
select *
from temp_t2_list) ttl
;

drop table if exists temp_new_ci_list;
create temp table temp_new_ci_list as
select tncpl1.*
from temp_new_ci_pre_list tncpl1
left join temp_new_ci_pre_list tncpl2 on tncpl1.med_id = tncpl2.med_id and tncpl2.change_type='Tier 1' and tncpl2.fil_type_code = 1 
where tncpl2.med_id is null or (tncpl2.med_id is not null and tncpl1.change_type='Tier 1')
;
---------------------------------------------------------------

----------------Begin Temp public.insurance_policies----------------------------------------------
drop table if exists temp_insurance_policies;
create temp table temp_insurance_policies as
select patient_id,line_of_business
from public.insurance_policies
;

create index "_I_temp_insurance_policies" on temp_insurance_policies using btree(patient_id)
;
----------------End temp public.insurance_policies-----------------------------------------------

---------------Begin Create DSR Raw data ------------------------------------
drop table if exists temp_dsr_report;
create temp table temp_dsr_report as
select distinct aaa.ehr_organization_id
,aaa.transaction_id
,rdrt.run_name
,aaam.id as med_id
,aaa.dsr_type
,aaa.inserted_at
,aaa.encounter_prescriber_last_name || ', ' || aaa.encounter_prescriber_first_name as prescriber_name
,phy.npi as prescriber_npi
,org.name as org_name
,aaam.display_name as requested_existing_medication
,aaam.quantity
,aaam.days_supply
,aaa.pharmacy_npi
,case
	when pl.brand = true then 'Y'
	when pl.brand = false then 'N' 
end as requested_existing_brand
,case
	when aaam.prior_auth_needed = true then 'Y'
	when aaam.prior_auth_needed = false then 'N'
end as requested_existing_pa
,aaam.ndc as requested_existing_ndc
,aaam.patient_pay_amount as requested_existing_patient_pay_amount
,aaam.total_cost as requested_existing_total_cost
,pl.specific_product_id as requested_existing_spid
, case
	when pl.maintenance = true then 'M'	--Maintenance
	when pl.maintenance = false and pl.periodic = true then 'P'	--Periodic
	when pl.maintenance = false and pl.periodic = false then 'A'	--Acute
end as requested_existing_med_type
,pl.gpi as requested_existing_gpi
,pe.concept_name as requested_existing_concept_name
,aaa.ehr_patient_id
,aaa.insurance_bin as bin
,aaa.insurance_pcn as pcn
--ALT 1
,alt1.alt_display_name as alt1_med
,alt1.alt_generic_name as alt1_generic_name
,alt1.alt_days_supply as alt1_days_supply
,alt1.alt_quantity as alt1_medication_quantity
,alt1.alt_brand as alt1_brand
,alt1.alt_prior_auth_needed  as alt1_pa
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
,alt2.alt_prior_auth_needed  as alt2_pa
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
,pe.super_concept as requested_existing_super_concept
,ip.line_of_business
from public.aaa_reports aaa
left join public.rpt_dsrd_run_transactions rdrt on rdrt.transaction_id = aaa.transaction_id
join public.aaa_report_medications aaam on aaa.id = aaam.aaa_report_id and aaam.is_prescribed = true
join temp_ci_keys ett on aaam.id = ett.med_id --Matched results existing_med_found + Tier 1 + Tier 2
join public.insurance_companies ic  on aaa.insurance_bin = ic.bin and aaa.insurance_pcn = ic.pcn
left join public.patients p2 on aaa.patient_id = p2.id
left join temp_insurance_policies ip on p2.id = ip.patient_id
join public.payers pay on ic.payer_id = pay.id
join public.organizations org on aaa.ehr_organization_id = org.ehr_organization_id 
join public.product_lookup pl on aaam.ndc = pl.ndc
left join public.product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
left join public.providers phy on aaa.provider_id = phy.id
left join (select alter1.med_id,alter1.alt_display_name,alter1.alt_ndc,alter1.alt_days_supply,alter1.alt_quantity,alter1.alt_id,alter1.alt_brand,alter1.alt_prior_auth_needed,alter1.alt_specific_product_id,alter1.alt_order,alter1.alt_gpi_14,alter1.alt_generic_name,alter1.alt_concept_name,alter1.alt_patient_pay_amount,alter1.alt_total_cost
from temp_altermedlist alter1
where alter1.alt_order = 1) alt1 on aaam.id = alt1.med_id
left join (select alter2.med_id,alter2.alt_display_name,alter2.alt_ndc,alter2.alt_days_supply,alter2.alt_quantity,alter2.alt_id,alter2.alt_brand,alter2.alt_prior_auth_needed,alter2.alt_specific_product_id,alter2.alt_order,alter2.alt_gpi_14,alter2.alt_generic_name,alter2.alt_concept_name,alter2.alt_patient_pay_amount,alter2.alt_total_cost
from temp_altermedlist alter2
where alter2.alt_order = 2) alt2 on aaam.id = alt2.med_id
left join (select alter3.med_id,alter3.alt_display_name,alter3.alt_ndc,alter3.alt_days_supply,alter3.alt_quantity,alter3.alt_id,alter3.alt_brand,alter3.alt_prior_auth_needed,alter3.alt_specific_product_id,alter3.alt_order,alter3.alt_gpi_14,alter3.alt_generic_name,alter3.alt_concept_name,alter3.alt_patient_pay_amount,alter3.alt_total_cost
from temp_altermedlist alter3
where alter3.alt_order = 3) alt3 on aaam.id = alt3.med_id
where aaa.meets_criteria = true -- successful DSR only
	AND lower(pay."name") = 'bsc' 
	AND lower(aaa.dsr_type ) = 'd'
;
create index "_I_temp_dsr_report_1" on temp_dsr_report using btree(med_id)
;
---------------End Create DSR Raw data ----------------------------------------

---------------Begin Existing Med Found Prep ----------------------------------------
drop table if exists temp_emf_prep;
create temp table temp_emf_prep as
select ef.mml_record_id,
case 
	when 'd' = 'd' then max(ef.published_date::text||ef.med_id::text) 
	else max(ef.report_created_date::text||ef.med_id::text) 
end as most_recent_ci
from temp_bsc_existing_med_found_list ef
left join temp_new_ci_list tncpl on ef.med_id = tncpl.med_id or ef.mml_record_id = tncpl.mml_record_id
left join temp_recurring_list tck on ef.med_id = tck.med_id or ef.mml_record_id = tck.mml_record_id
where tncpl.med_id is null and tck.med_id is null
group by ef.mml_record_id
;

create index "_I_temp_emf_prep" on temp_emf_prep using btree(most_recent_ci)
;
---------------End Existing Med Found Prep ----------------------------------------

---------------Begin Generate Output Report -----------------------------------
drop table if exists temp_output;
create temp table temp_output as
select now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_existing_medication as "ExistingDrug"
	,tdr.quantity as "ExistingDrugQuantity"
	,tdr.days_supply as "ExistingDrugDaysSupply"
	,tdr.requested_existing_brand as "ExistingDrugBrand"
	,tdr.requested_existing_ndc::int8 as "ExistingDrugNDC"
	,tdr.requested_existing_pa as "ExistingDrugPA"
	,tdr.requested_existing_spid as "ExistingDrugSPID"
	,tdr.requested_existing_concept_name as "ExistingDrugConceptName"
	,tdr.requested_existing_med_type as "ExistingDrugMaintenancePeriodic"
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
	,null as "AnnualPatientSavings" --ef.alt_annual_patient_savings as "AnnualPatientSavings"
	,null as "AnnualTotalSavings" --ef.alt_annual_total_savings as "AnnualTotalSavings"
	,ef.switch_change_month::int8 as "SwitchChangeMonth"
	,tdr.run_name as "RunName"
	,tdr.transaction_id || tdr.requested_existing_ndc::int8 as "uid"
	,ef.change_type as "ChangeType"
	,tdr.org_name as "org"
	,upper('DSR-'||'d') as "ProductLine"
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
	,tdr.med_id as "ExistingMedInternalID"
	,tdr.requested_existing_gpi
	,ef.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_existing_patient_pay_amount
	,tdr.requested_existing_total_cost
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
	,tdr.requested_existing_super_concept
	,ef.mml_med_super_concept
	,null as "AdjustedPatientSavings"
	,null as "AdjustedTotalSavings"
	,tdr.line_of_business
	,null as fill_type
	,ef.published_date
	,ef.mml_record_id
from temp_dsr_report tdr
join temp_bsc_existing_med_found_list ef on tdr.med_id = ef.med_id
join temp_emf_prep tep on ('d' = 'd' and ef.published_date::text||ef.med_id::text = tep.most_recent_ci) or ('d' in ('e','p') and ef.report_created_date::text||ef.med_id::text = tep.most_recent_ci)
left join temp_new_ci_list tncpl on ef.med_id = tncpl.med_id or ef.mml_record_id = tncpl.mml_record_id
left join temp_recurring_list tck on ef.med_id = tck.med_id or ef.mml_record_id = tck.mml_record_id
where tncpl.med_id is null and tck.med_id is null
UNION ALL 
select now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_existing_medication as "ExistingDrug"
	,tdr.quantity as "ExistingDrugQuantity"
	,tdr.days_supply as "ExistingDrugDaysSupply"
	,tdr.requested_existing_brand as "ExistingDrugBrand"
	,tdr.requested_existing_ndc::int8 as "ExistingDrugNDC"
	,tdr.requested_existing_pa as "ExistingDrugPA"
	,tdr.requested_existing_spid as "ExistingDrugSPID"
	,tdr.requested_existing_concept_name as "ExistingDrugConceptName"
	,tdr.requested_existing_med_type as "ExistingDrugMaintenancePeriodic"
	,tr.alt_med as "AltDrug"
	,tr.alt_brand as "AltDrugBrand"
	,tr.alt_ndc::int8 as "AltDrugNDC"
	,tr.alt_pa as "AltDrugPA"
	,tr.alt_spid as "AltDrugSPID"
	,tr.alt_concept as "AltDrugConceptName"
	,tr.alt_quantity as "AltDrugQuantity"
	,tr.alt_days_supply as "AltDrugDaysSupply"
	,tr.mml_med as "ClaimDrug"
	,tr.mml_med_brand as "ClaimDrugBrand"
	,tr.mml_claim_date as "ClaimDate"
	,tr.mml_ndc::int8 as "ClaimDrugNDC"
	,tr.mml_spid as "ClaimDrugSPID"
	,tr.mml_concept_name as "ClaimDrugConceptName"
	,tr.mml_quantity as "ClaimDrugQuantity"
	,tr.mml_days_supply as "ClaimDrugDaysSupply"
	,tr.mml_med_type as "ClaimDrugMaintenancePeriodic"
	,tr.alt_annual_patient_savings as "AnnualPatientSavings"
	,tr.alt_annual_total_savings as "AnnualTotalSavings"
	,tr.switch_change_month::int8 as "SwitchChangeMonth"
	,tdr.run_name as "RunName"
	,tdr.transaction_id || tdr.requested_existing_ndc::int8 as "uid"
	,tr.change_type as "ChangeType"
	,tdr.org_name as "org"
	,upper('DSR-'||'d') as "ProductLine"
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
	,tdr.med_id as "ExistingMedInternalID"
	,tdr.requested_existing_gpi
	,tr.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_existing_patient_pay_amount
	,tdr.requested_existing_total_cost
	,tr.mml_patient_cost
	,tr.mml_total_cost
	,tdr.alt1_patient_pay_amount
	,tdr.alt1_total_cost
	,tdr.alt2_patient_pay_amount
	,tdr.alt2_total_cost
	,tdr.alt3_patient_pay_amount
	,tdr.alt3_total_cost
	,tr.carrier_id
	,tr.account_id
	,tr.group_id
	,tdr.requested_existing_super_concept
	,tr.mml_med_super_concept
	,tr.alt_annual_patient_savings as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_existing_med_type) = 'm' and ((tr.change_type = 'Tier 1' and tr.alt_annual_total_savings > 30000) or (tr.change_type = 'Tier 2' and (tr.alt_annual_total_savings * 0.75) > 30000)) then 30000
		when lower(tdr.requested_existing_med_type) = 'p' and ((tr.change_type = 'Tier 1' and tr.alt_annual_total_savings > 11250) or (tr.change_type = 'Tier 2' and (tr.alt_annual_total_savings * 0.75) > 11250)) then 11250
		when lower(tdr.requested_existing_med_type) = 'a' and ((tr.change_type = 'Tier 1' and tr.alt_annual_total_savings > 2500) or (tr.change_type = 'Tier 2' and (tr.alt_annual_total_savings * 0.75) > 2500)) then 2500
		when tr.change_type = 'Tier 2' then tr.alt_annual_total_savings * 0.75
		else tr.alt_annual_total_savings
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,case 
		when tr.change_type = 'Switch Exclusion' then null
		else 'Recurring' 
	end as fill_type
	,tr.published_date
	,tr.mml_record_id
from temp_dsr_report tdr
join temp_recurring_list tr on tdr.med_id = tr.med_id and tr.most_savings_order = 1
UNION ALL 
select now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_existing_medication as "ExistingDrug"
	,tdr.quantity as "ExistingDrugQuantity"
	,tdr.days_supply as "ExistingDrugDaysSupply"
	,tdr.requested_existing_brand as "ExistingDrugBrand"
	,tdr.requested_existing_ndc::int8 as "ExistingDrugNDC"
	,tdr.requested_existing_pa as "ExistingDrugPA"
	,tdr.requested_existing_spid as "ExistingDrugSPID"
	,tdr.requested_existing_concept_name as "ExistingDrugConceptName"
	,tdr.requested_existing_med_type as "ExistingDrugMaintenancePeriodic"
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
	,tdr.run_name as "RunName"
	,tdr.transaction_id || tdr.requested_existing_ndc::int8 as "uid"
	,t1.change_type as "ChangeType"
	,tdr.org_name as "org"
	,upper('DSR-'||'d') as "ProductLine"
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
	,tdr.med_id as "ExistingMedInternalID"
	,tdr.requested_existing_gpi
	,t1.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_existing_patient_pay_amount
	,tdr.requested_existing_total_cost
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
	,tdr.requested_existing_super_concept
	,t1.mml_med_super_concept
	,t1.alt_annual_patient_savings as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_existing_med_type) = 'm' and t1.alt_annual_total_savings > 30000 then 30000
		when lower(tdr.requested_existing_med_type) = 'p' and t1.alt_annual_total_savings > 11250 then 11250
		when lower(tdr.requested_existing_med_type) = 'a' and t1.alt_annual_total_savings > 2500 then 2500
		else t1.alt_annual_total_savings
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,case 
		when t1.fil_type_code = 1 then 'New'
		else 'Recurring'
	end as fill_type
	,t1.published_date
	,t1.mml_record_id
from temp_dsr_report tdr
join temp_new_ci_list t1 on tdr.med_id = t1.med_id and t1.most_savings_order = 1 and t1.change_type = 'Tier 1'
UNION ALL 
select now() as "ReportDate"
	,tdr.transaction_id as "GeminiTransactionID"
	,tdr.bin as "BIN"
	,tdr.pcn as "PCN"
	,tdr.inserted_at as "TransactionDate"
	,tdr.prescriber_name as "PrescriberName"
	,tdr.prescriber_npi as "PrescriberNPI"
	,tdr.requested_existing_medication as "ExistingDrug"
	,tdr.quantity as "ExistingDrugQuantity"
	,tdr.days_supply as "ExistingDrugDaysSupply"
	,tdr.requested_existing_brand as "ExistingDrugBrand"
	,tdr.requested_existing_ndc::int8 as "ExistingDrugNDC"
	,tdr.requested_existing_pa as "ExistingDrugPA"
	,tdr.requested_existing_spid as "ExistingDrugSPID"
	,tdr.requested_existing_concept_name as "ExistingDrugConceptName"
	,tdr.requested_existing_med_type as "ExistingDrugMaintenancePeriodic"
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
	,tdr.run_name as "RunName"
	,tdr.transaction_id || tdr.requested_existing_ndc::int8 as "uid"
	,t2.change_type as "ChangeType"
	,tdr.org_name as "org"
	,upper('DSR-'||'d') as "ProductLine"
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
	,tdr.med_id as "ExistingMedInternalID"
	,tdr.requested_existing_gpi
	,t2.mml_gpi
	,tdr.alt1_gpi
	,tdr.alt2_gpi
	,tdr.alt3_gpi
	,tdr.requested_existing_patient_pay_amount
	,tdr.requested_existing_total_cost
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
	,tdr.requested_existing_super_concept
	,t2.mml_med_super_concept
	,t2.alt_annual_patient_savings * 0.75 as "AdjustedPatientSavings"
	,case 
		when lower(tdr.requested_existing_med_type) = 'm' and t2.alt_annual_total_savings * 0.75 > 30000 then 30000
		when lower(tdr.requested_existing_med_type) = 'p' and t2.alt_annual_total_savings * 0.75 > 11250 then 11250
		when lower(tdr.requested_existing_med_type) = 'a' and t2.alt_annual_total_savings * 0.75 > 2500 then 2500
		else t2.alt_annual_total_savings * 0.75
	end as "AdjustedTotalSavings"
	,tdr.line_of_business
	,case
		when t2.change_type = 'Switch Exclusion' then null
		when t2.fil_type_code = 1 then 'New'
		else 'Recurring'
	end as fill_type
	,t2.published_date
	,t2.mml_record_id
from temp_dsr_report tdr
join temp_new_ci_list t2 on tdr.med_id = t2.med_id and t2.most_savings_order = 1 and t2.change_type in ('Tier 2','Switch Exclusion')
;
---------------End Generate Output Report -----------------------------------

-- If same DSR Transaction associate with mulitple runs, pick the most recent one
drop table if exists temp_final_output;
create temp table temp_final_output as
select 	t.mml_record_id
	,max(t.published_date::text||t."RunName") as most_recent_dsrd_run
from temp_output t
left join rpt_bsc_dsr_claim_gpi_outcome_prep_data rhdcgop on t.mml_record_id = rhdcgop.mml_record_id
where rhdcgop."ExistingMedInternalID" is null
group by 1
;

--drop table if exists rpt_bsc_dsr_claim_gpi_outcome_prep_data;
--create table rpt_bsc_dsr_claim_gpi_outcome_prep_data as
INSERT INTO public.rpt_bsc_dsr_claim_gpi_outcome_prep_data
--INSERT INTO public.rpt_bsc_dsr_claim_gpi_outcome_prep_data
	(
		"ReportDate", "GeminiTransactionID", "BIN", "PCN", "TransactionDate", "PrescriberName", "PrescriberNPI", "ExistingDrug", "ExistingDrugQuantity", "ExistingDrugDaysSupply", "ExistingDrugBrand"
		, "ExistingDrugNDC", "ExistingDrugPA", "ExistingDrugSPID", "ExistingDrugConceptName", "ExistingDrugMaintenancePeriodic", "AltDrug", "AltDrugBrand", "AltDrugNDC", "AltDrugPA", "AltDrugSPID"
		, "AltDrugConceptName", "AltDrugQuantity", "AltDrugDaysSupply", "ClaimDrug", "ClaimDrugBrand", "ClaimDate", "ClaimDrugNDC", "ClaimDrugSPID", "ClaimDrugConceptName", "ClaimDrugQuantity"
		, "ClaimDrugDaysSupply", "ClaimDrugMaintenancePeriodic", "AnnualPatientSavings", "AnnualTotalSavings", "SwitchChangeMonth", "RunName", uid, "ChangeType", org, "ProductLine", "Alt1Drug"
		, "Alt1DrugGenericName", "Alt1DrugBrand", "Alt1DrugNDC", "Alt1DrugPA", "Alt1DrugSPID", "Alt1DrugConceptName", "Alt1DrugQuantity", "Alt1DrugDaysSupply", "Alt2Drug", "Alt2DrugGenericName"
		, "Alt2DrugBrand", "Alt2DrugNDC", "Alt2DrugPA", "Alt2DrugSPID", "Alt2DrugConceptName", "Alt2DrugQuantity", "Alt2DrugDaysSupply", "Alt3Drug", "Alt3DrugGenericName", "Alt3DrugBrand", "Alt3DrugNDC"
		, "Alt3DrugPA", "Alt3DrugSPID", "Alt3DrugConceptName", "Alt3DrugQuantity", "Alt3DrugDaysSupply", "ExistingMedInternalID", requested_existing_gpi, mml_gpi, alt1_gpi, alt2_gpi, alt3_gpi
		, requested_existing_patient_pay_amount, requested_existing_total_cost, mml_patient_cost, mml_total_cost, alt1_patient_pay_amount, alt1_total_cost, alt2_patient_pay_amount, alt2_total_cost
		, alt3_patient_pay_amount, alt3_total_cost, carrier_id, account_id, group_id, requested_existing_super_concept, mml_med_super_concept, "AdjustedPatientSavings", "AdjustedTotalSavings"
		, line_of_business, fill_type, published_date, mml_record_id, stop_tracking, "PA_avoided"
	)
select DISTINCT
 t."ReportDate"
,t."GeminiTransactionID"
,t."BIN"
,t."PCN"
,t."TransactionDate"
,t."PrescriberName"
,t."PrescriberNPI"
,t."ExistingDrug"
,t."ExistingDrugQuantity"
,t."ExistingDrugDaysSupply"
,t."ExistingDrugBrand"
,t."ExistingDrugNDC"
,t."ExistingDrugPA"
,t."ExistingDrugSPID"
,t."ExistingDrugConceptName"
,t."ExistingDrugMaintenancePeriodic"
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
,t."RunName"
,t.uid
,t."ChangeType"
,t.org
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
,t."ExistingMedInternalID"
,t.requested_existing_gpi
,t.mml_gpi
,t.alt1_gpi
,t.alt2_gpi
,t.alt3_gpi
,t.requested_existing_patient_pay_amount
,t.requested_existing_total_cost
,t.mml_patient_cost
,t.mml_total_cost
,t.alt1_patient_pay_amount
,t.alt1_total_cost
,t.alt2_patient_pay_amount
,t.alt2_total_cost
,t.alt3_patient_pay_amount
,t.alt3_total_cost
,t.carrier_id
,t.account_id
,t.group_id
,t.requested_existing_super_concept
,t.mml_med_super_concept
,t."AdjustedPatientSavings"
,t."AdjustedTotalSavings"
,t.line_of_business
,t.fill_type
,t.published_date
,t.mml_record_id
,false as stop_tracking
,case 	when t."ExistingDrugPA" = 'Y' and t."AltDrugPA" = 'N' then 'Y' 
		when t."ExistingDrugPA" = 'Y' and t."AltDrugPA" = 'Y' then 'N'
		when t."ExistingDrugPA" = 'N' and t."AltDrugPA" = 'Y' then 'N'
		else null 
end as "PA_avoided"
from temp_output t
join temp_final_output tfo on (t."published_date"::text||t."RunName" = tfo.most_recent_dsrd_run) and t.mml_record_id = tfo.mml_record_id
left join rpt_bsc_dsr_claim_gpi_outcome_prep_data rhdcgop on t.mml_record_id = rhdcgop.mml_record_id
where rhdcgop."ExistingMedInternalID" is null
;

--create index "_I_rpt_bsc_dsr_claim_gpi_outcome_prep_data" on rpt_bsc_dsr_claim_gpi_outcome_prep_data using btree("ExistingMedInternalID","SwitchChangeMonth")
--;
--create index "_I_rpt_bsc_dsr_claim_gpi_outcome_prep_data_mml_record_id" on rpt_bsc_dsr_claim_gpi_outcome_prep_data using btree(mml_record_id)
--;
------------End Reporting-------------
COMMIT;$$);
