CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_payments()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_payments (payment_src_id, source_system, source_entity, payment_method, bank_id, ta_insert_dt)
        SELECT DISTINCT payment_id AS payment_src_id,
                		'sa_coffee_shop_sales' AS source_system,
                		tab.source_entity,
                		payment_method,
                		COALESCE(b.bank_id, -1) AS bank_id, -- there's no bank in the second dataset (-1 instead of null)
                		CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT payment_id,
                       payment_method,
                       bank_id,
                       bank_title,
                       'src_coffee_shop_card' AS source_entity 
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card

            	UNION ALL
        
            	SELECT payment_id,
                       payment_method,
                       NULL AS bank_id,
                       'n. a.' AS bank_title,
                       'src_coffee_shop_cash' AS source_entity
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash
        	) AS tab
        LEFT JOIN bl_3nf.bl_3nf_ce_banks b ON b.bank_src_id = tab.bank_id AND
                                              UPPER(b.source_system) = UPPER(source_system) AND
                                              UPPER(b.source_entity) = UPPER(tab.source_entity)
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_payments AS p
                          WHERE p.payment_src_id = tab.payment_id AND
                                UPPER(p.source_system) = UPPER(source_system) AND
                                UPPER(p.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_payments', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
     EXCEPTION
         WHEN others THEN
             ROLLBACK;
             RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$;