
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('update_payer_products', $$update payer_products set sps_enabled = true where product_type = 'dsr' and product_sub_type in ('D','E')$$);
