
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_BSC_NAS_Update', $$update product_lookup set gpi = '58180020207520'  where ndc = '00093914701';

update product_lookup set multi_source_code = 'O' where ndc = '70436001206';$$);
