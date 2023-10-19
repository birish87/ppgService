
INSERT INTO public."QA_QUERIES" (name, query)
VALUES ('addCarrierGroup', $$Insert INTO Carrier_Groups	(carrier_id,group_id,bin,pcn,client_name,inserted_at,updated_at)
Select 'NJ1000', '00863430050', '016499', 'HZRX', 'TEST','2019-09-17 21:53:49.728308','2019-09-17 21:53:49.728308'

WHERE
	
	NOT EXISTS 	(
		
		SELECT id FROM Carrier_Groups WHERE carrier_id = 'NJ1000'
	);$$);
