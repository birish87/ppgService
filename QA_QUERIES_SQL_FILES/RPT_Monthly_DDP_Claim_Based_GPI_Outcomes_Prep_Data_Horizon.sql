
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('RPT_Monthly_DDP_Claim_Based_GPI_Outcomes_Prep_Data_Horizon', $$BEGIN;

------------Begin raw dataset of DDP and dedup transaction within same date----------------
drop table if exists temp_ddp_dedup;
create temp table temp_ddp_dedup as 
select min(bt.id) as id,ic.bin, ic.pcn, phy.npi, lower(trim(ip.cardholder_id)) as cardholder_id, pat.birthdate::date, pm.ndc, pm.quantity, pharm.ncpdp_id, bt.inserted_at::date
from public.beacon_transactions bt
join public.patients pat on bt.patient_id = pat.id
join public.priced_medications pm on bt.id = pm.beacon_transaction_id and pm.chosen_med = true
join public.providers phy on bt.provider_id = phy.id
join public.organizations org on phy.organization_id = org.id
join public.insurance_policies ip on pat.id = ip.patient_id
join public.insurance_companies	ic on ip.insurance_company_id = ic.id
join public.payers payer on ic.payer_id = payer.id 
join pbm_logs pl on bt.request_id = pl.request_id and pl.is_final = true 
left join pharmacies pharm on pm.pharmacy_id = pharm.id
where lower(payer."name") = 'horizon'
	and lower(bt.transaction_type) = 'c'
	and org.ehr_organization_id not in ('1')
	and bt.pbm_called = true -- called PBM for info
	and bt.inserted_at::date between cast(date_trunc('month', current_date - '4 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
	and bt.inserted_at::date > '2020-09-30'
group by ic.bin, ic.pcn, phy.npi, lower(trim(ip.cardholder_id)), pat.birthdate::date, pm.ndc, pm.quantity, pharm.ncpdp_id, bt.inserted_at::date
;

create index temp_ddp_dedup_idx1 on temp_ddp_dedup(id);

drop table if exists temp_ddp;
create temp table temp_ddp as 
select tp.*, lower(trim(pat.first_name)) as first_name, lower(trim(pat.last_name)) as last_name
from temp_ddp_dedup tp
join public.beacon_transactions bt on bt.id = tp.id
join public.patients pat on bt.patient_id = pat.id
;

create index temp_ddp_idx1 on temp_ddp(id);
create index temp_ddp_idx2 on temp_ddp(birthdate, last_name);

--Cleanup temp data
drop table if exists temp_ddp_dedup;

------------End raw dataset of DDP----------------

-- clean up generic drug name (remove form names)
drop table if exists tmp_pe;
create temp table tmp_pe as
select *,
    case when strpos(lower(generic_drug_item_name), 'oral') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'oral') - 1)
         when strpos(lower(generic_drug_item_name), 'ophthalmic') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'ophthalmic') - 1)
         when strpos(lower(generic_drug_item_name), 'nasal spray') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'nasal spray') - 1)
         when strpos(lower(generic_drug_item_name), 'pressurized') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'pressurized') - 1)
         when strpos(lower(generic_drug_item_name), 'respiratory') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'respiratory') - 1)
         when strpos(lower(generic_drug_item_name), 'topical') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'topical') - 1)
         when strpos(lower(generic_drug_item_name), 'chewable') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'chewable') - 1)
         when strpos(lower(generic_drug_item_name), 'powder') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'powder') - 1)
         when strpos(lower(generic_drug_item_name), 'nebulizer') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'nebulizer') - 1)
         when strpos(lower(generic_drug_item_name), 'transdermal') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'transdermal') - 1)
         when strpos(lower(generic_drug_item_name), 'solution') > 0 then left(generic_drug_item_name, strpos(lower(generic_drug_item_name), 'solution') - 1)
        else generic_drug_item_name 
    end as generic_drug_name
from product_equivalencies pe;

create index tmp_pe_idx1 on tmp_pe(specific_product_id);


------------Begin MML List---------------------
drop table if exists temp_mml_patient;
create temp table temp_mml_patient as 
select trim(cm.patient_first_name) as patient_first_name
,substring(trim(cm.patient_first_name), 1, 1) as patient_first_name_initial
,trim(cm.patient_last_name) as patient_last_name
,date_of_birth::date
,trim(cm.cardholder_id) as cardholder_id
,lower('hzn'|| trim(cm.cardholder_id) || cm.date_of_birth::date)  as patient_identifier
,cm.service_provider_id
from public.horizon_claims cm
where (cm.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
		or (cm.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
	  )
group by patient_first_name,patient_first_name_initial,patient_last_name,date_of_birth,cardholder_id,patient_identifier,service_provider_id
;

create index temp_mml_patient_idx1 on temp_mml_patient(patient_identifier);

-- Create temp table for MML 
drop table if exists temp_mml;
create temp table temp_mml
(patient_first_name varchar(255),
patient_first_name_initial varchar(255),
patient_last_name varchar(255),
date_of_birth date,
cardholder_id varchar(255),
patient_identifier varchar(255),
date_of_service date,
mml_med varchar(255),
mml_med_brand varchar(1),
mml_ndc varchar(255),
mml_specific_product_id int4,
mml_gpi_14 varchar(255),
mml_gpi_12 varchar(255),
mml_gpi_4 varchar(255),
mml_quantity float8,
mml_days_supply int,
mml_ncpdp_id varchar(255),
mml_med_type varchar(255),
mml_patient_cost float8,
mml_total_cost float8
);

-- insert last month MML into temp table
insert into temp_mml
select distinct tmpat.patient_first_name
,tmpat.patient_first_name_initial
,tmpat.patient_last_name
,tmpat.date_of_birth
,tmpat.cardholder_id
,lower(rbch.new_patient_identifier) as patient_identifier
,rbch.date_of_service
,rbch.med_name as mml_med
,rbch.med_brand
,rbch.med_ndc
,rbch.specific_product_id
,pl.gpi as mml_gpi_14 --Claim Med GPI14
,substring(pl.gpi,1,12) as mml_gpi_12 --Claim Med GPI12
,substring(pl.gpi,1,4) as mml_gpi_4 --Claim Med GPI12
,rbch.quantity_dispensed
,rbch.days_supply
,pharm.ncpdp_id
,rbch.med_type
,rbch.patient_cost
,rbch.total_cost
from public.rpt_hzn_claim_history rbch
join temp_mml_patient tmpat on lower(rbch.new_patient_identifier) = lower(tmpat.patient_identifier)
join public.product_lookup pl on rbch.med_ndc = pl.ndc
left join public.pharmacies pharm on tmpat.service_provider_id = pharm.npi
where ((rbch.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		or (rbch.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;

create index "_I_temp_mml_patient_identifier" on temp_mml using btree(patient_identifier);
create index temp_mml_idx1 on temp_mml(cardholder_id);
create index temp_mml_idx2 on temp_mml(date_of_birth);
create index temp_mml_idx3 on temp_mml(patient_last_name);
create index temp_mml_idx4 on temp_mml(patient_first_name_initial);
create index temp_mml_idx5 on temp_mml using btree(patient_identifier,mml_ndc,mml_med);
--create index temp_mml_idx6 on temp_mml using btree(mml_specific_product_id);
------------End MML List---------------------


------------Begin Member ID Matching ------------------------- 
drop table if exists tmp_match_cardholderid;
create temp table tmp_match_cardholderid as	
select distinct a.id, trim(cm.cardholder_id) as cardholder_id, lower(cm.patient_first_name) as patient_first_name
from temp_ddp a
join temp_mml cm on a.birthdate::date = cm.date_of_birth::date
	and ((lower(a.cardholder_id) = lower(cm.cardholder_id) and lower(a.first_name) = lower(cm.patient_first_name)) or
			(length(a.cardholder_id) > 11 and lower(a.cardholder_id) like '%3hzn%' and  lower(SUBSTRING(a.cardholder_id,POSITION('3hzn' IN lower(a.cardholder_id)),12)) = lower(SUBSTRING(cm.cardholder_id,POSITION('3hzn' IN lower(cm.cardholder_id)),12)) and lower(a.first_name) = lower(cm.patient_first_name))
		)
;

create index tmp_match_cardholderid_idx1 on tmp_match_cardholderid(id);

------------End Member ID Matching ------------------------- 


-- :product_type = ddp
------------Begin Alter List----------------
-- Create alternative list temp table
drop table if exists temp_pre_altermedlist;
create temp table temp_pre_altermedlist
(patient_identifier varchar(255),
report_created_date date,
beacon_transaction_id int8,
med_id int8,
med_display_name varchar(255),
med_ndc varchar(255),
med_brand varchar(1),
med_msc varchar(1),
med_specific_product_id int4,
med_quantity float8,
med_days_supply int,
med_gpi_14 varchar(255),
med_gpi_12 varchar(255),
med_super_concept varchar(255),
med_patient_pay_amount float8,
med_total_cost float8,
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
alt_quantity float8,
alt_days_supply int,
alt_generic_name text,
alt_patient_pay_amount float8,
alt_total_cost float8,
alt_patient_savings_v1 float8,
alt_total_savings_v1 float8
)
;

drop table if exists temp_altermedlist;
create temp table temp_altermedlist
(patient_identifier varchar(255),
report_created_date date,
beacon_transaction_id int8,
med_id int8,
med_display_name varchar(255),
med_ndc varchar(255),
med_brand varchar(1),
med_msc varchar(1),
med_specific_product_id int4,
med_quantity float8,
med_days_supply int,
med_gpi_14 varchar(255),
med_gpi_12 varchar(255),
med_super_concept varchar(255),
med_patient_pay_amount float8,
med_total_cost float8,
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
alt_quantity float8,
alt_days_supply int,
alt_generic_name text,
alt_patient_pay_amount float8,
alt_total_cost float8,
alt_patient_savings_v1 float8,
alt_total_savings_v1 float8,
altrow int4,
alt_order int4
)
;

drop table if exists tmp_priced_medications;
create temp table tmp_priced_medications as	
select pm.*
from temp_ddp tp
join public.priced_medications pm on tp.id = pm.beacon_transaction_id
;
create index tmp_priced_medications_idx1 on tmp_priced_medications(beacon_transaction_id,chosen_med,alternate_pharmacy,ehr_presented);
create index tmp_priced_medications_idx2 on tmp_priced_medications(id);
create index tmp_priced_medications_idx3 on tmp_priced_medications(ndc);


-- Insert last 4 month alternative for switch analysis
insert into temp_pre_altermedlist
select distinct 
case 
	when tmc.cardholder_id is not null then lower('hzn' || trim(tmc.cardholder_id) || tp.birthdate::date)
	else 'hznXXX' || tp.birthdate::date 
end as patient_identifier --use XXX to avoid wrong matching
,tp.inserted_at as report_created_date
,pm.beacon_transaction_id 
,pm.id as med_id
,pm."name" as med_display_name
,pm.ndc as med_ndc
,case
	when pl.brand = true then 'Y'
	when pl.brand = false then 'N'
end as med_brand
,pl.multi_source_code as alt_msc
,pl.specific_product_id as med_specific_product_id
,pm.quantity as med_quantity
,pm.days_supply as med_days_supply
,pl.gpi as med_gpi_14 --Chosen Med GPI14
,substring(pl.gpi,1,12) as med_gpi_12 --Chosen Med GPI12
,pe.super_concept as med_super_concept
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
,pe2.concept_name as alt_concept_name
,pl2.gpi as alt_gpi_14 --Chosen Med GPI14
,substring(pl2.gpi,1,12) as alt_gpi_12 --Chosen Med GPI12
,pm2.quantity as alt_quantity
,pm2.days_supply as alt_days_supply
,pe2.generic_drug_name as alt_generic_name
,pm2.patient_pay_amount as alt_patient_pay_amount
,pm2.total_cost as alt_total_cost
,pm2.patient_savings as alt_annual_patient_savings_v1
,pm2.total_savings as alt_annual_total_savings_v1
from temp_ddp tp
join tmp_priced_medications pm on tp.id = pm.beacon_transaction_id and pm.chosen_med = true
join public.product_lookup pl on pm.ndc = pl.ndc
join tmp_match_cardholderid tmc on tmc.id = tp.id
left join public.product_equivalencies pe on pl.specific_product_id = pe.specific_product_id
--left join public.medication_switch_details msd on pm.id = msd.medication_detail_id and lower(msd.product_type) = 'ddp' and reverse_decision is false
left join rpt_ddp_duplicated_medication_list rddml on pm.id = rddml.med_id
join tmp_priced_medications pm2 on tp.id = pm2.beacon_transaction_id and pm2.chosen_med = false and pm2.alternate_pharmacy = false and pm2.ehr_presented = true
join public.product_lookup pl2 on pm2.ndc =pl2.ndc
left join tmp_pe pe2 on pl2.specific_product_id = pe2.specific_product_id
where rddml.med_id is null -- not identified as dup in the past
;

create index "_I_temp_pre_altermedlist_med_id" on temp_pre_altermedlist using btree(med_id)
;
create index "_I_temp_pre_altermedlist_patient_identifier_med_id" on temp_pre_altermedlist using btree(patient_identifier,med_id)
;

--Dedup the same existing med in multiple months
drop table if exists temp_dedup_altermedlist;
create temp table temp_dedup_altermedlist as 
select patient_identifier, med_ndc, min(med_id) as med_id
from temp_pre_altermedlist
group by patient_identifier, med_ndc
;
create index "_I_temp_dedup_altermedlist_patient_identifier" on temp_dedup_altermedlist using btree(patient_identifier,med_id)
;

-- Table storing all duplicated DDP in medication level

--Insert duplicated DDP into filter list to prevent future confusion
insert into rpt_ddp_duplicated_medication_list (med_id,inserted_at)
select tpa.med_id, now()
from temp_pre_altermedlist tpa
left join temp_dedup_altermedlist tda on tpa.patient_identifier = tda.patient_identifier and tpa.med_id = tda.med_id
where tda.med_id is null
;

insert into temp_altermedlist
select tpa.*,row_number() over (partition by tpa.beacon_transaction_id,tpa.med_id,tpa.alt_id order by tpa.alt_id) as altrow,dense_rank() over (partition by tpa.beacon_transaction_id order by tpa.alt_id) as alt_order
from temp_pre_altermedlist tpa
join temp_dedup_altermedlist tda on tpa.patient_identifier = tda.patient_identifier and tpa.med_ndc = tda.med_ndc and tpa.med_id = tda.med_id
left join rpt_hzn_ddp_claim_gpi_switches rhdcgs on tpa.med_id = rhdcgs."ExistingMedInternalID" and rhdcgs."ReportDate"::date > '2021-05-21'
where rhdcgs."ExistingMedInternalID" is null
;

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

drop table if exists temp_pre_altermedlist;
drop table if exists temp_dedup_altermedlist;

drop table if exists tmp_alter1;
create temp table tmp_alter1 as
select alt.med_id, 
	alt.alt_display_name,
	alt.alt_ndc,
	alt.alt_specific_product_id,
	alt.alt_concept_name, 
	alt.alt_med_type, 
	alt.alt_patient_savings_v1, 
	alt.alt_total_savings_v1, 
	alt.alt_brand, 
	alt.alt_prior_auth_needed,
	alt.alt_quantity,
	alt.alt_days_supply
from temp_altermedlist alt
where alt.altrow = 1 and alt.alt_order = 1;

drop table if exists tmp_alter2;
create temp table tmp_alter2 as
select alt.med_id, 
	alt.alt_display_name,
	alt.alt_ndc,
	alt.alt_specific_product_id,
	alt.alt_concept_name, 
	alt.alt_med_type, 
	alt.alt_patient_savings_v1, 
	alt.alt_total_savings_v1, 
	alt.alt_brand, 
	alt.alt_prior_auth_needed,
	alt.alt_quantity,
	alt.alt_days_supply
from temp_altermedlist alt
where alt.altrow = 1 and alt.alt_order = 2;

drop table if exists tmp_alter3;
create temp table tmp_alter3 as
select alt.med_id, 
	alt.alt_display_name,
	alt.alt_ndc,
	alt.alt_specific_product_id,
	alt.alt_concept_name, 
	alt.alt_med_type, 
	alt.alt_patient_savings_v1, 
	alt.alt_total_savings_v1, 
	alt.alt_brand, 
	alt.alt_prior_auth_needed,
	alt.alt_quantity,
	alt.alt_days_supply
from temp_altermedlist alt
where alt.altrow = 1 and alt.alt_order = 3;
	
create index tmp_alter1_idx1 on tmp_alter1(med_id);
create index tmp_alter2_idx1 on tmp_alter2(med_id);
create index tmp_alter3_idx1 on tmp_alter3(med_id);

------------End Alter List----------------

------------Begin Claim History  --------------------
drop table if exists temp_hzn_claims;
create temp table temp_hzn_claims as
select rhch.*,substring(rhch.gpi_14,1,12) as gpi_12,pe.concept_name
,pl.multi_source_code as med_msc
,pe.super_concept as med_super_concept
from public.rpt_hzn_claim_history rhch
join public.product_lookup pl on rhch.med_ndc = pl.ndc
left join tmp_pe pe on pl.specific_product_id = pe.specific_product_id
where rhch.date_of_service between cast(date_trunc('month', current_date - '16 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
	and rhch.is_late_reversal = false
;

create index "_I_temp_hzn_claims_patient_identifier_gpi12" on temp_hzn_claims using btree(new_patient_identifier,gpi_12)
;
create index "_I_temp_hzn_claims_patient_identifier_dos_gpi12" on temp_hzn_claims using btree(new_patient_identifier,date_of_service,gpi_12)
;
create index "_I_temp_hzn_claims_patient_identifier_dos_gpi4" on temp_hzn_claims using btree(new_patient_identifier,date_of_service,med_super_concept,gpi_12)
;
----------- End Claim History ---------------------

------------Begin Reporting-------------
---------------Begin Tier 1 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
drop table if exists temp_tier1_prematches;
create temp table temp_tier1_prematches as
select distinct alt.med_id
	,alt.alt_display_name as alt_med
	,alt.alt_brand
	,alt.alt_prior_auth_needed  as alt_pa
	,alt.alt_ndc
	,alt.alt_specific_product_id as alt_spid
	,alt.alt_med_type
	,alt.alt_concept_name as alt_concept
	,case 
		when alt.med_patient_pay_amount is null then -0.01
		when lower(thlmc.med_type) = 'm' then (((alt.med_patient_pay_amount/alt.med_days_supply)*365)-((thlmc.patient_cost/thlmc.days_supply)*365))
		when lower(thlmc.med_type) = 'p' then (((alt.med_patient_pay_amount/alt.med_days_supply)*135)-((thlmc.patient_cost/thlmc.days_supply)*135))
		else (alt.med_patient_pay_amount-thlmc.patient_cost)
	end as alt_annual_patient_savings 
	,case
		when alt.med_total_cost is null then -0.01
		when lower(thlmc.med_type) = 'm' and (((alt.med_total_cost/alt.med_days_supply)-(thlmc.total_cost/thlmc.days_supply)) >= (-250::float8/thlmc.days_supply)) then (((alt.med_total_cost/alt.med_days_supply)*365)-((thlmc.total_cost/thlmc.days_supply)*365))
		when lower(thlmc.med_type) = 'p' and (((alt.med_total_cost/alt.med_days_supply)-(thlmc.total_cost/thlmc.days_supply)) >= (-250::float8/thlmc.days_supply)) then (((alt.med_total_cost/alt.med_days_supply)*135)-((thlmc.total_cost/thlmc.days_supply)*135))
		when lower(thlmc.med_type) = 'a' and ((alt.med_total_cost-thlmc.total_cost) >= -250::float8) then (alt.med_total_cost-thlmc.total_cost)
		when lower(thlmc.med_type) = 'm' and (((alt.med_total_cost/alt.med_days_supply)-(thlmc.total_cost/thlmc.days_supply)) < (-250::float8/thlmc.days_supply)) then ((-250::float8/thlmc.days_supply)*365)
		when lower(thlmc.med_type) = 'p' and (((alt.med_total_cost/alt.med_days_supply)-(thlmc.total_cost/thlmc.days_supply)) < (-250::float8/thlmc.days_supply)) then ((-250::float8/thlmc.days_supply)*135)
		when lower(thlmc.med_type) = 'a' and ((alt.med_total_cost-thlmc.total_cost) < -250::float8) then -250::float8
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
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,alt.alt_patient_savings_v1
	,alt.alt_total_savings_v1
	,thc.new_patient_identifier
	,alt.report_created_date::date-thc.date_of_service::date as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
from temp_altermedlist alt
join temp_hzn_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and thlmc.date_of_service::date > alt.report_created_date::date 
	and ( alt.med_gpi_12 is not null 
			and thlmc.gpi_12 is not null
			and (alt.med_gpi_12 <> thlmc.gpi_12
					or (alt.med_gpi_12 = thlmc.gpi_12 and 
							((upper(alt.med_msc) = 'M' and upper(thlmc.med_msc) in ('N','O','Y'))
							or (upper(alt.med_msc) = 'N' and upper(thlmc.med_msc) in ('M','O','Y'))
							or (upper(alt.med_msc) = 'O' and upper(thlmc.med_msc) in ('N','M'))
							or (upper(alt.med_msc) = 'Y' and upper(thlmc.med_msc) in ('N','M')))
						) -- Existing Medication & Resulting Medication with same GPI-12s 
				)
			and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
		)
	and (alt.alt_gpi_12 is not null 
			and thlmc.gpi_12 is not null 
			and alt.alt_gpi_12 = thlmc.gpi_12) --Only match alternative with GPI12
left join temp_hzn_claims thc on alt.patient_identifier = thc.new_patient_identifier 
    and thc.date_of_service::date <= alt.report_created_date::date
	and ( thlmc.gpi_12 is not null 
			and thc.gpi_12 is not null 
			and thlmc.gpi_12 = thc.gpi_12
			and upper(thlmc.med_msc) = upper(thc.med_msc)
			and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
		) --resulting medication was not filled in the past 120
where ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;

drop table if exists temp_tier1_matches;
create temp table temp_tier1_matches as
select distinct ttp.med_id
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
	,ttp.alt_patient_savings_v1
	,ttp.alt_total_savings_v1
	,ttp.mml_med_super_concept
from temp_tier1_prematches ttp
left join temp_tier1_prematches ttpf on ttp.med_id = ttpf.med_id and ttpf.lookback_days < 120
where ttp.new_patient_identifier is null or ttpf.med_id is null
;
---------------End  Tier 1 ------------------------------------------------

---------------Begin Tier 2 ------------------------------------------------
-- Key for Bucket-Matched to an Alternative by SPID brand to generic 
drop table if exists temp_tier2_prematches;
create temp table temp_tier2_prematches as
select distinct alt.med_id
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,0 as alt_spid
	,null as alt_med_type
	,null as alt_concept	
	,case 
		when alt.med_patient_pay_amount is null then -0.01
		when lower(thlmc.med_type) = 'm' then (((alt.med_patient_pay_amount/alt.med_days_supply)*365)-((thlmc.patient_cost/thlmc.days_supply)*365))
		when lower(thlmc.med_type) = 'p' then (((alt.med_patient_pay_amount/alt.med_days_supply)*135)-((thlmc.patient_cost/thlmc.days_supply)*135))
		else (alt.med_patient_pay_amount-thlmc.patient_cost)
	end as alt_annual_patient_savings 
	,case 
		when alt.med_total_cost is null then -0.01
		when lower(thlmc.med_type) = 'm' then (((alt.med_total_cost/alt.med_days_supply)*365)-((thlmc.total_cost/thlmc.days_supply)*365))
		when lower(thlmc.med_type) = 'p' then (((alt.med_total_cost/alt.med_days_supply)*135)-((thlmc.total_cost/thlmc.days_supply)*135))
		else (alt.med_total_cost-thlmc.total_cost)
	end as alt_annual_total_savings 
	,0 as alt_quantity
	,0 as alt_days_supply
	,4::int as alt_order
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
	,'Tier 2' as change_type
	,thlmc.patient_cost as mml_patient_cost
	,thlmc.total_cost as mml_total_cost
	,thlmc.gpi_14 as mml_gpi
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,250 as alt_patient_savings_v1
	,900 as alt_total_savings_v1
	,thc.new_patient_identifier
	,alt.report_created_date::date-thc.date_of_service::date as lookback_days
	,thlmc.med_super_concept as mml_med_super_concept
from temp_altermedlist alt
join temp_hzn_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier 
	and thlmc.date_of_service::date > alt.report_created_date::date 
	and ( alt.med_gpi_12 is not null 
			and thlmc.gpi_12 is not null 
			and alt.med_gpi_12 <> thlmc.gpi_12
			and trim(lower(alt.med_display_name)) <> trim(lower(thlmc.med_name))
		)
	and (alt.med_super_concept is not null
			and thlmc.med_super_concept is not null
			and upper(alt.med_super_concept) = upper(thlmc.med_super_concept)) --Super Concept match between Existing and Claim Med (resulting med)
left join temp_hzn_claims thc on alt.patient_identifier = thc.new_patient_identifier 
	and thc.date_of_service::date <= alt.report_created_date::date 
	and ( thlmc.gpi_12 is not null 
			and thc.gpi_12 is not null 
			and thlmc.gpi_12 = thc.gpi_12 
			and upper(thlmc.med_super_concept) = upper(thc.med_super_concept)
			and trim(lower(alt.med_display_name)) <> trim(lower(thc.med_name))
		)--resulting medication was not filled in the past 120	
where ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;

drop table if exists temp_tier2_matches;
create temp table temp_tier2_matches as
select distinct ttp.med_id
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
	,ttp.alt_patient_savings_v1
	,ttp.alt_total_savings_v1
	,ttp.mml_med_super_concept
from temp_tier2_prematches ttp
left join temp_tier2_prematches ttpf on ttp.med_id = ttpf.med_id and ttpf.lookback_days < 120
where ttp.alt_annual_total_savings >= 0 and (ttp.new_patient_identifier is null or ttpf.med_id is null)
;
---------------End  Tier 2 ------------------------------------------------


------------Begin DDP with existing medication claim / No Switch------------------------------------------------
drop table if exists temp_hzn_existing_med_found_list;
create temp table temp_hzn_existing_med_found_list as
select distinct alt.med_id
	,null as alt_med
	,null as alt_brand
	,null as alt_pa
	,null as alt_ndc
	,0 as alt_spid
	,null as alt_med_type
	,null as alt_concept
	,0 as alt_annual_patient_savings 
	,0 as alt_annual_total_savings 
	,0 as alt_quantity
	,0 as alt_days_supply
	,4::int as alt_order
	--,null as most_savings_order
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
	,thlmc.carrier_id
	,thlmc.account_id
	,thlmc.group_id
	,0 as alt_patient_savings_v1
	,0 as alt_total_savings_v1
	,thlmc.med_super_concept as mml_med_super_concept
from temp_altermedlist alt
join temp_hzn_claims thlmc on alt.patient_identifier = thlmc.new_patient_identifier -- Claim #1
	and thlmc.date_of_service::date > alt.report_created_date::date 
	and (
			(alt.med_gpi_12 is not null 
				and thlmc.gpi_12 is not null
				and (alt.med_gpi_12 = thlmc.gpi_12 
							and ((upper(alt.med_msc) = 'N' and upper(thlmc.med_msc) = 'N')
								or (upper(alt.med_msc) = 'M' and upper(thlmc.med_msc) = 'M')
								or (upper(alt.med_msc) = 'O' and upper(thlmc.med_msc) in ('O','Y'))
								or (upper(alt.med_msc) = 'Y' and upper(thlmc.med_msc) in ('O','Y')))
					) -- Existing Medication & Resulting Medication with same GPI-12s 
			)
			or trim(lower(alt.med_display_name)) = trim(lower(thlmc.med_name)) -- Existing Medication & Resulting Medication with same med name 
		)
where ((thlmc.date_of_service::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)) --Only claims for previous month
			or (thlmc.inserted_at::date between cast(date_trunc('month', current_date - '1 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date))
		)
;

create index "_I_temp_hzn_existing_med_found_list_med_id_most_savings_order" on temp_hzn_existing_med_found_list using btree(med_id)
;

---------------End DDP with existing medication claim / No Switch------------------------------------------------

--------------- Begin Apply rule 6 & 4 ---------------------------------------------
drop table if exists temp_outcome_list;
create temp table temp_outcome_list as
select cttm.*, 't1' as outcome_type
from temp_tier1_matches cttm
union
select cttm2.*,'t2' as outcome_type
from temp_tier2_matches cttm2
union
select tbemdl.*,'t3' as outcome_type
from temp_hzn_existing_med_found_list tbemdl
;
create index "_I_temp_outcome_list_med_id" on temp_outcome_list using btree(med_id,mml_claim_date,outcome_type)
;

---------------Begin Rule 6 ---------------------------------------
-- If multiple ddp chosen medication matched to same claim record, earliest DDP chosen medication record win
drop table if exists temp_outcome_list_rule_6;
create temp table temp_outcome_list_rule_6 as
select tol.mml_record_id, min(tol.med_id) as min_med_id
from temp_outcome_list tol
group by tol.mml_record_id
;
create index "_I_temp_outcome_list_rule_6_med_id" on temp_outcome_list_rule_6 using btree(min_med_id)
;
---------------End Rule 6 ---------------------------------------

---------------Begin Rule 4 ---------------------------------------
-- If same chosen medication match to muliple claims, we will only count the most recent claim and alternative combination.

-- Get latest claim if chosen med has mulitple switches 
drop table if exists temp_outcome_list_rule_4_max;
create temp table temp_outcome_list_rule_4_max as
select ttm.med_id, max(ttm.mml_claim_date) as max_mml_claim_date
from temp_outcome_list ttm
join temp_outcome_list_rule_6 tmdsc on ttm.med_id  = tmdsc.min_med_id
group by ttm.med_id
;
create index "_I_temp_outcome_list_rule_4_max_1" on temp_outcome_list_rule_4_max using btree(med_id,max_mml_claim_date)
;

drop table if exists temp_outcome_list_rule_4_max_high_t;
create temp table temp_outcome_list_rule_4_max_high_t as
select ttm.med_id,tolr4m.max_mml_claim_date, min(ttm.outcome_type) as highest_outcome_type
from temp_outcome_list ttm
join temp_outcome_list_rule_4_max tolr4m on ttm.med_id = tolr4m.med_id and ttm.mml_claim_date = tolr4m.max_mml_claim_date
group by ttm.med_id,tolr4m.max_mml_claim_date
;
create index "_I_temp_outcome_list_rule_4_max_high_t_1" on temp_outcome_list_rule_4_max_high_t using btree(med_id,max_mml_claim_date,highest_outcome_type)
;

drop table if exists temp_outcome_list_rule_4;
create temp table temp_outcome_list_rule_4 as
select ttm.med_id, max(ttm.mml_record_id) as recent_claim_id
from temp_outcome_list ttm
join temp_outcome_list_rule_4_max_high_t tolr4mh on ttm.med_id = tolr4mh.med_id and ttm.mml_claim_date = tolr4mh.max_mml_claim_date and ttm.outcome_type = tolr4mh.highest_outcome_type
group by ttm.med_id
;

drop table if exists temp_outcome_report_list;
create temp table temp_outcome_report_list as
select tt1.*,row_number() over (partition by tt1.med_id, tt1.mml_claim_date order by tt1.outcome_type,tt1.alt_order) as most_savings_order -- list of switches that assoicate with multiple alternative and mulitple switches for same existing med
from temp_outcome_list tt1
join temp_outcome_list_rule_4 ttmdm on tt1.med_id = ttmdm.med_id and tt1.mml_record_id = ttmdm.recent_claim_id
;
---------------End Rule 4 ---------------------------------------

create index "_I_temp_outcome_report_list_med_id" on temp_outcome_report_list using btree(med_id,outcome_type)
;
create index "_I_temp_outcome_report_list_med_id_most_savings_order" on temp_outcome_report_list using btree(med_id,most_savings_order)
;

-- Cleanup temp table
drop table if exists temp_outcome_list_rule_6;
drop table if exists temp_outcome_list_rule_4_max;
drop table if exists temp_outcome_list_rule_4_max_high_t;
drop table if exists temp_outcome_list_rule_4;
--------------- End Apply rule 6 & 4 ------------------------------------------------

---------------Begin Create DDP Raw data ------------------------------------
drop table if exists temp_ddp_report;
create temp table temp_ddp_report as
select distinct org.ehr_organization_id
,bt.id as transaction_id
,pm.id as med_id
,bt.inserted_at
,phy.last_name || ', ' || phy.first_name as prescriber_name
,phy.npi as prescriber_npi
,sc.ehr_name as org_name
,pl.name as requested_existing_medication
,pm.quantity
,pm.days_supply
,pharm.npi as pharmacy_npi
,case
	when pl.brand = true then 'Y'
	when pl.brand = false then 'N' 
end as requested_existing_brand
,case
	when pm.prior_auth_needed = true then 'Y'
	when pm.prior_auth_needed = false then 'N'
end as requested_existing_pa
,pm.ndc as requested_existing_ndc
,pm.patient_pay_amount as requested_existing_patient_pay_amount
,pm.total_cost as requested_existing_total_cost
,pl.specific_product_id as requested_existing_spid
, case
	when pl.maintenance = true then 'M'	--Maintenance
	when pl.maintenance = false and pl.periodic = true then 'P'	--Periodic
	when pl.maintenance = false and pl.periodic = false then 'A'	--Acute
end as requested_existing_med_type
,pl.gpi as requested_existing_gpi
,pe.concept_name as requested_existing_concept_name
,pat.emr_patient_id
,ic.bin as bin
,ic.pcn as pcn
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
,ett.outcome_type
,pe.super_concept as requested_existing_super_concept
,ip.line_of_business
from public.beacon_transactions bt
join public.patients pat on bt.patient_id = pat.id
join public.priced_medications pm on bt.id = pm.beacon_transaction_id and pm.chosen_med = true
join public.providers phy on bt.provider_id = phy.id
join public.insurance_policies ip on pat.id = ip.patient_id
join public.insurance_companies	ic on ip.insurance_company_id = ic.id
join pbm_logs pls on bt.request_id = pls.request_id and pls.is_final = true 
join temp_outcome_report_list ett on pm.id = ett.med_id and ett.most_savings_order = 1 --Matched results existing_med_found + Tier 1 + Tier 2
join payers pay on ic.payer_id = pay.id
join organizations org on phy.organization_id = org.id
join product_lookup pl on pm.ndc = pl.ndc
left join product_equivalencies pe on pl.specific_product_id = pe.specific_product_id 
left join pharmacies pharm on pm.pharmacy_id = pharm.id
left join surescripts_ddps ssddp on bt.id = ssddp.beacon_transaction_id
left join surescripts_crosswalks sc on sc.account_id = ssddp.sender_tertiary_identification
left join (select alter1.med_id,alter1.alt_display_name,alter1.alt_ndc,alter1.alt_days_supply,alter1.alt_quantity,alter1.alt_id,alter1.alt_brand,alter1.alt_prior_auth_needed,alter1.alt_specific_product_id,alter1.alt_order,alter1.alt_gpi_14,alter1.alt_generic_name,alter1.alt_concept_name,alter1.alt_patient_pay_amount,alter1.alt_total_cost
from temp_altermedlist alter1
where alter1.alt_order = 1) alt1 on pm.id = alt1.med_id
left join (select alter2.med_id,alter2.alt_display_name,alter2.alt_ndc,alter2.alt_days_supply,alter2.alt_quantity,alter2.alt_id,alter2.alt_brand,alter2.alt_prior_auth_needed,alter2.alt_specific_product_id,alter2.alt_order,alter2.alt_gpi_14,alter2.alt_generic_name,alter2.alt_concept_name,alter2.alt_patient_pay_amount,alter2.alt_total_cost
from temp_altermedlist alter2
where alter2.alt_order = 2) alt2 on pm.id = alt2.med_id
left join (select alter3.med_id,alter3.alt_display_name,alter3.alt_ndc,alter3.alt_days_supply,alter3.alt_quantity,alter3.alt_id,alter3.alt_brand,alter3.alt_prior_auth_needed,alter3.alt_specific_product_id,alter3.alt_order,alter3.alt_gpi_14,alter3.alt_generic_name,alter3.alt_concept_name,alter3.alt_patient_pay_amount,alter3.alt_total_cost
from temp_altermedlist alter3
where alter3.alt_order = 3) alt3 on pm.id = alt3.med_id
where lower(pay."name") = 'horizon' 
	and lower(bt.transaction_type) = 'c'
	and org.ehr_organization_id not in ('1')
	and bt.pbm_called = true -- called PBM for info
	and bt.inserted_at::date between cast(date_trunc('month', current_date - '4 month'::interval) as date) and cast(date_trunc('month', current_date)- '1 second'::interval as date)
;
create index "_I_temp_ddp_report_1" on temp_ddp_report using btree(med_id,outcome_type)
;

---------------End Create DDP Raw data ------------------------------------


---------------Begin Generate Output Report -----------------------------------
--drop table if exists rpt_hzn_ddp_claim_gpi_switches;
--create table rpt_hzn_ddp_claim_gpi_switches as
insert into rpt_hzn_ddp_claim_gpi_switches 
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
	,tdr.transaction_id::text || tdr.requested_existing_ndc::int8 as "uid"
	,'t1' as "sc"
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
	,t1.alt_patient_savings_v1
	,t1.alt_total_savings_v1
	,0.00 as "AnnualPatientSavings_SD"
	,0.00 as "AnnualTotalSavings_SD"
	,'' as flag_ex
	,t1.alt_annual_patient_savings as "AdjustedPatientSavings"
	,t1.alt_annual_total_savings as "AdjustedTotalSavings"
	,tdr.requested_existing_super_concept
	,t1.mml_med_super_concept
	,tdr.line_of_business
from temp_ddp_report tdr
join temp_outcome_report_list t1 on tdr.med_id = t1.med_id and t1.most_savings_order = 1
where tdr.outcome_type = 't1'
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
	,t2.alt_med as "AltDrug"
	,t2.alt_brand as "AltDrugBrand"
	,t2.alt_ndc::int8 as "AltDrugNDC"
	,t2.alt_pa as "AltDrugPA"
	,0 as "AltDrugSPID"
	,t2.alt_concept as "AltDrugConceptName"
	,t2.alt_quantity as "AltDrugQuantity"
	,t2.alt_days_supply as "AltDrugDaysSupply"
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
	,tdr.transaction_id::text  || tdr.requested_existing_ndc::int8 as "uid"
	,'t2' as "sc"
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
	,t2.alt_patient_savings_v1
	,t2.alt_total_savings_v1
	,0.00 as "AnnualPatientSavings_SD"
	,0.00 as "AnnualTotalSavings_SD"
	,'' as flag_ex
	,t2.alt_annual_patient_savings * 0.75 as "AdjustedPatientSavings"
	,t2.alt_annual_total_savings * 0.75 as "AdjustedTotalSavings"
	,tdr.requested_existing_super_concept
	,t2.mml_med_super_concept
	,tdr.line_of_business
from temp_ddp_report tdr
join temp_outcome_report_list t2 on tdr.med_id = t2.med_id and t2.most_savings_order = 1
where tdr.outcome_type = 't2'
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
	,tdr.transaction_id::text  || tdr.requested_existing_ndc::int8 as "uid"
	,'NoSwitch' as "sc"
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
	,ef.alt_patient_savings_v1
	,ef.alt_total_savings_v1
	,0.00 as "AnnualPatientSavings_SD"
	,0.00 as "AnnualTotalSavings_SD"
	,'' as flag_ex
	,null as "AdjustedPatientSavings"
	,null as "AdjustedTotalSavings"
	,tdr.requested_existing_super_concept
	,ef.mml_med_super_concept
	,tdr.line_of_business
from temp_ddp_report tdr
join temp_outcome_report_list ef on tdr.med_id = ef.med_id and ef.most_savings_order = 1
where tdr.outcome_type = 't3'
;
---------------End Generate Output Report -----------------------------------

--------------- SET STDDEV-----------------------------------
drop table if exists temp_std;
create temp table temp_std as
select "ProductLine","org","SwitchChangeMonth",stddev_pop("AnnualPatientSavings") as pat_saving_std , stddev_pop("AnnualTotalSavings") as total_savings_std
from rpt_hzn_ddp_claim_gpi_switches
where "sc" in ('t1','t2')
group by "ProductLine","org","SwitchChangeMonth"
;

-- Set Stand StDevP for this record
update rpt_hzn_ddp_claim_gpi_switches as rbdcgs
set "AnnualPatientSavings_SD" = case 
									when ts.pat_saving_std = 0 then 0
									else ("AnnualPatientSavings"/ts.pat_saving_std)
								end, 
	"AnnualTotalSavings_SD" = case 
									when ts.total_savings_std = 0 then 0
									else ("AnnualTotalSavings"/ts.total_savings_std)
								end
from temp_std ts
where rbdcgs."ProductLine" = ts."ProductLine" and rbdcgs."org"= ts."org" and rbdcgs."SwitchChangeMonth"= ts."SwitchChangeMonth" and rbdcgs."sc" in ('t1','t2')
;


-- Set FLAG
drop table if exists temp_flag;
create temp table temp_flag as
select distinct x."ExistingMedInternalID", concat_ws(',',a.flag,b.flag,c.flag,d.flag,e.flag) as flags
from rpt_hzn_ddp_claim_gpi_switches x
join (select "ExistingMedInternalID", 'A' as flag
		from rpt_hzn_ddp_claim_gpi_switches
		where ("ExistingDrugNDC" is not null and requested_existing_gpi is null) is null or ("Alt1DrugNDC" is not null and alt1_gpi is null) or ("Alt2DrugNDC" is not null and alt2_gpi is null) or ("Alt3DrugNDC" is not null and alt3_gpi is null)
		) a on x."ExistingMedInternalID" = a."ExistingMedInternalID"
left join (select "ExistingMedInternalID", 'B' as flag
			from rpt_hzn_ddp_claim_gpi_switches
			where mml_patient_cost < 0) b on x."ExistingMedInternalID" = b."ExistingMedInternalID"
left join (select "ExistingMedInternalID", 'C' as flag
			from rpt_hzn_ddp_claim_gpi_switches
			where mml_total_cost < 0) c on x."ExistingMedInternalID" = c."ExistingMedInternalID"
left join (select "ExistingMedInternalID", 'D' as flag
			from rpt_hzn_ddp_claim_gpi_switches
			where "AnnualPatientSavings_SD" > 3::int) d on x."ExistingMedInternalID" = d."ExistingMedInternalID"
left join (select "ExistingMedInternalID", 'E' as flag
			from rpt_hzn_ddp_claim_gpi_switches
			where "AnnualTotalSavings_SD" > 3::int) e on x."ExistingMedInternalID" = e."ExistingMedInternalID"
where a."ExistingMedInternalID" is not null 
	or b."ExistingMedInternalID" is not null 
	or c."ExistingMedInternalID" is not null 
	or d."ExistingMedInternalID" is not null 
	or e."ExistingMedInternalID"is not null 
;

update rpt_hzn_ddp_claim_gpi_switches as rbdcgs
set flag_ex = tf.flags
from temp_flag tf
where tf."ExistingMedInternalID" = rbdcgs."ExistingMedInternalID"
;
------------End Reporting-------------
COMMIT;$$);
