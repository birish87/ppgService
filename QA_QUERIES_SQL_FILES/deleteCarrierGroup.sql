
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('deleteCarrierGroup', $$Delete
From Carrier_Groups
Where Carrier_Id = 'NJ1000';$$);
