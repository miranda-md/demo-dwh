CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_products_scd()
LANGUAGE plpgsql
AS $$
DECLARE
    counter_insert INTEGER := 0;
    counter_update INTEGER := 0;
	prod_record RECORD;
BEGIN
    BEGIN
    	INSERT INTO bl_3nf.bl_3nf_ce_products_scd (product_src_id, source_system, source_entity, product_title, product_category_id, product_description, product_price, product_size, ta_insert_dt)
        SELECT DISTINCT tab.product_id AS product_src_id,
                        tab.source_system,
                        tab.source_entity,
                        tab.product_title,
                        pc.product_category_id,
                        tab.product_description,
                        tab.product_price,
                        COALESCE(tab.product_size, 'n. a.') AS product_size,
                        CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT 'src_coffee_shop_card' AS source_entity,
            			'sa_coffee_shop_sales' AS source_system,
                   		product_category,
                   		product_id,
                   		product_title,
                   		product_description,
                   		product_price,
                   		COALESCE(product_size, 'n. a.') AS product_size
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL

            	SELECT 'src_coffee_shop_cash' AS source_entity,
            			'sa_coffee_shop_sales' AS source_system,
                   		product_category,
                   		product_id,
                   		product_title,
                   		product_description,
                   		product_price,
                   		COALESCE(product_size, 'n. a.') AS product_size
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
        	) AS tab
        LEFT JOIN bl_3nf.bl_3nf_ce_product_categories pc ON UPPER(pc.product_category_title) = UPPER(tab.product_category) AND
                                                           UPPER(pc.source_system) = UPPER(tab.source_system) AND
                                                           UPPER(pc.source_entity) = UPPER(tab.source_entity)   
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_products_scd AS p
                          WHERE p.product_src_id = tab.product_id AND
                               UPPER(p.source_system) = UPPER(tab.source_system) AND
                               UPPER(p.source_entity) = UPPER(tab.source_entity) AND
                               p.ta_is_active = true AND
                               p.product_title = tab.product_title AND
								pc.product_category_title = tab.product_category AND
               					p.product_description = tab.product_description AND
               					p.product_price = tab.product_price AND
               					p.product_size = tab.product_size);
        GET DIAGNOSTICS counter_insert = ROW_COUNT;
                               
                              

		MERGE INTO bl_3nf.bl_3nf_ce_products_scd p
		USING (
			SELECT COUNT(ta_is_active), product_src_id, source_system, source_entity, MAX(ta_insert_dt) AS last_insert
			FROM bl_3nf.bl_3nf_ce_products_scd
			WHERE ta_is_active = true
			GROUP BY ta_is_active, product_src_id, source_system, source_entity
			HAVING COUNT(ta_is_active) > 1
		) AS t
		ON p.product_src_id = t.product_src_id AND
           UPPER(p.source_system) = UPPER(t.source_system) AND
           UPPER(p.source_entity) = UPPER(t.source_entity) AND
           p.ta_is_active = true
		WHEN MATCHED AND p.ta_insert_dt < t.last_insert THEN
			UPDATE SET ta_is_active = false,
					   ta_end_dt = CURRENT_TIMESTAMP
	   	WHEN MATCHED THEN
	   		UPDATE SET ta_start_dt = CURRENT_TIMESTAMP;

		GET DIAGNOSTICS counter_update = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
        CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_products_scd', counter_insert + counter_update, CONCAT('Inserted rows ', CAST(counter_insert AS VARCHAR), '; Updated rows ', CAST(counter_update AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$;