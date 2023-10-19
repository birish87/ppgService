
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CVSCardholderIDLookupSeed', $$--TWIN 1
INSERT INTO cvs_eligibilities 
	(record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name)
SELECT '3','33AB','33A','TWINS','TEST','K12345678',NULL,'1','JOHNSON','THOMAS',NULL,'M','1982-10-17','0','6838 55TH ST',NULL,'KENOSHA','WI','53144','2015-01-01','2039-12-31','2020-06-29 20:25:03.221','2020-06-29 20:25:03.221','BSC'
WHERE
	NOT EXISTS (
		SELECT id FROM cvs_eligibilities WHERE member_id = 'K12345678' and first_name = 'THOMAS'
	);
	
--TWIN 2
INSERT INTO cvs_eligibilities 
	(record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name)
SELECT '3','33AB','33A','TWINS','TEST','K12345678',NULL,'1','JOHNSON','TIMOTHY',NULL,'M','1982-10-17','0','6838 55TH ST',NULL,'KENOSHA','WI','53144','2015-01-01','2039-12-31','2020-06-29 20:25:03.221','2020-06-29 20:25:03.221','BSC'
WHERE
	NOT EXISTS (
		SELECT id FROM cvs_eligibilities WHERE member_id = 'K12345678' and first_name = 'TIMOTHY'
	);
	
--7 Zeros
INSERT INTO cvs_eligibilities 
	(record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name)
SELECT '3','33AB','33A','W0051411','HMOX00011000N','0000000M12345678',NULL,'1','7ZEROS','CY7',NULL,'F','1968-07-02','0','6838 55TH ST',NULL,'KENOSHA','WI','53144','2015-01-01','2039-12-31','2020-06-29 20:25:03.221','2020-06-29 20:25:03.221','BSC'
WHERE
	NOT EXISTS (
		SELECT id FROM cvs_eligibilities WHERE member_id = '0000000M12345678'
	);
	
--9 Zeros
INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name)
select '3','33AB','33A','W0051411','TEST','000000000V12345678',NULL,'1','9ZEROS','CY9',NULL,'F','1968-07-02','0','6838 55TH ST',NULL,'KENOSHA','WI','53144','2015-01-01','2039-12-31','2020-06-29 20:25:03.221','2020-06-29 20:25:03.221','BSC'
WHERE
NOT EXISTS (
		SELECT id FROM cvs_eligibilities WHERE member_id = '000000000V12345678'
	);
	
--Carrier Mismatch
INSERT INTO cvs_eligibilities 
	(record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name)
SELECT '3','99AB','33A','W0051411','CarIdMismatch','J98989898',NULL,'1','HERO','JACK',NULL,'M','1999-12-31','0','6838 55TH ST',NULL,'KENOSHA','WI','53144','2015-01-01','2039-12-31','2020-06-29 20:25:03.221','2020-06-29 20:25:03.221','BSC'
WHERE
	NOT EXISTS (
		SELECT id FROM cvs_eligibilities WHERE member_id = 'J98989898'
	);
$$);
