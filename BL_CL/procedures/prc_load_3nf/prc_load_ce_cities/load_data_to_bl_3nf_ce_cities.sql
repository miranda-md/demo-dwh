CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_cities()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_cities (city_src_id, source_system, source_entity, city_title, ta_insert_dt)
        SELECT 'n. a.' AS city_src_id,
                'sa_coffee_shop_sales' AS source_system,
                source_entity,
                city_title,
                CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT DISTINCT city_title, source_entity
 				-- getting unique city_title from three columns
            	FROM (
                		SELECT src1.store_city AS city_title,
                			   'src_coffee_shop_card' AS source_entity
                		FROM sa_coffee_shop_card_sales.src_coffee_shop_card src1

                		UNION ALL

                		SELECT src2.employee_city AS city_title,
                       		   'src_coffee_shop_card' AS source_entity
                		FROM sa_coffee_shop_card_sales.src_coffee_shop_card src2

                		UNION ALL

                		SELECT src3.store_manager_city AS city_title,
                       		   'src_coffee_shop_card' AS source_entity
                		FROM sa_coffee_shop_card_sales.src_coffee_shop_card src3

                		UNION ALL

                		SELECT src4.store_city AS city_title,
                       		   'src_coffee_shop_cash' AS source_entity
                		FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src4

                		UNION ALL

                		SELECT src5.employee_city AS city_title,
                       		   'src_coffee_shop_cash' AS source_entity
                		FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src5

                		UNION ALL

                		SELECT src6.store_manager_city AS city_title,
                       		  'src_coffee_shop_cash' AS source_entity
                		FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src6
            		) as u_cities
        	) AS tab
        WHERE NOT EXISTS (
            				SELECT 1 
            				FROM bl_3nf.bl_3nf_ce_cities AS c
            				WHERE UPPER(c.city_title) = UPPER(tab.city_title) AND -- there's no city_id column in the datasets
            					  UPPER(c.source_system) = UPPER(source_system) AND
            					  UPPER(c.source_entity) = UPPER(tab.source_entity)
        				);
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work    
        CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_cities', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$;