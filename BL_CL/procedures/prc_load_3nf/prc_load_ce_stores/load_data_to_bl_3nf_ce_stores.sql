CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_stores()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_stores (store_src_id, source_system, source_entity, store_description, city_id, address, store_manager_id, ta_insert_dt)
        SELECT DISTINCT store_id AS store_src_id,
                        'sa_coffee_shop_sales' AS source_system,
                        tab.source_entity,
                        store_description,
                        c.city_id,
                        address,
                        -1 AS store_manager_id,
                        CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT 'src_coffee_shop_card' AS source_entity,
                    	store_id,
                    	store_description,
                    	src.store_address AS address,
                    	store_city
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL

            	SELECT 'src_coffee_shop_cash' AS source_entity,
                    	store_id,
                    	store_description,
                    	src2.store_address AS address,
                    	store_city
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
        	) AS tab
        LEFT JOIN bl_3nf.bl_3nf_ce_cities c ON UPPER(c.city_title) = UPPER(tab.store_city) AND -- there is no city_id in the datasets
                                               UPPER(c.source_system) = UPPER('sa_coffee_shop_sales') AND
                                               UPPER(c.source_entity) = UPPER(tab.source_entity)
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_stores AS s
                          WHERE s.store_src_id = tab.store_id AND
                                UPPER(s.source_system) = UPPER('sa_coffee_shop_sales') AND
                                UPPER(s.source_entity) = UPPER(tab.source_entity));

        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_stores', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;	
    END;
END;
$$;