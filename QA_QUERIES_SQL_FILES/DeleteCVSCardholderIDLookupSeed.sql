
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DeleteCVSCardholderIDLookupSeed', $$Delete from cvs_eligibilities where member_id='000000090300001300' or member_id='00000000090300001300'$$);
