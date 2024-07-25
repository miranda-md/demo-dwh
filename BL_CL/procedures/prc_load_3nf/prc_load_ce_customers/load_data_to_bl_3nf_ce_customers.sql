CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_customers()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_customers (customer_src_id, source_system, source_entity, customer_first_name, customer_last_name, customer_email, customer_phone_number, ta_insert_dt)
        SELECT DISTINCT customer_id AS customer_src_id,
                		'sa_coffee_shop_sales' AS source_system,
                		source_entity,
                		COALESCE(customer_first_name, 'n. a.'), 
                		COALESCE(customer_last_name, 'n. a.'), 
                		COALESCE(customer_email, 'n. a.'), 
                		COALESCE(customer_phone_number, 'n. a.'),
                		CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT customer_id, 
                       customer_first_name, 
                       customer_last_name, 
                       customer_email, 
                       customer_phone_number,
                       'src_coffee_shop_card' AS source_entity
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card
            	WHERE customer_id IS NOT NULL

            	UNION ALL

            	SELECT customer_id, 
                       customer_first_name, 
                       customer_last_name, 
                       customer_email, 
                       customer_phone_number,
                       'src_coffee_shop_cash' AS source_entity
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash
            	WHERE customer_id IS NOT NULL
        	) AS tab
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_customers AS c
                          WHERE c.customer_src_id = tab.customer_id AND
                                UPPER(c.source_system) = UPPER(source_system) AND
                                UPPER(c.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_customers', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;	
    END;
END;
$$;