
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('CAE_MOCK_DataSeed_payer_excluded_drugs', $$INSERT INTO payer_excluded_drugs (payer_id,ndc,inserted_at,updated_at,lob_type) VALUES (4,'99999997000','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000','commercial'), (4,'99999997002','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',null), (4,'99999995502','2021-01-01 01:01:01.000','2021-01-01 01:01:01.000',null); $$);
