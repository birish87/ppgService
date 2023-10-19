
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CVS_Eligibility_DataSeed_template', $$INSERT INTO cvs_eligibilities (record_type,carrier,super_carrier,account,"group",member_id,person_code,relationship,last_name,first_name,middle_initial,gender,dob,multi_birth_code,address_1,address_2,city,state,zip_code,effective_date,termination_date,inserted_at,updated_at,payer_name) SELECT  WHERE NOT EXISTS ( SELECT id FROM cvs_eligibilities WHERE member_id = '' AND dob = '' ) ;$$);
