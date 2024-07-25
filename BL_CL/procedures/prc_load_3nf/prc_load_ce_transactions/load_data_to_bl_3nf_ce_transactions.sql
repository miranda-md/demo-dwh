CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_transactions()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_transactions (transaction_src_id, source_system, source_entity, transaction_date, transaction_time, ta_insert_dt)
        SELECT DISTINCT transaction_id AS transaction_src_id,
                        'sa_coffee_shop_sales' AS source_system,
                        source_entity,
                        CAST(transaction_date AS DATE),
                        CAST(transaction_time AS TIME),
                        CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT transaction_id,
            		   transaction_date,
                   	   transaction_time,
                   	   'src_coffee_shop_card' AS source_entity  
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL
            	
            	SELECT transaction_id,
                   	   transaction_date,
                   	   transaction_time,
                   	   'src_coffee_shop_cash' AS source_entity
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
        	) AS tab
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_transactions AS t
                          WHERE t.transaction_src_id = tab.transaction_id AND
                                UPPER(t.source_system) = UPPER(source_system) AND
                                UPPER(t.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_transactions', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;	
    END;
END;
$$;