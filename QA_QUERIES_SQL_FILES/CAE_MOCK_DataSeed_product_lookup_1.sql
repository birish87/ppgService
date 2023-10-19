
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CAE_MOCK_DataSeed_product_lookup_1', $$INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99500,'Test-Humalog 100unit/ml for Inj','99999995000',34.3375015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999500,3.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG 100unit/ml for Inj',false,'27104005002022','N',true,'SOLN',false,'LILLY','T',false,'Test - HumaLOG','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG','Solution','Injection','Solution','00002',NULL,NULL,NULL,'Test - HumaLOG 100 UNIT/ML Solution','TEST - HUMALOG 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99500,'Test-Insulin Lispro100unit/mL Inj','99999995001',40.0,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,10.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'27104005002022','N',true,'SOLN',false,'LILLY','G',false,'Test - Insulin Lispro','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO','Solution','Injection','Solution','00002',NULL,NULL,NULL,'Test - Insulin Lispro 100 UNIT/ML Solution','TEST - INSULIN LISPRO 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99500,'Test-Insulin Lispro100unit/mL Inj','99999995002',40.0,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999501,10.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'27104005002022','N',true,'SOLN',false,'LILLY','G',false,'Test - Insulin Lispro','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - Insulin Lispro 100 UNIT/ML Solution','TEST - INSULIN LISPRO 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99500,'Test-LYUMJEV 100unit/mL Injection','99999995003',34.3375015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999500,10.0,'ml',2,1,'2',2,false,false,NULL,0,NULL,false,'27104005052020','N',true,'SOLN',false,'LILLY','T',false,'Test - Lyumjev','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LYUMJEV','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - Lyumjev 100 UNIT/ML Solution','TEST - LYUMJEV 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99500,'Test-LYUMJEV KwikPen 100unit/mL Inj','99999995004',44.2000007629395,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999500,3.0,'ml',2,1,'2',2,false,false,NULL,0,NULL,false,'2710400505D222','N',true,'SOPN',true,'LILLY','T',false,'Test - Lyumjev KwikPen','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LYUMJEV KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Lyumjev KwikPen 100 UNIT/ML Solution Pen-injector','TEST - LYUMJEV KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99500,'Test-Admelog SoloStar 100IU/mL Inj','99999995005',15.7791595458984,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,180,'SANOFI US','automation',30,15.0,true,999500,3.0,'ml',2,1,'24',2,false,false,NULL,0,NULL,false,'2710400500D222','N',true,'SOPN',true,'SANOFI PHARMACEUTICALS','T',false,'Test - Admelog SoloStar','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - ADMELOG SOLOSTAR','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Admelog SoloStar 100 UNIT/ML Solution Pen-injector','TEST - ADMELOG SOLOSTAR 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99501,'Test-Fiasp 100unit/mL Soln for Inj','99999995006',36.1699981689453,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',30,10.0,true,999503,10.0,'ml',2,1,'169',2,false,false,NULL,0,NULL,false,'27104002202020','N',true,'SOLN',false,'NOVO NORDISK','T',false,'Test - Fiasp','00',NULL,'b',50,'TEST-rapid-acting human insulins and analogss',30,NULL,'bulk',200,'Inj Sol',7627,'TEST-Insulin Aspart (Recombinant) Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - FIASP','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - Fiasp 100 UNIT/ML Solution','TEST - FIASP 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99510,'Test - Ambien 10mg Tablet','99999995010',25.5787506103516,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,180,'SANOFI US','automation',0,0.0,false,854875,100.0,'ea',2,1,'00024',2,false,false,NULL,0,NULL,true,'60204080100315','O',false,'TABS',false,'SANOFI-AVENTIS U.S.','T',false,'Test - Ambien','00','2002-03-11 00:00:00.000','b',51,'TEST-benzodiazepine related sedative/hypnotics - 2',30,10.0,'mg',37,'Tab',61,'Zolpidem Tartrate Oral tablet',NULL,1,NULL,NULL,30,10.0,'Hypnotic Agents - Benzodiazepine-Related Agents',1.0,'mg','10','MG','TEST - AMBIEN','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Ambien 10 MG Tablet','TEST - AMBIEN 10 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99511,'Test - Zolpidem 12.5mg ER Tablet','99999995011',6.11630010604858,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,false,854880,100.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'60204080100420','Y',false,'TBCR',false,'SANDOZ','G',false,'Test - Zolpidem Tartrate ER','00',NULL,'b',51,'TEST-benzodiazepine related sedative/hypnotics - 2',30,12.5,'mg',40,'Tab ER',5346,'Zolpidem Tartrate Oral tablet, biphasic release',NULL,1,NULL,NULL,30,12.5,'Hypnotic Agents - Benzodiazepine-Related Agents',1.0,'mg','12.5','MG','TEST - ZOLPIDEM TARTRATE ER','Tablet Extended Release','Oral','Tablet ER',NULL,NULL,NULL,NULL,'Test - Zolpidem Tartrate ER 12.5 MG Tablet Extended Release','TEST - ZOLPIDEM TARTRATE ER 12.5 MG TABLET EXTENDED RELEASE',NULL,0.0,0.0,NULL,NULL), (99512,'Test - Zaleplon 10mg Capsule','99999995012',3.7878999710083,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,false,313761,100.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'60204070000130','Y',false,'CAPS',false,'HIKMA','G',false,'Test - Zaleplon','00',NULL,'b',51,'TEST-benzodiazepine related sedative/hypnotics - 2',30,10.0,'mg',43,'Cap',3449,'Zaleplon Oral capsule',NULL,1,NULL,NULL,30,10.0,'Hypnotic Agents - Benzodiazepine-Related Agents',1.0,'mg','10','MG','TEST - ZALEPLON','Capsule','Oral','Capsule',NULL,NULL,NULL,NULL,'Test - Zaleplon 10 MG Capsule','TEST - ZALEPLON 10 MG CAPSULE',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99510,'Test - Zolpidem 10mg Tablet','99999995013',4.62540006637573,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,false,854873,100.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'60204080100315','Y',false,'TABS',false,'TEVA PHARMACEUTICALS USA','G',false,'Test - Zolpidem Tartrate','00',NULL,'b',51,'TEST-benzodiazepine related sedative/hypnotics - 2',30,10.0,'mg',37,'Tab',61,'Zolpidem Tartrate Oral tablet',NULL,1,NULL,NULL,30,10.0,'Hypnotic Agents - Benzodiazepine-Related Agents',1.0,'mg','10','MG','TEST - ZOLPIDEM TARTRATE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Zolpidem Tartrate 10 MG Tablet','TEST - ZOLPIDEM TARTRATE 10 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Basaglar KwikPen100unit/mL Inj','99999995050',27.1966590881348,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999505,3.0,'ml',2,1,'2',2,false,false,NULL,0,NULL,false,'2710400300D220','N',true,'SOPN',true,'LILLY','T',false,'Test - Basaglar KwikPen','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - BASAGLAR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Basaglar KwikPen 100 UNIT/ML Solution Pen-injector','TEST - BASAGLAR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Basaglar KwikPen100unit/mL Inj','99999995051',27.1966590881348,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999505,15.0,'ml',2,1,'2',2,false,false,NULL,0,NULL,false,'2710400300D220','N',true,'SOPN',false,'LILLY','T',false,'Test - Basaglar KwikPen','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - BASAGLAR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Basaglar KwikPen 100 UNIT/ML Solution Pen-injector','TEST - BASAGLAR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Lantus SoloStar 100unit/mL Inj','99999995052',35.4425010681152,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,230,'SANOFIUS','automation',30,3.0,true,999505,3.0,'ml',2,1,'88',2,false,false,NULL,0,NULL,false,'2710400300D220','N',true,'SOPN',false,'SANOFI-AVENTIS U.S.','T',true,'Test - Lantus SoloStar','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LANTUS SOLOSTAR','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Lantus SoloStar 100 UNIT/ML Solution Pen-injector','TEST - LANTUS SOLOSTAR 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Lantus SoloStar 100unit/mL Inj','99999995053',35.4425010681152,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,230,'SANOFIUS','automation',30,15.0,true,999505,15.0,'ml',2,1,'88',2,false,false,NULL,0,NULL,false,'2710400300D220','N',true,'SOPN',false,'SANOFI-AVENTIS U.S.','T',false,'Test - Lantus SoloStar','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LANTUS SOLOSTAR','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Lantus SoloStar 100 UNIT/ML Solution Pen-injector','TEST - LANTUS SOLOSTAR 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Semglee 100units/mL Soln Inj','99999995054',12.3316602706909,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,1919,'MYLAN','automation',30,15.0,true,999505,15.0,'ml',2,1,'49502',2,false,false,NULL,0,NULL,false,'2710400300D220','N',true,'SOPN',false,'MYLANSPECIALTY L.P.','T',false,'Test - Semglee','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - SEMGLEE','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Semglee 100 UNIT/ML Solution Pen-injector','TEST - SEMGLEE 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Insulin Glargine 100U/mL Inj','99999995055',12.3312501907349,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,10.0,true,999506,10.0,'ml',3,4,NULL,2,false,false,NULL,0,NULL,false,'27104003902020','N',true,'SOLN',false,'MYLANSPECIALTYL.P.','G',false,'Test - Insulin Glargine-yfgn','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN GLARGINE-YFGN','Solution','Subcutaneous','Solution',NULL,NULL,NULL,NULL,'Test - Insulin Glargine-yfgn 100 UNIT/ML Solution','TEST - INSULIN GLARGINE-YFGN 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99506,'Test-Levemir FlexTouch Soln for Inj','99999995056',38.5175018310547,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVONORDK','automation',30,15.0,true,999507,15.0,'ml',1,1,'169',2,false,false,NULL,0,NULL,false,'2710400600D220','N',true,'SOPN',false,'NOVONORDISK','T',false,'Test - Levemir FlexTouch','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6486,'TEST-Insulin Detemir (Recombinant) Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LEVEMIR FLEXTOUCH','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Levemir FlexTouch 100 UNIT/ML Solution Pen-injector','TEST - LEVEMIR FLEXTOUCH 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99507,'Test-Tresiba 100unit/mL for Inj','99999995057',42.3691596984863,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVONORDK','automation',30,15.0,false,999508,15.0,'ml',1,1,'169',2,false,false,NULL,0,NULL,false,'2710400700D210','N',true,'SOPN',false,'NOVONORDISK','T',false,'Test - Tresiba FlexTouch','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',12648,'TEST-Insulin Degludec Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - TRESIBA FLEXTOUCH','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Tresiba FlexTouch 100 UNIT/ML Solution Pen-injector','TEST - TRESIBA FLEXTOUCH 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99505,'Test-Lantus 100units/mL for Inj','99999995058',35.4449996948242,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,230,'SANOFIUS','automation',30,10.0,true,999505,10.0,'ml',2,1,'88',2,false,false,NULL,0,NULL,false,'27104003002020','N',true,'SOLN',false,'SANOFI-AVENTIS U.S.','T',false,'Test - Lantus','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LANTUS','Solution','Subcutaneous','Solution',NULL,NULL,NULL,NULL,'Test - Lantus 100 UNIT/ML Solution','TEST - LANTUS 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99505,'Test-Semglee 100units/mL Soln Inj','99999995059',12.3316602706909,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,1919,'MYLAN','automation',30,15.0,true,999505,15.0,'ml',2,1,'49502',2,false,true,NULL,0,'NULL',false,'2710400390D220','N',true,'SOPN',false,'MYLAN SPECIALTY L.P.','T',false,'Test - Semglee (yfgn)','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6177,'TEST-Insulin Glargine Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - SEMGLEE (YFGN)','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Semglee (yfgn) 100 UNIT/ML Solution Pen-injector','TEST - SEMGLEE (YFGN) 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99506,'Test-Levemir FlexTouch Soln for Inj','99999995060',38.5175018310547,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,256,'NOVO NORDK','automation',30,15.0,true,999507,15.0,'ml',1,1,'169',2,false,true,NULL,0,NULL,false,'2710400600D220','N',true,'SOPN',false,'NOVO NORDISK','T',false,'Test - Levemir FlexTouch','00',NULL,'b',52,'TEST-long-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',6486,'TEST-Insulin Detemir (Recombinant) Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LEVEMIR FLEXTOUCH','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Levemir FlexTouch 100 UNIT/ML Solution Pen-injector','TEST - LEVEMIR FLEXTOUCH 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog 100unit/ml for Inj','99999995200',34.3375015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999520,10.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG 100unit/ml for Inj',false,'27104005002022','N',true,'SOCT',false,'LILLY','T',false,'Test - HumaLOG','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - HumaLOG 100 UNIT/ML Solution','TEST - HUMALOG 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog 100unit/ml for Inj','99999995201',34.3375015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999520,3.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG 100unit/ml for Inj',false,'27104005002022','N',true,'SOCT',false,'LILLY','T',false,'Test - HumaLOG','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - HumaLOG 100 UNIT/ML Solution','TEST - HUMALOG 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog 100unit/ml for Inj','99999995202',42.5374984741211,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999520,3.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG 100unit/ml for Inj',false,'2710400500F220','N',true,'SOCT',true,'LILLY','T',false,'Test - HumaLOG','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG','Solution Cartridge','Subcutaneous','Soln Cart',NULL,NULL,NULL,NULL,'Test - HumaLOG 100 UNIT/ML Solution Cartridge','TEST - HUMALOG 100 UNIT/ML SOLUTION CARTRIDGE',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog 100unit/ml for Inj','99999995203',42.5374984741211,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999520,15.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG 100unit/ml for Inj',false,'2710400500F220','N',true,'SOCT',false,'LILLY','T',false,'Test - HumaLOG','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG','Solution Cartridge','Subcutaneous','Soln Cart',NULL,NULL,NULL,NULL,'Test - HumaLOG 100 UNIT/ML Solution Cartridge','TEST - HUMALOG 100 UNIT/ML SOLUTION CARTRIDGE',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog Jr KwikPen Sol for Inj','99999995204',44.2000007629395,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999520,3.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG Jr KwikPen Sol for Inj',false,'2710400500D221','N',true,'SOPN',true,'LILLY','T',false,'Test - HumaLOG Junior KwikPen','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG JUNIOR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - HumaLOG Junior KwikPen 100 UNIT/ML Solution Pen-injector','TEST - HUMALOG JUNIOR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Humalog Jr KwikPen Sol for Inj','99999995205',44.2000007629395,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,15.0,true,999520,15.0,'ml',2,1,'2',2,false,false,NULL,0,'HumaLOG Jr KwikPen Sol for Inj',false,'2710400500D221','N',true,'SOPN',false,'LILLY','T',false,'Test - HumaLOG Junior KwikPen','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - HUMALOG JUNIOR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - HumaLOG Junior KwikPen 100 UNIT/ML Solution Pen-injector','TEST - HUMALOG JUNIOR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL), (99520,'Test-LYUMJEV 100unit/mL Injection','99999995206',34.3375015258789,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,157,'ELILILLY','automation',30,10.0,true,999520,10.0,'ml',2,1,'2',2,false,false,NULL,0,NULL,false,'27104005052020','N',true,'SUPN',false,'LILLY','T',false,'Test - Lyumjev','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - LYUMJEV','Solution','Injection','Solution',NULL,NULL,NULL,NULL,'Test - Lyumjev 100 UNIT/ML Solution','TEST - LYUMJEV 100 UNIT/ML SOLUTION',NULL,0.0,0.0,NULL,NULL), (99520,'Test-Lispro 100unit/mL Jr. KwikPen','99999995207',13.2600002288818,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',30,15.0,true,999521,3.0,'ml',3,1,NULL,2,false,false,NULL,0,NULL,false,'2710400500D221','N',true,'SOPN',true,'LILLY','G',false,'Test - Insulin Lispro Junior KwikPen','00',NULL,'b',55,'TEST-rapid-acting human insulins and analogs',30,NULL,'bulk',200,'Inj Sol',697,'TEST-Insulin Lispro Solution for injection',NULL,NULL,1.0,'mL',1,100.0,NULL,NULL,'U','100','UNIT/ML','TEST - INSULIN LISPRO JUNIOR KWIKPEN','Solution Pen-injector','Subcutaneous','Soln Pen-inj',NULL,NULL,NULL,NULL,'Test - Insulin Lispro Junior KwikPen 100 UNIT/ML Solution Pen-injector','TEST - INSULIN LISPRO JUNIOR KWIKPEN 100 UNIT/ML SOLUTION PEN-INJECTOR',NULL,0.0,0.0,NULL,NULL); $$);