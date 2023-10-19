
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CAE_MOCK_DataSeed_product_lookup_2', $$INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99520,'Test-Lispro 100unit/mL Jr. KwikPen','99999995208',13.2600002288818,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,15.0,true,999521,15.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'2710400500D221','N',true,'SOPN',false,'LILLY','G',false,'Test - Insulin Lispro Junior KwikPen','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO JUNIOR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Insulin Lispro Junior KwikPen 100 UNIT/ML Solution Pen-injector','TEST - INSULIN LISPRO JUNIOR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Insulin Lispro KwikPen','99999995209',13.2600002288818,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,15.0,true,999521,3.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'2710400500D222','N',true,'SOPN',true,'LILLY','G',false,'Test - Insulin Lispro (1 Unit Dial)','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO (1 UNIT DIAL)','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Insulin Lispro (1 Unit Dial) 100 UNIT/ML Solution Pen-injector','TEST - INSULIN LISPRO (1 UNIT DIAL) 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Insulin Lispro100unit/mL Inj','99999995210',10.3012504577637,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,0.0,true,999521,10.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'27104005002022','N',true,'SOPN',false,'LILLY','G',false,'Test - Insulin Lispro','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - Insulin Lispro 100 UNIT/ML Solution','TEST - INSULIN LISPRO 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Insulin Lispro KwikPen','99999995211',13.2600002288818,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,15.0,true,999521,3.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'2710400500D222','N',true,'SOPN',true,'LILLY','G',false,'Test - Insulin Lispro (1 Unit Dial)','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO (1 UNIT DIAL)','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Insulin Lispro (1 Unit Dial) 100 UNIT/ML Solution Pen-injector','TEST - INSULIN LISPRO (1 UNIT DIAL) 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99521,'Test-Fiasp Pen 100unit/mL for Inj','99999995212',44.7891616821289,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',30,15.0,true,999522,15.0,'ml',2,1,'169',2,false,false,NULL,0,NULL,false,'2710400500F220','N',true,'SOCT',false,'NOVO NORDISK','T',false,'Test - Fiasp PenFill','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',7627,'TEST-Insulin Aspart (Recombinant) Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - FIASP PENFILL','Solution Cartridge','Subcutaneous','Soln Cart',NULL,NULL,NULL,NULL,'Test - Fiasp PenFill 100 UNIT/ML Solution Cartridge','TEST - FIASP PENFILL 100 UNIT/ML SOLUTION CARTRIDGE',NULL,0.0,0.0,NULL,NULL), (99521,'Test-Novolog Penfill 100unit/ml','99999995213',44.7891616821289,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',30,15.0,true,999522,15.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Penfill 100unit/ml',false,'2710400500F220','N',true,'SOCT',false,'NOVO NORDISK','T',false,'Test - NovoLOG PenFill','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',7627,'TEST-Insulin Aspart (Recombinant) Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - NOVOLOG PENFILL','Solution Cartridge','Subcutaneous','Soln Cart',NULL,NULL,NULL,NULL,'Test - NovoLOG PenFill 100 UNIT/ML Solution Cartridge','TEST - NOVOLOG PENFILL 100 UNIT/ML SOLUTION CARTRIDGE',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Novolog Mix 70/30 for Inj','99999995500',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVONORDK','automation',30,10.0,true,999500,10.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Insulin Aspart Mix 70/30 Inj','99999995501',18.7574996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,10.0,'ml',3,4,NULL,2,false,false,NULL,0,NULL,false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK PHARMA','G',false,'Test - Insulin Aspart Prot & Aspart','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - INSULIN ASPART PROT & ASPART','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - Insulin Aspart Prot & Aspart (70-30) 100 UNIT/ML Suspension','TEST - INSULIN ASPART PROT & ASPART (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99551,'Test-Humalog Mix 75/25 Susp for Inj','99999995502',35.5875015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999502,10.0,'ml',1,1,'2',2,false,false,NULL,0,'HumaLOG Mix 75/25 Susp for Inj',false,'27104080001820','N',true,'SUSP',false,'LILLY','T',false,'Test - HumaLOG Mix 75/25','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3984,'TEST-Insulin Lispro Protamine (NPL), Insulin Lispro Suspension for injection',NULL,NULL,1.0,'mL',1,25.0,NULL,NULL,'U','(75-25) 100','UNIT/ML','TEST - HUMALOG MIX 75/25','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - HumaLOG Mix 75/25 (75-25) 100 UNIT/ML Suspension','TEST - HUMALOG MIX 75/25 (75-25) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Novolog Mix 70/30 for Inj','99999995503',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',0,0.0,true,999500,0.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99550,'Test-Novolog Mix 70/30 for Inj','99999995504',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',0,0.0,true,999500,10.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Novolog Mix 70/30 for Inj','99999995505',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',0,10.0,true,999500,10.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Novolog Mix 70/30 for Inj','99999995506',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',0,10.0,true,999500,0.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Novolog Mix 70/30 for Inj','99999995507',37.5149993896484,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',30,10.0,true,999500,3.0,'ml',2,1,'169',2,false,false,NULL,0,'NovoLOG Mix 70/30 for Inj',false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK','T',false,'Test - NovoLOG Mix 70/30 ReliOn','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - NOVOLOG MIX 70/30 RELION','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - NovoLOG Mix 70/30 ReliOn (70-30) 100 UNIT/ML Suspension','TEST - NOVOLOG MIX 70/30 RELION (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Insulin Aspart Mix 70/30 Inj','99999995508',10.7574996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,10.0,'ml',3,4,NULL,2,false,false,NULL,0,NULL,false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK PHARMA','T',false,'Test - Insulin Aspart Prot & Aspart','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - INSULIN ASPART PROT & ASPART','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - Insulin Aspart Prot & Aspart (70-30) 100 UNIT/ML Suspension','TEST - INSULIN ASPART PROT & ASPART (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Insulin Aspart Mix 70/30 Inj','99999995509',9.7574996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,10.0,'ml',3,4,NULL,2,false,false,NULL,0,NULL,false,'27104070001820','N',true,'SUSP',false,'NOVO NORDISK PHARMA','T',false,'Test - Insulin Aspart Prot & Aspart','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - INSULIN ASPART PROT & ASPART','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - Insulin Aspart Prot & Aspart (70-30) 100 UNIT/ML Suspension','TEST - INSULIN ASPART PROT & ASPART (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Insulin Aspart Mix 70/30 Inj','99999995510',12.7574996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,9.0,'ml',4,4,NULL,2,false,false,NULL,0,NULL,false,'27104070001820','N',true,'SUSP',false,'NOVO ','G',false,'Test - Insulin Aspart Prot & Aspart','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - INSULIN ASPART PROT & ASPART','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - Insulin Aspart Prot & Aspart (70-30) 100 UNIT/ML Suspension','TEST - INSULIN ASPART PROT & ASPART (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99550,'Test-Insulin Novo Mix 70/30 Inj','99999995511',12.7574996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,11.0,'ml',5,4,NULL,2,false,false,NULL,0,NULL,false,'27104070001820','N',true,'SUSP',false,'NOVO ','G',false,'Test - Insulin Aspart Prot & Aspart','00',NULL,'b',57,'TEST-intermediate-acting and short or rapid acting human insulins and analogs - log 70-30',30,NULL,'bulk',202,'Inj Susp',3085,'TEST-Insulin Aspart (Recombinant), Insulin Aspart Protamine (Recombinant) Suspension for injection',NULL,NULL,1.0,'mL',1,30.0,NULL,NULL,'U','(70-30) 100','UNIT/ML','TEST - INSULIN ASPART PROT & ASPART','Suspension','Subcutaneous','Suspension',NULL,NULL,NULL,NULL,'Test - Insulin Aspart Prot & Aspart (70-30) 100 UNIT/ML Suspension','TEST - INSULIN ASPART PROT & ASPART (70-30) 100 UNIT/ML SUSPENSION',NULL,0.0,0.0,NULL,NULL), (99580,'Test-Fluticas/Salmeterol 250-50 Inh','99999995580',7.48467016220093,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,60.0,true,896209,60.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'44209902708030','Y',false,'AEPB',false,'HIKMA','G',false,'Test - Fluticasone-Salmeterol','00',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',25,'Inhalant',13098,'Fluticasone Propionate, Salmeterol Inhalation powder',NULL,NULL,1.0,'actuation',0,250.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','250-50','MCG/ACT','TEST - FLUTICASONE-SALMETEROL','Aerosol Powder Breath Activated','Inhalation','Aero Pow Br Act',NULL,NULL,NULL,NULL,'Test - Fluticasone-Salmeterol 250-50 MCG/ACT Aerosol Powder Breath Activated','TEST - FLUTICASONE-SALMETEROL 250-50 MCG/ACT AEROSOL POWDER BREATH ACTIVATED',NULL,0.0,0.0,NULL,NULL), (99581,'Test-Fluticas/Salmeterol 113-14 Inh','99999995581',146.25,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,1.0,true,1918194,1.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'44209902708015','M',false,'AEPB',false,'TEVA PHARMACEUTICALS USA','G',false,'Test - Fluticasone-Salmeterol','00',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',25,'Inhalant',13098,'Fluticasone Propionate, Salmeterol Inhalation powder',NULL,NULL,1.0,'actuation',0,113.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','113-14','MCG/ACT','TEST - FLUTICASONE-SALMETEROL','Aerosol Powder Breath Activated','Inhalation','44209902708015',NULL,NULL,NULL,NULL,'Test - Fluticasone-Salmeterol 113-14 MCG/ACT Aerosol Powder Breath Activated','TEST - FLUTICASONE-SALMETEROL 113-14 MCG/ACT AEROSOL POWDER BREATH ACTIVATED',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99580,'Test-Fluticas/Salmeterol 250-50 Inh','99999995582',6.02400016784668,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,60.0,true,896209,60.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'44209902708030','Y',false,'AEPB',false,'TEVA PHARMACEUTICALS USA','G',false,'Test - Fluticasone-Salmeterol','00',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',25,'Inhalant',13098,'Fluticasone Propionate, Salmeterol Inhalation powder',NULL,NULL,1.0,'actuation',0,250.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','250-50','MCG/ACT','TEST - FLUTICASONE-SALMETEROL','Aerosol Powder Breath Activated','Inhalation','Aero Pow Br Act',NULL,NULL,NULL,NULL,'Test - Fluticasone-Salmeterol 250-50 MCG/ACT Aerosol Powder Breath Activated','TEST - FLUTICASONE-SALMETEROL 250-50 MCG/ACT AEROSOL POWDER BREATH ACTIVATED',NULL,0.0,0.0,NULL,NULL), (99582,'Test-Advair HFA 115mcg-21mcg Aer','99999995583',42.2656288146973,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,260,'GSK','automation',30,12.0,true,1359921,12.0,'gm',1,1,'173',2,false,false,NULL,0,NULL,true,'44209902703260','N',false,'AERO',false,'GLAXO SMITH KLINE','T',false,'Test - Advair HFA','00',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',33,'Aer Met',13099,'Fluticasone Propionate, Salmeterol Pressurized inhalation, suspension',NULL,NULL,1.0,'actuation',0,115.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','115-21','MCG/ACT','TEST - ADVAIR HFA','Aerosol','Inhalation','Aerosol',NULL,NULL,NULL,NULL,'Test - Advair HFA 115-21 MCG/ACT Aerosol','TEST - ADVAIR HFA 115-21 MCG/ACT AEROSOL',NULL,0.0,0.0,NULL,NULL), (99583,'Test-BREO ELLIPTA 100mcg-25mcg','99999995584',7.99666023254395,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,260,'GSK','automation',30,60.0,true,1539891,60.0,'ea',1,1,'173',2,false,false,NULL,0,NULL,true,'44209902758020','N',false,'AEPB',false,'GLAXO SMITH KLINE','T',false,'Test - Breo Ellipta','00',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',25,'Inhalant',11670,'Vilanterol Inhalation powder',NULL,NULL,1.0,'actuation',0,100.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','100-25','MCG/INH','TEST - BREO ELLIPTA','Aerosol Powder Breath Activated','Inhalation','Aero Pow Br Act',NULL,NULL,NULL,NULL,'Test - Breo Ellipta 100-25 MCG/INH Aerosol Powder Breath Activated','TEST - BREO ELLIPTA 100-25 MCG/INH AEROSOL POWDER BREATH ACTIVATED',NULL,0.0,0.0,NULL,NULL), (99582,'Test-Symbicort 160-4.5mcg/act Inh','99999995585',46.4583396911621,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,266,'AZN','automation',30,10.2,true,1359546,10.2,'gm',2,1,'186',2,false,false,NULL,0,NULL,true,'44209902413240','M',false,'AERO',false,'ASTRAZENECA LP','T',false,'Test - Symbicort','0',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',33,'Aer Met',14321,'Budesonide, Formoterol Fumarate Pressurized inhalation, suspension',NULL,NULL,1.0,'actuation',0,160.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','160-4.5','MCG/ACT','TEST - SYMBICORT','Aerosol','Inhalation','Aerosol',NULL,NULL,NULL,NULL,'Test - Symbicort 160-4.5 MCG/ACT Aerosol','TEST - SYMBICORT 160-4.5 MCG/ACT AEROSOL',NULL,0.0,0.0,NULL,NULL), (99582,'Test-Symbicort 160-4.5mcg/act Inh','99999995586',45.0,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,266,'AZN','automation',30,10.2,true,1359546,10.2,'gm',2,1,'186',2,false,false,NULL,0,NULL,true,'44209902413240','M',false,'AERO',false,'ASTRAZENECA LP','T',false,'Test - Symbicort','0',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',33,'Aer Met',14321,'Budesonide, Formoterol Fumarate Pressurized inhalation, suspension',NULL,NULL,1.0,'actuation',0,160.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','160-4.5','MCG/ACT','TEST - SYMBICORT','Aerosol','Inhalation','Aerosol',NULL,NULL,NULL,NULL,'Test - Symbicort 160-4.5 MCG/ACT Aerosol','TEST - SYMBICORT 160-4.5 MCG/ACT AEROSOL',NULL,0.0,0.0,NULL,NULL), (99582,'Test-Budes/Form 160-4.5mcg/act Inh','99999995587',39.5058784484863,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.2,true,1246304,10.2,'gm',3,4,NULL,2,false,false,NULL,0,NULL,true,'44209902413240','M',false,'AERO',false,'PRASCO LABORATORIES','G',false,'Test - Budesonide-Formoterol Fumarate','0',NULL,'b',62,'TEST-inhaled corticosteroids / long-acting beta agonists (ics/laba) - moderate dose',30,NULL,'bulk',33,'Aer Met',14321,'Budesonide, Formoterol Fumarate Pressurized inhalation, suspension',NULL,NULL,1.0,'actuation',0,160.0,'Respiratory Agents - ICS/LABA',NULL,'mcg','160-4.5','MCG/ACT','TEST - BUDESONIDE-FORMOTEROL FUMARATE','Aerosol','Inhalation','Aerosol',NULL,NULL,NULL,NULL,'Test - Budesonide-Formoterol Fumarate 160-4.5 MCG/ACT Aerosol','TEST - BUDESONIDE-FORMOTEROL FUMARATE 160-4.5 MCG/ACT AEROSOL',NULL,0.0,0.0,NULL,NULL), (99583,'Test-Acetaminophen 325mg Tablet','99999995588',0.0212500002235174,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,false,313782,100.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,false,'64200010000310','Y',false,'TABS',false,'RUGBY LABORATORIES','G',false,'Test - Acetaminophen','00',NULL,'b',0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'','325','MG','TEST - ACETAMINOPHEN','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Acetaminophen 325 MG Tablet','TEST - ACETAMINOPHEN 325 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99570,'Test-Lo Loestrin Fe Tablet','99999995700',7.27232980728149,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,329,'ALLERGAN','automation',28,28.0,true,1037185,28.0,'ea',1,1,'430',2,false,false,NULL,0,NULL,false,'25991003500320','N',false,'TABS',false,'ALLERGAN','T',false,'Test - Lo Loestrin Fe','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',210,'TEST-Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,10.0,NULL,1.0,'mcg','1 MG-10 MCG /','10 MCG','TEST - LO LOESTRIN FE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Lo Loestrin Fe 1 MG-10 MCG / 10 MCG Tablet','TEST - LO LOESTRIN FE 1 MG-10 MCG / 10 MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99571,'Test-Tarina Fe 1/20 28-Day Tablet','99999995701',1.02356994152069,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,2706,'AFAXYS','automation',28,28.0,true,1721965,28.0,'ea',3,4,'50102',2,false,false,NULL,0,NULL,false,'25990003610310','Y',false,'TABS',false,'AFAXYS','T',false,'Test - Tarina FE 1/20 EQ','00',NULL,'b',58,'TEST-monophasic contraceptives',28,NULL,'bulk',37,'Tab',1460,'TEST-Ferrous Fumarate Oral tablet',NULL,NULL,NULL,NULL,28,75.0,NULL,1.0,'mg','1-20','MG-MCG','TEST - TARINA FE 1/20 EQ','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Tarina FE 1/20 EQ 1-20 MG-MCG Tablet','TEST - TARINA FE 1/20 EQ 1-20 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99572,'Test-Cyclafem 1/35 Tablet','99999995702',1.05304002761841,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,371,'PAR','automation',28,28.0,true,1856402,28.0,'ea',3,4,'603',2,false,false,NULL,0,NULL,false,'25990002500320','Y',false,'TABS',false,'PAR PHARMACEUTICALS','T',false,'Test - Cyclafem 1/35','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',1457,'TEST-Ethinyl Estradiol, Norethindrone Oral tablet',NULL,NULL,NULL,NULL,0,0.035,NULL,1.0,'mg','1-35','MG-MCG','TEST - CYCLAFEM 1/35','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Cyclafem 1/35 1-35 MG-MCG Tablet','TEST - CYCLAFEM 1/35 1-35 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL); $$);