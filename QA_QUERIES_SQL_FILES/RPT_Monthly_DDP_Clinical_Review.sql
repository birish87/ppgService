
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('RPT_Monthly_DDP_Clinical_Review', $$--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Set Date Range';
-- end;
--  $$;

create temp table tmp_dates as
select date_trunc('month', now()) - interval '1 month' as from_dt, date_trunc('month',now()) - interval '1 millisecond' as thru_dt;

--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Pull Alternate Med';
-- end;
--  $$;

create temp table tmp_alt_med as
	select distinct 
		 pm.beacon_transaction_id
		,pm."name"
		,pe.specific_product_id
		,pm.quantity
		,pm.days_supply
		,pbmm.status_code
		,row_number() over (partition by pm.beacon_transaction_id order by pm.id) as altorder
	from public.priced_medications    pm
	join tmp_dates                    tdt  on pm.inserted_at between tdt.from_dt and tdt.thru_dt
	join public.beacon_transactions   bt   on pm.beacon_transaction_id = bt.id
	join public.product_lookup        pl   on pm.ndc = pl.ndc
	join public.product_equivalencies pe   on pl.specific_product_id = pe.specific_product_id
	join public.pbm_logs              pbml on bt.request_id = pbml.request_id and pbml.is_final = true 
	left join public.pbm_medications  pbmm on pbml.id = pbmm.pbm_log_id and pm.ndc = pbmm.ndc
	where   pm.chosen_med = false
		and pm.alternate_pharmacy = false
		and pm.ehr_presented = true;

--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Pull DDP Data';
-- end;
--  $$;

create temp table tmp_ddp_data as
	select 
		 bt.id             as trans_id
		,bt.inserted_at    as inserted_at
		,pm."name"         as chosen_name
		,case
			when alter3."name" is not null then 3
			when alter2."name" is not null then 2
			when alter1."name" is not null then 1
			else 0
		 end as alt_cnt
		,pm.quantity       as chosen_qty
		,pm.days_supply    as chosen_ds
		,ppe.concept_name  as chosen_concept
		,alter1."name"       as a1_name
		,alter1.quantity     as a1_qty
		,alter1.days_supply  as a1_ds
		,alter2."name"       as a2_name
		,alter2.quantity     as a2_qty
		,alter2.days_supply  as a2_ds
		,alter3."name"       as a3_name
		,alter3.quantity     as a3_qty
		,alter3.days_supply  as a3_ds
		from public.beacon_transactions        bt
		join tmp_dates                         tdt  on bt.inserted_at between tdt.from_dt and tdt.thru_dt
		join public.patients                   pat  on bt.patient_id = pat.id
		join public.priced_medications         pm   on bt.id = pm.beacon_transaction_id and pm.chosen_med = true
		left join public.product_lookup        ppl  on pm.ndc = ppl.ndc
		left join public.product_equivalencies ppe  on ppl.specific_product_id = ppe.specific_product_id
		join public.providers                  phy  on bt.provider_id = phy.id
		join public.organizations              org  on phy.organization_id = org.id
		join public.insurance_policies         ip   on pat.id = ip.patient_id
		join public.insurance_companies        ic   on ip.insurance_company_id = ic.id
		join public.payers                     pay  on ic.payer_id = pay.id
		join public.pbm_logs                   pbml on bt.request_id = pbml.request_id and pbml.is_final = true 
		left join public.pbm_medications       pbmm on pbml.id = pbmm.pbm_log_id and pm.ndc = pbmm.ndc
		left join (select beacon_transaction_id, "name", specific_product_id,quantity, days_supply, status_code
				from tmp_alt_med where altorder = 1) alter1 on bt.id = alter1.beacon_transaction_id
		left join (select beacon_transaction_id, "name", specific_product_id,quantity, days_supply, status_code
				from tmp_alt_med where altorder = 2) alter2 on bt.id = alter2.beacon_transaction_id
		left join (select beacon_transaction_id, "name", specific_product_id,quantity, days_supply, status_code
				from tmp_alt_med where altorder = 3) alter3 on bt.id = alter3.beacon_transaction_id
		where 	alter1."name" is not null
			and org.ehr_organization_id not in ('1')
	order by 1;


--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Select Chosen Names';
-- end;
-- $$;

create temp table tmp_ddp_select as
	with ddp_names as
		(
		select lower(trim(both from ddp.chosen_name)) chosen_name, max(ddp.alt_cnt) alt_cnt
		from tmp_ddp_data as ddp
		where   alt_cnt > 0
			and chosen_concept is not null
		group by chosen_name
		order by chosen_name
		)
	select distinct min(ddp.trans_id) "TID", lower(trim(both from ddp.chosen_name)) "Chosen Name", max(ddp.alt_cnt) "Alt Count"
	from ddp_names      ddpn
	join tmp_ddp_data   ddp on lower(trim(both from ddp.chosen_name)) = ddpn.chosen_name
							and ddp.alt_cnt = ddpn.alt_cnt
	group by "Chosen Name"
	order by "TID";



--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Create Product Name Report List';
-- end;
-- $$;

create temp TABLE tmp_rpt_list as
	select
	 ddp.trans_id
	,ddp.chosen_name
	,1               as list
	,ddp.inserted_at as inserted_at
	,CURRENT_DATE    as report_dt
	from tmp_ddp_data   ddp
	join tmp_ddp_select dds on dds."TID" = ddp.trans_id
	order by 1
	 limit (select round((count(1)+.5)/3)  from tmp_ddp_select);

insert into tmp_rpt_list (trans_id, chosen_name, list, inserted_at, report_dt)
	select
	 ddp.trans_id
	,ddp.chosen_name
	,2               as list
	,ddp.inserted_at as inserted_at
	,CURRENT_DATE    as report_dt
	from tmp_ddp_data   ddp
	join tmp_ddp_select dds on dds."TID" = ddp.trans_id
	order by 1
	 limit (select round((count(1)+.5)/3)  from tmp_ddp_select)
	offset (select round((count(1)+.5)/3)  from tmp_ddp_select);

insert into tmp_rpt_list (trans_id, chosen_name, list, inserted_at, report_dt)
	select
	 ddp.trans_id
	,ddp.chosen_name
	,3               as list
	,ddp.inserted_at as inserted_at
	,CURRENT_DATE    as report_dt
	from tmp_ddp_data   ddp
	join tmp_ddp_select dds on dds."TID" = ddp.trans_id
	order by 1
	 limit (select round((count(1)+.5)/3)      from tmp_ddp_select)
	offset (select round((count(1)+.5)/3) * 2  from tmp_ddp_select);


--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Create 3 List Files';
-- end;
-- $$;

create temp TABLE tmp_list1 as
	select distinct on (ddp.chosen_name)
		 ddp.chosen_name    as "Chosen Name"
		,ddp.chosen_qty     as "Chosen QTY"
		,ddp.chosen_ds      as "Chosen DS"
		,ddp.chosen_concept as "Chosen Concept"
		,ddp.a1_name    as "A1 Name"
		,ddp.a1_qty     as "A1 QTY"
		,ddp.a1_ds      as "A1 DS"
		,ddp.a2_name    as "A2 Name"
		,ddp.a2_qty     as "A2 QTY"
		,ddp.a2_ds      as "A2 DS"
		,ddp.a3_name    as "A3 Name"
		,ddp.a3_qty     as "A3 QTY"
		,ddp.a3_ds      as "A3 DS"
	from tmp_rpt_list trl
	join tmp_ddp_data ddp  on  ddp.trans_id = trl.trans_id
	where trl.list = 1
	order by "Chosen Name";

create temp TABLE tmp_list2 as
	select distinct on (ddp.chosen_name)
		 ddp.chosen_name    as "Chosen Name"
		,ddp.chosen_qty     as "Chosen QTY"
		,ddp.chosen_ds      as "Chosen DS"
		,ddp.chosen_concept as "Chosen Concept"
		,ddp.a1_name    as "A1 Name"
		,ddp.a1_qty     as "A1 QTY"
		,ddp.a1_ds      as "A1 DS"
		,ddp.a2_name    as "A2 Name"
		,ddp.a2_qty     as "A2 QTY"
		,ddp.a2_ds      as "A2 DS"
		,ddp.a3_name    as "A3 Name"
		,ddp.a3_qty     as "A3 QTY"
		,ddp.a3_ds      as "A3 DS"
	from tmp_rpt_list trl
	join tmp_ddp_data ddp  on  ddp.trans_id = trl.trans_id
	where trl.list = 2
	order by "Chosen Name";

create temp TABLE tmp_list3 as
	select distinct on (ddp.chosen_name)
		 ddp.chosen_name    as "Chosen Name"
		,ddp.chosen_qty     as "Chosen QTY"
		,ddp.chosen_ds      as "Chosen DS"
		,ddp.chosen_concept as "Chosen Concept"
		,ddp.a1_name    as "A1 Name"
		,ddp.a1_qty     as "A1 QTY"
		,ddp.a1_ds      as "A1 DS"
		,ddp.a2_name    as "A2 Name"
		,ddp.a2_qty     as "A2 QTY"
		,ddp.a2_ds      as "A2 DS"
		,ddp.a3_name    as "A3 Name"
		,ddp.a3_qty     as "A3 QTY"
		,ddp.a3_ds      as "A3 DS"
	from tmp_rpt_list trl
	join tmp_ddp_data ddp  on  ddp.trans_id = trl.trans_id
	where trl.list = 3
	order by "Chosen Name";

create temp TABLE tmp_report as
	select
		 chosen_name as "Existing Name"
		,list        as "List#"
		,trans_id    as "Transaction ID"
		,inserted_at as "Inserted At"
		,report_dt   as "Report DT"
	from tmp_rpt_list
	order by 1;



--DO $$ begin raise notice '~> Monthly DDP Clinical Review: Spit Files Out';
-- end;
-- $$;
SELECT * FROM tmp_report;$$);
