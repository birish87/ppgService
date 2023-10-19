
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('DDP_BSC_NAS_Update_Revert', $$update product_lookup set gpi = '58180090100320'  where ndc = '00093914701';
update product_lookup set multi_source_code = 'Y' where ndc = '70436001206';$$);
