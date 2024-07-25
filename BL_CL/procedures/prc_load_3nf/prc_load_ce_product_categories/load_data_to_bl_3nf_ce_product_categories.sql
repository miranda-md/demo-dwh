CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_product_categories()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_product_categories (product_categories_src_id, source_system, source_entity, product_category_title, ta_insert_dt)
        SELECT 'n. a.' AS product_categories_src_id,
                'sa_coffee_shop_sales' AS source_system,
                source_entity,
                product_category_title,
                CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT DISTINCT src.product_category AS product_category_title,
                    			'src_coffee_shop_card' AS source_entity	
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL 

            	SELECT DISTINCT src2.product_category AS product_category_title,
                    			'src_coffee_shop_cash' AS source_entity		
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
        	) AS tab
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_product_categories AS pc
                          WHERE UPPER(pc.product_category_title) = UPPER(tab.product_category_title) AND -- there is no product_category_id in the datasets
                                UPPER(pc.source_system) = UPPER('sa_coffee_shop_sales') AND
                                UPPER(pc.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_product_categories', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;	
    END;
END;
$$;