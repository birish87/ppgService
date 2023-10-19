
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CardholderIDLookupSeed', $$--7 Zeros
INSERT INTO eligibilities
    (bin,pcn,internal_group_id,group_id,member_id,member_case_id,first_name,last_name,sex,client_id,customer_id,dob,effective_date,termination_date,payer_id,inserted_at,updated_at)
SELECT '012353','01920000','119'	,'119','0000000Q12345678',	'7ZEROS',	'MC7',	'COVG7',	'Female',	'000CLNT116',	'96',	'1950-01-01',	'2016-01-01',	'2020-12-31',	4	,'2019-01-11 18:47:21.55473',	'2019-01-11 18:47:21.55473'
WHERE
    NOT EXISTS (
        SELECT id FROM eligibilities WHERE member_id = '0000000Q12345678'
    );
	
	--9 Zeros
	INSERT INTO eligibilities
    (bin,pcn,internal_group_id,group_id,member_id,member_case_id,first_name,last_name,sex,client_id,customer_id,dob,effective_date,termination_date,payer_id,inserted_at,updated_at)
SELECT '012353','01920000','119'	,'119','000000000T12345678',	'9ZEROS',	'MC9',	'COVG9',	'Female',	'000CLNT116',	'96',	'1950-01-01',	'2016-01-01',	'2020-12-31',	4	,'2019-01-11 18:47:21.55473',	'2019-01-11 18:47:21.55473'
WHERE
    NOT EXISTS (
        SELECT id FROM eligibilities WHERE member_id = '000000000T12345678'
    );$$);
