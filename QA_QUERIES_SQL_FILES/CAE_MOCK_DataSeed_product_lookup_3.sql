
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CAE_MOCK_DataSeed_product_lookup_3', $$INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99573,'Test-Ethynodiol/Estradiol 1/35 Tab','99999995703',1.06713998317719,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',28,28.0,true,748804,28.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,false,'25990002200310','Y',false,'TABS',false,'MYLAN','G',false,'Test - Ethynodiol Diac-Eth Estradiol','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',666,'TEST-Ethynodiol Diacetate, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,1.0,NULL,1.0,'mg','1-35','MG-MCG','TEST - ETHYNODIOL DIAC-ETH ESTRADIOL','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Ethynodiol Diac-Eth Estradiol 1-35 MG-MCG Tablet','TEST - ETHYNODIOL DIAC-ETH ESTRADIOL 1-35 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99574,'Test-Blisovi Fe 1.5/30 Tablet','99999995704',1.03345000743866,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,1365,'LUPIN','automation',28,28.0,true,2099508,28.0,'ea',3,4,'68180',2,false,false,NULL,0,NULL,false,'25990003610320','Y',false,'TABS',true,'LUPIN PHARMACEUTICALS','T',false,'Test - Blisovi Fe 1.5/30','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',1460,'TEST-Ferrous Fumarate Oral tablet',NULL,NULL,NULL,NULL,0,75.0,NULL,1.0,'mg','1.5-30','MG-MCG','TEST - BLISOVI FE 1.5/30','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Blisovi Fe 1.5/30 1.5-30 MG-MCG Tablet','TEST - BLISOVI FE 1.5/30 1.5-30 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99575,'Test-Orsythia 28-Day Tablet','99999995705',1.25571000576019,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3555,'PAR','automation',28,28.0,true,2465331,28.0,'ea',3,4,'254',2,false,false,NULL,0,NULL,false,'25990002400305','Y',false,'TABS',false,'PAR PHARMACEUTICAL','T',false,'Test - Orsythia','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',17,'TEST-Levonorgestrel, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,0.1,NULL,1.0,'mg','0.1-20','MG-MCG','TEST - ORSYTHIA','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Orsythia 0.1-20 MG-MCG Tablet','TEST - ORSYTHIA 0.1-20 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99576,'Test-Levon/Estrad 0.15mg-0.03mg Tab','99999995706',1.10464000701904,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',28,28.0,true,748878,28.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,false,'25990002400310','Y',false,'TABS',false,'MYLAN','G',false,'Test - Levonorgestrel-Ethinyl Estrad','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',2,'TEST-Desogestrel, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,0.15,NULL,1.0,'mg','0.15-30','MG-MCG','TEST - LEVONORGESTREL-ETHINYL ESTRAD','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Levonorgestrel-Ethinyl Estrad 0.15-30 MG-MCG Tablet','TEST - LEVONORGESTREL-ETHINYL ESTRAD 0.15-30 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99577,'Test-Kalliga 28-Day Tablet','99999995707',1.40499997138977,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,1536,'AUROBINDO','automation',28,28.0,true,1923421,28.0,'ea',3,4,'65862',2,false,false,NULL,0,NULL,false,'25990002100320','Y',false,'TABS',true,'AUROBINDO PHARMA','T',false,'Test - Kalliga','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',17,'TEST-Levonorgestrel, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,0.15,NULL,1.0,'mg','0.15-30','MG-MCG','TEST - KALLIGA','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Kalliga 0.15-30 MG-MCG Tablet','TEST - KALLIGA 0.15-30 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99577,'Test-Desogen 28-Day Tablet','99999995708',2.12723994255066,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,205,'ORGANON','automation',28,28.0,true,1923421,28.0,'ea',2,1,'52',2,false,false,NULL,0,NULL,false,'25990002100320','O',false,'TABS',false,'MERCK SHARP & DOHME','T',false,'Test - Desogestrel-Ethinyl Estradiol','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',17,'TEST-Levonorgestrel, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,0.15,NULL,1.0,'mg','0.15-30','MG-MCG','TEST - DESOGESTREL-ETHINYL ESTRADIOL','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Desogestrel-Ethinyl Estradiol 0.15-30 MG-MCG Tablet','TEST - DESOGESTREL-ETHINYL ESTRADIOL 0.15-30 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99578,'Test-Nortrel 1/35 21-Day Tablet','99999995709',1.4047600030899,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,358,'TEVA','automation',21,21.0,true,751871,21.0,'ea',1,4,'555',2,false,false,NULL,0,NULL,false,'25990002500320','Y',false,'TABS',false,'TEVA PHARMACEUTICALS USA','T',false,'Test - Nortrel 1/35 (28)','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',1457,'TEST-Ethinyl Estradiol, Norethindrone Oral tablet',NULL,NULL,NULL,NULL,0,0.035,NULL,1.0,'mg','1-35','MG-MCG','TEST - NORTREL 1/35 (28)','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Nortrel 1/35 (28) 1-35 MG-MCG Tablet','TEST - NORTREL 1/35 (28) 1-35 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (99579,'Test-LARIN 1/20 21-Day Tablet','99999995710',1.36476004123688,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,1959,'NORTHSTAR','automation',21,21.0,true,1927366,21.0,'ea',3,4,'16714',2,false,false,NULL,0,NULL,false,'25990002600310','Y',false,'TABS',false,'NORTHSTAR RX','T',false,'Test - Larin 1/20','00',NULL,'b',58,'TEST-monophasic contraceptives',30,NULL,'bulk',37,'Tab',1459,'TEST-Norethindrone Acetate, Ethinyl Estradiol Oral tablet',NULL,NULL,NULL,NULL,0,1.0,NULL,1.0,'mg','1-20','MG-MCG','TEST - LARIN 1/20','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Larin 1/20 1-20 MG-MCG Tablet','TEST - LARIN 1/20 1-20 MG-MCG TABLET',NULL,0.0,0.0,NULL,NULL), (2,'Test-Rapamune 0.5mg Tablet','99999995800',20.6583805084229,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,168,'PFIZER','automation',0,0.0,true,905160,100.0,'ea',2,1,'00008',2,false,false,NULL,0,NULL,false,'99404070000310','O',false,'TABS',false,'PFIZER U.S.','T',false,'TST Rapamune','00',NULL,'b',16,'TEST-Test-mammalian target of rapamycin (mtor) kinase inhibitors - transplant 1',30,3.0,'mg',37,'Tab',1793,'Sirolimus Oral tablet',NULL,NULL,NULL,NULL,30,0.5,'Immunosuppressants - mammalian target of rapamycin (mtor) kinase inhibitors',1.0,'mg','0.5','MG','TST RAPAMUNE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'TST Rapamune 0.5 MG Tablet','TST RAPAMUNE 0.5 MG TABLET',NULL,0.0,0.0,NULL,NULL), (2,'Test-Sirolimus 0.5mg Tablet','99999995801',8.47379970550537,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,905158,100.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,false,'99404070000311','Y',false,'TABS',false,'GREENSTONE','G',false,'Test-Sirolimus mG','00',NULL,'b',16,'TEST-Test-mammalian target of rapamycin (mtor) kinase inhibitors - transplant 1',30,3.0,'mg',37,'Tab',1793,'Sirolimus Oral tablet',NULL,NULL,NULL,NULL,30,0.5,'Immunosuppressants - mammalian target of rapamycin (mtor) kinase inhibitors',1.0,'mg','0.5','MG','TEST-SIROLIMUS MG','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test-Sirolimus mG 0.5 MG Tablet','TEST-SIROLIMUS MG 0.5 MG TABLET',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (2,'Test-Everolimus 0.25mg Tablet','99999995802',10.5714998245239,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,977427,60.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'99404035000321','N',false,'TABS',false,'HIKMA','B',false,'Test - Test-Everolimus','00',NULL,'b',16,'TEST-Test-mammalian target of rapamycin (mtor) kinase inhibitors - transplant 1',30,3.0,'mg',37,'Tab',1793,'Sirolimus Oral tablet',NULL,NULL,NULL,NULL,30,0.5,'Immunosuppressants - mammalian target of rapamycin (mtor) kinase inhibitors',1.0,'mg','0.25','MG','TEST - TEST-EVEROLIMUS','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Test-Everolimus 0.25 MG Tablet','TEST - TEST-EVEROLIMUS 0.25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (2,'Test-Eve 0.25mg Tablet','99999995803',1.5714998245239,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,false,977427,60.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,true,'99404035000322','M',false,'TABS',false,'HIKMA1','B',false,'EVE Test (mG)','00',NULL,'b',16,'TEST-mammalian target of rapamycin (mtor) kinase inhibitors - transplant 1',30,1.5,'mg',37,'Tab',8173,'Eve Oral tablet',NULL,NULL,NULL,NULL,30,0.25,'Immunosuppressants - mammalian target of rapamycin (mtor) kinase inhibitors',1.0,'mg','0.25','MG','EVE TEST (MG)','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'EVE Test (mG) 0.25 MG Tablet','EVE TEST (MG) 0.25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (2,'Test-Eve2 0.25mg Tablet','99999995804',1.2514998245239,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',60,20.0,false,977427,60.0,'ea',3,4,NULL,2,false,false,NULL,0,NULL,false,'99404035000323',NULL,false,'TABS',false,'HIKMA2','B',false,'Test - Test-EVE','00',NULL,'b',16,'TEST-mammalian target of rapamycin (mtor) kinase inhibitors - transplant 1',30,1.5,'bulk',37,'Tab',8173,'Eve Oral tablet',NULL,NULL,NULL,NULL,30,0.25,'Immunosuppressants - mammalian target of rapamycin (mtor) kinase inhibitors',1.0,'mg','0.25','MG','TEST - TEST-EVE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Test-EVE 0.25 MG Tablet','TEST - TEST-EVE 0.25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99590,'Test-LAMICTAL 25mg Tablet','99999995900',18.4747505187988,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,260,'GSK','automation',0,0.0,true,2001508,100.0,'ea',2,1,'173',2,false,false,NULL,0,'LaMICtal 25mg Tablet',false,'72600040000310','O',false,'TABS',false,'Test-GLAXO SMITH KLINE','T',false,'Test - Test-LaMICtal','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','25','MG','TEST - TEST-LAMICTAL','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Test-LaMICtal 25 MG Tablet','TEST - TEST-LAMICTAL 25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Lamotrigine 25mg Tablet','99999995901',4.15959978103638,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,282401,100.0,'ea',3,4,NULL,2,false,false,NULL,0,'lamoTRIgine 25mg Tablet',false,'72600040000310','Y',false,'TABS',false,'Test-DR.REDDYS LABORATORIES, INC.','G',false,'Test - Test-lamoTRIgine','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','25','MG','TEST - TEST-LAMOTRIGINE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Test-lamoTRIgine 25 MG Tablet','TEST - TEST-LAMOTRIGINE 25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99591,'Test-Lamotrigine 25mg ODT','99999995902',8.9453296661377,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,198430,30.0,'ea',3,4,NULL,2,false,false,NULL,0,'lamoTRIgine 25mg ODT',false,'72600040007225','Y',false,'TBDP',false,'Test-AJANTA PHARMA LIMITED','G',false,'Test - Test-lamoTRIgine','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',42,'Tab Orally Dis',8232,'Test-Lamotrigine Oral disintegrating tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','25','MG','TEST - TEST-LAMOTRIGINE','Tablet Disintegrating','Oral','Tablet Disint',NULL,NULL,NULL,NULL,'Test - Test-lamoTRIgine 25 MG Tablet Disintegrating','TEST - TEST-LAMOTRIGINE 25 MG TABLET DISINTEGRATING',NULL,0.0,0.0,NULL,NULL), (99590,'Test-LAMICTAL 25mg Starter Kit','99999995903',18.4753494262695,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,260,'GSK','automation',0,0.0,true,2001508,35.0,'ea',2,1,'173',2,false,false,NULL,0,'LaMICtal 25mg Starter Kit',false,'72600040006420','O',false,'KIT',false,'Test-GLAXO SMITH KLINE','T',false,'Test - Test-LaMICtal Starter','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-LAMICTAL STARTER','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-LaMICtal Starter 35 x 25 MG Kit','TEST - TEST-LAMICTAL STARTER 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Lamotrigine 25mg Tablet','99999995904',4.1806001663208,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,282401,500.0,'ea',3,4,NULL,2,false,false,NULL,0,'lamoTRIgine 25mg Tablet',false,'72600040000310','Y',false,'TABS',false,'Test-UNICHEM PHARMACEUTICALS','G',false,'Test - Test-lamoTRIgine','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','25','MG','TEST - TEST-LAMOTRIGINE','Tablet','Oral','Tablet',NULL,NULL,NULL,NULL,'Test - Test-lamoTRIgine 25 MG Tablet','TEST - TEST-LAMOTRIGINE 25 MG TABLET',NULL,0.0,0.0,NULL,NULL), (99591,'Test-Lamotrigine 25mg ODT','99999995905',8.9453296661377,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',false,NULL,NULL,'automation',0,0.0,true,198430,30.0,'ea',3,4,NULL,2,false,false,NULL,0,'lamoTRIgine 25mg ODT',false,'72600040007225','Y',false,'TBDP',false,'Test-DR.REDDYS LABORATORIES, INC.','G',false,'Test - Test-lamoTRIgine','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',42,'Tab Orally Dis',8232,'Test-Lamotrigine Oral disintegrating tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','25','MG','TEST - TEST-LAMOTRIGINE','Tablet Disintegrating','Oral','Tablet Disint',NULL,NULL,NULL,NULL,'Test - Test-lamoTRIgine 25 MG Tablet Disintegrating','TEST - TEST-LAMOTRIGINE 25 MG TABLET DISINTEGRATING',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995906',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL); INSERT INTO product_lookup (specific_product_id,"name",ndc,unit_price,inserted_at,updated_at,brand,manufacturer,manufacturer_name,updated_by,default_dos,default_qty,maintenance,rxcui,package_size,ncpdp_billing_unit,ssms_type_id,brand_generic_status_id,labeler_code,unit_dose_type_id,private_label,repackaged,off_market_date,limited_distribution_id,tall_man_name,periodic,gpi,multi_source_code,injectable_insulin,medi_span_dosage_form,medi_span_inner_pack,medi_span_manufacturer_name,brand_name_code,medi_span_clinic_pack_code,medi_span_drug_name,medi_span_limited_distribution_code,medi_span_old_effective_date,medi_span_repackage_code,concept_id,concept_name,days_supply,ddd,ddd_units,form_id,form_name,generic_drug_item_id,generic_drug_item_name,maximum_daily_dosage,minimum_frequency,per,per_unit,quantity,strength,super_concept,times_per_day,units,medi_span_strength,medi_span_strength_unit_of_measure,ms_drug_name_normalized,medi_span_dosage_form_description,medi_span_route_of_administration,medi_span_dosage_form_abbreviation,medi_span_labeler_identifier,medi_span_legend_indicator_code,medi_span_maintenance_drug_code,package_description,extended_drug_name,extended_drug_name_normalized,package_size_unit_of_measure,medi_span_package_size,package_quantity,drug_name_titleized,name_hash) VALUES (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995907',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,NULL,'Y',false,'KIT',false,NULL,NULL,false,'Test - Test-Subvenite Starter Kit-Blue','00',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995908',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995909',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,NULL,'T',false,'Test - Test-Subvenite Starter Kit-Blue','0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995910',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS',NULL,false,'Test - Test-Subvenite Starter Kit-Blue','2',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995911',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','0',NULL,'X',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995912',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,NULL,'0',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG',NULL,'Kit','Oral','Kit',NULL,NULL,NULL,NULL,' 35 x 25 MG Kit',' 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995913',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue',NULL,NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995914',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','0','2022-01-01 00:00:00.000','b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995915',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','0',NULL,NULL,59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL), (99590,'Test-Subvenite 25mg Strt Kit (Blue)','99999995916',18.7142906188965,'2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',true,3497,'OWP','automation',0,0.0,true,2001508,35.0,'ea',3,4,'69102',1,false,false,NULL,0,NULL,false,'72600040006420','Y',false,'KIT',false,'Test-OWP PHARMACEUTICALS','T',false,'Test - Test-Subvenite Starter Kit-Blue','1',NULL,'b',59,'TEST-anticonvulsants, miscellaneous - lamotrigine - 2',30,50.0,'mg',37,'Tab',719,'Test-Lamotrigine Oral tablet',NULL,1,NULL,NULL,60,25.0,'Anticonvulsants - Lamotrigine',2.0,'mg','35 x 25','MG','TEST - TEST-SUBVENITE STARTER KIT-BLUE','Kit','Oral','Kit',NULL,NULL,NULL,NULL,'Test - Test-Subvenite Starter Kit-Blue 35 x 25 MG Kit','TEST - TEST-SUBVENITE STARTER KIT-BLUE 35 X 25 MG KIT',NULL,0.0,0.0,NULL,NULL); $$);