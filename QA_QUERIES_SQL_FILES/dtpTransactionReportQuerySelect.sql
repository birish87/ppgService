
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('dtpTransactionReportQuerySelect', $$select 
dtp."Transaction ID"
,dtp."DTP Created On Date"
,dtp."Chosen Medication Name"
,dtp."Chosen Medication NDC"
,dtp."Chosen Medication Quantity"
,dtp."Chosen Medication Days' Supply"
,dtp."Chosen Med. Txn. Response Status"
,dtp."Chosen Med. PA Indicator"
,case 
when dtp."isAbandoned" = 'Y' then 'Abandoned'
when dtp."isChosenMedication" = 'Y' then 'Chosen Medication'
when dtp."isAbandoned" = 'N' and dtp."isChosenMedication" = 'N' and (dtp."Alt. Value Medication#1 Switch Status" = 'Y' or dtp."Alt. Value Medication#2 Switch Status" = 'Y' or dtp."Alt. Value Medication#3 Switch Status" = 'Y') then 'Alt. Medication / Presented'
when dtp."isAbandoned" = 'N' and dtp."isChosenMedication" = 'N' and dtp."Alt. Value Medication#1 Switch Status" = 'N' and dtp."Alt. Value Medication#2 Switch Status" = 'N' and dtp."Alt. Value Medication#3 Switch Status" = 'N' then 'Alt. Medication / Not presented'
else 'Exception'
end as "Chosen Medication Status"
,dtp."isChosenMedication"
,dtp."isAbandoned"
,dtp."Alt. Value Medication#1 Name"
,dtp."Alt. Value Medication#1 NDC"
,dtp."Alt. Value Medication#1 Quantity"
,dtp."Alt. Value Medication#1 Days' Supply"
,dtp."Alt. Value Med#1-Txn. Response Status"
,dtp."Alt. Value Medication#1 Switch Status"
,dtp."Alt. Value Medication#1 Patient Savings"

,case
when dtp."isAbandoned" = 'Y' and dtp."Alt. Value Medication#1 Name" is not null then dtp.total_savings_threshold
else dtp."Alt. Value Medication#1 Total Savings"
end as "Alt. Value Medication#1 Total Savings"
,dtp."Alt. Value Medication#2 Name"
,dtp."Alt. Value Medication#2 NDC"
,dtp."Alt. Value Medication#2 Quantity"
,dtp."Alt. Value Medication#2 Days' Supply"
,dtp."Alt. Value Med#2-Txn. Response Status"
,dtp."Alt. Value Medication#2 Switch Status"
,dtp."Alt. Value Medication#2 Patient Savings"
,case
when dtp."isAbandoned" = 'Y' and dtp."Alt. Value Medication#2 Name" is not null then dtp.total_savings_threshold
else dtp."Alt. Value Medication#2 Total Savings"
end as "Alt. Value Medication#2 Total Savings"
,dtp."Alt. Value Medication#3 Name"
,dtp."Alt. Value Medication#3 NDC"
,dtp."Alt. Value Medication#3 Quantity"
,dtp."Alt. Value Medication#3 Days' Supply"
,dtp."Alt. Value Med#3-Txn. Response Status"
,dtp."Alt. Value Medication#3 Switch Status"
,dtp."Alt. Value Medication#3 Patient Savings"
,case 
when dtp."isAbandoned" = 'Y' and dtp."Alt. Value Medication#3 Name" is not null then dtp.total_savings_threshold
else dtp."Alt. Value Medication#3 Total Savings"
end as "Alt. Value Medication#3 Total Savings"
from (
select org.ehr_organization_id as "EHR Organization ID"
,org.total_savings_threshold
,bt.institution_id as "Institution Id"
,pay."name" as "Payer"
,bt.id as "Transaction ID"
,bt.inserted_at as "DTP Created On Date"
,pm.name as "Chosen Medication Name"
,pm.ndc as "Chosen Medication NDC"
,pm.quantity as "Chosen Medication Quantity"
,pm.days_supply as "Chosen Medication Days' Supply"
,pbmm.status_code as "Chosen Med. Txn. Response Status"
,
case
when pm.prior_auth_needed = true then 'Y'
else 'N'
end as "Chosen Med. PA Indicator"
,
case
when ppe.concept_name is null then null
when ppe.concept_name in (select pml.concept_name from temp_prescription_orders pml 
where org.ehr_organization_id = pml.ehr_organization_id 
and ic.bin = pml.bin 
and ic.pcn = pml.pcn  
and ip.cardholder_id = pml.cardholder_id 
and pat.birthdate = pml.dob 
and pat.first_name = pml.first_name
and pml.inserted_at > bt.inserted_at
and (DATE_PART('day', pml.inserted_at - bt.inserted_at) < 3)
) then 'N'
else 'Y'
end as "isAbandoned"
,ppe.concept_name
,case 
when ppl.specific_product_id is null then null
when ppl.specific_product_id in (select pml.specific_product_id from temp_prescription_orders pml 
where org.ehr_organization_id = pml.ehr_organization_id 
and ic.bin = pml.bin 
and ic.pcn = pml.pcn  
and ip.cardholder_id = pml.cardholder_id 
and pat.birthdate = pml.dob 
and pat.first_name = pml.first_name
and pml.inserted_at > bt.inserted_at
and (DATE_PART('day', pml.inserted_at - bt.inserted_at) < 3)
) then 'Y'
else 'N'
end as "isChosenMedication"
,ppl.specific_product_id as "SPID"
,alter1.name as "Alt. Value Medication#1 Name"
,alter1.ndc as "Alt. Value Medication#1 NDC"
,alter1.quantity as "Alt. Value Medication#1 Quantity"
,alter1.days_supply as "Alt. Value Medication#1 Days' Supply"
,alter1.status_code as "Alt. Value Med#1-Txn. Response Status"
,case 
when alter1.specific_product_id is null then null
when alter1.specific_product_id in (select pml.specific_product_id from temp_prescription_orders pml 
where org.ehr_organization_id = pml.ehr_organization_id 
and ic.bin = pml.bin 
and ic.pcn = pml.pcn  
and ip.cardholder_id = pml.cardholder_id 
and pat.birthdate = pml.dob 
and pat.first_name = pml.first_name
and pml.inserted_at > bt.inserted_at
and (DATE_PART('day', pml.inserted_at - bt.inserted_at) < 3)
) then 'Y'
else 'N'
end as "Alt. Value Medication#1 Switch Status"
,alter1.specific_product_id as "SPID1"
,alter1.patient_savings as "Alt. Value Medication#1 Patient Savings"
,alter1.total_savings as "Alt. Value Medication#1 Total Savings"
,alter2.name as "Alt. Value Medication#2 Name"
,alter2.ndc as "Alt. Value Medication#2 NDC"
,alter2.quantity as "Alt. Value Medication#2 Quantity"
,alter2.days_supply as "Alt. Value Medication#2 Days' Supply"
,alter2.status_code as "Alt. Value Med#2-Txn. Response Status"
,case 
when alter2.specific_product_id is null then null
when alter2.specific_product_id in (select pml.specific_product_id from temp_prescription_orders pml 
where org.ehr_organization_id = pml.ehr_organization_id 
and ic.bin = pml.bin 
and ic.pcn = pml.pcn 
and ip.cardholder_id = pml.cardholder_id 
and pat.birthdate = pml.dob 
and pat.first_name = pml.first_name
and pml.inserted_at > bt.inserted_at
and (DATE_PART('day', pml.inserted_at - bt.inserted_at) < 3)
) then 'Y'
else 'N'
end as "Alt. Value Medication#2 Switch Status"
,alter2.specific_product_id as "SPID2"
,alter2.patient_savings as "Alt. Value Medication#2 Patient Savings"
,alter2.total_savings as "Alt. Value Medication#2 Total Savings"
,alter3.name as "Alt. Value Medication#3 Name"
,alter3.ndc as "Alt. Value Medication#3 NDC"
,alter3.quantity as "Alt. Value Medication#3 Quantity"
,alter3.days_supply as "Alt. Value Medication#3 Days' Supply"
,alter3.status_code as "Alt. Value Med#3-Txn. Response Status"
,case 
when alter3.specific_product_id is null then null
when alter3.specific_product_id in (select pml.specific_product_id from temp_prescription_orders pml 
where org.ehr_organization_id = pml.ehr_organization_id 
and ic.bin = pml.bin 
and ic.pcn = pml.pcn 
and ip.cardholder_id = pml.cardholder_id 
and pat.birthdate = pml.dob 
and pat.first_name = pml.first_name
and pml.inserted_at > bt.inserted_at
and (DATE_PART('day', pml.inserted_at - bt.inserted_at) < 3)
) then 'Y'
else 'N'
end as "Alt. Value Medication#3 Switch Status"
,alter3.specific_product_id as "SPID3"
,alter3.patient_savings as "Alt. Value Medication#3 Patient Savings"
,alter3.total_savings as "Alt. Value Medication#3 Total Savings"
from public.beacon_transactions bt
join public.patients pat on bt.patient_id = pat.id
join public.priced_medications pm on bt.id = pm.beacon_transaction_id and pm.chosen_med = true
left join public.product_lookup ppl on pm.ndc = ppl.ndc
left join public.product_equivalencies ppe on ppl.specific_product_id = ppe.specific_product_id
join public.providers phy on bt.provider_id = phy.id
join public.organizations org on phy.organization_id = org.id
join public.insurance_policies ip on pat.id = ip.patient_id
join public.insurance_companies ic on ip.insurance_company_id = ic.id
join public.payers pay on ic.payer_id = pay.id
join public.pbm_logs pbml on bt.request_id = pbml.request_id
left join public.pbm_medications pbmm on pbml.id = pbmm.pbm_log_id and pm.ndc = pbmm.ndc
left join ( select beacon_transaction_id, "name", ndc, patient_savings, total_savings,specific_product_id,concept_name, quantity,days_supply,status_code
from temp_alt_med_list where altorder = 1) alter1 on bt.id = alter1.beacon_transaction_id
left join ( select beacon_transaction_id, "name", ndc, patient_savings, total_savings,specific_product_id,concept_name, quantity,days_supply,status_code
from temp_alt_med_list where altorder = 2) alter2 on bt.id = alter2.beacon_transaction_id
left join ( select beacon_transaction_id, "name", ndc, patient_savings, total_savings,specific_product_id,concept_name, quantity,days_supply,status_code
from temp_alt_med_list where altorder = 3) alter3 on bt.id = alter3.beacon_transaction_id
where  
pay.name = 'BSC'
and bt.inserted_at between (now() - '9 day'::interval)::timestamp::date and (now() + '2 day'::interval)::timestamp::date
) dtp
order by dtp."Transaction ID" desc$$);
