
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CVS_Eligibility_DataSeed_1', $$INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999100',NULL,'1','WINKLE','PERI',NULL,'F','2000-01-01','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999100' AND dob = '2000-01-01'); INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33MB','33M','W0051752015','HMOX00011000','99999999200',NULL,'1','BELL','ROSETTA',NULL,'F','2000-02-01','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999200' AND dob = '2000-02-01'); INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999300',NULL,'1','STORM','VIDIA',NULL,'F','2000-03-01','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999300' AND dob = '2000-03-01'); INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999400',NULL,'1','PIXIE','ZARINA',NULL,'F','2000-04-01','0','7TH STREET',NULL,'Bloomfield Row','CA','90001','2021-01-01','3021-01-01','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999400' AND dob = '2000-04-01'); INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999500',NULL,'1','MIST','SILVER',NULL,'F','2000-05-01','0','7TH STREET',NULL,'Bloomfield Row','CA','90001','2021-01-01','3021-01-01','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999500' AND dob = '2000-05-01'); INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT '3','33MB','33M','W0051752015','HMOX00011000','99999999600',NULL,'1','WALKER','PRILLA',NULL,'F','2000-06-01','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999600' AND dob = '2000-06-01'); INSERT INTO cvs_eligibilities(record_type, carrier, super_carrier, account, "group", member_id, person_code, relationship, last_name, first_name, middle_initial, gender, dob, multi_birth_code, address_1, address_2, city, state, zip_code, effective_date, termination_date, inserted_at, updated_at, payer_name) SELECT '3', '33AB', '33A', 'W0051411', 'HMOX00011000N', '99999999700', NULL, '1', 'WINKLE', 'MARK', NULL, 'F', '2000-01-01', '0', 'BEACON REGRESSION', NULL, 'AUTOMATION', 'WI', '53144', '2020-12-31', '2039-12-31', '2021-01-01 01:01:01.000', '2021-01-01 01:01:01.000', 'BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999700' AND dob = '2000-01-01'); INSERT INTO cvs_eligibilities(record_type, carrier, super_carrier, account, "group", member_id, person_code, relationship, last_name, first_name, middle_initial, gender, dob, multi_birth_code, address_1, address_2, city, state, zip_code, effective_date, termination_date, inserted_at, updated_at, payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999800',NULL,'1','WING','TIZZY',NULL,'F','2000-07-01','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999800' AND dob = '2000-07-01'); INSERT INTO cvs_eligibilities(record_type, carrier, super_carrier, account, "group", member_id, person_code, relationship, last_name, first_name, middle_initial, gender, dob, multi_birth_code, address_1, address_2, city, state, zip_code, effective_date, termination_date, inserted_at, updated_at, payer_name) SELECT '3','33AB','33A','W0051411','HMOX00011000N','99999999930',NULL,'1','UPTON','CYRUS',NULL,'M','2000-09-04','0','BEACON REGRESSION',NULL,'AUTOMATION','WI','53144','2020-12-31','2039-12-31','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','BSC' WHERE NOT EXISTS (SELECT id FROM cvs_eligibilities WHERE member_id = '99999999930' AND dob = '2000-09-04'); $$);