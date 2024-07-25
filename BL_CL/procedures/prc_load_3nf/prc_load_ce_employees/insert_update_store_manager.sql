CREATE OR REPLACE PROCEDURE bl_cl.insert_update_store_manager() -- inserts new store managers into employees table and updates their store_manager_id in stores table
LANGUAGE plpgsql
AS $$
DECLARE
    counter_insert INTEGER := 0;
    counter_update INTEGER := 0;
BEGIN
    BEGIN
        -- insert store manager
        INSERT INTO bl_3nf.bl_3nf_ce_employees (employee_src_id, source_system, source_entity, employee_first_name, employee_last_name, employee_passport_id, employee_phone_number, employee_position_id, store_id, city_id, ta_insert_dt)
        SELECT DISTINCT tab.store_manager_id AS employee_src_id,
                        tab.source_system,
                        tab.source_entity,
                        COALESCE(store_manager_first_name, 'n. a.'), 
                        COALESCE(store_manager_last_name, 'n. a.'), 
                        COALESCE(store_manager_passport_id, 'n. a.'), 
                        COALESCE(store_manager_phone_number, 'n. a.'),
                        COALESCE(p.position_id, -1),
                        s.store_id AS store_id,
                        c.city_id AS city_id,
                        CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT store_manager_id,
            		   store_manager_first_name, 
                   	   store_manager_last_name, 
                       store_manager_passport_id,
                       store_manager_phone_number,
                       'Manager' AS store_manager_position,
                       'src_coffee_shop_cash' AS source_entity,
                       store_description,
                       store_manager_city,
                       'sa_coffee_shop_sales' AS source_system,
                       employee_position,
                       store_id,
                       employee_city
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL

            	SELECT store_manager_id, 
                   	   store_manager_first_name,
                       store_manager_last_name,
                       store_manager_passport_id,
                       store_manager_phone_number,
                       'Manager' AS store_manager_position,
                       'src_coffee_shop_card' AS source_entity,
                       store_description,
                       store_manager_city,
                       'sa_coffee_shop_sales' AS source_system,
                       employee_position,
                       store_id,
                       employee_city
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
        	) AS tab
        LEFT JOIN bl_3nf.bl_3nf_ce_positions p ON UPPER(p.position_title) = UPPER(tab.store_manager_position) AND -- there's no position_id in datasets
                                                  UPPER(p.source_system) = UPPER(tab.source_system) AND
                                                  UPPER(p.source_entity) = UPPER(tab.source_entity)
        LEFT JOIN bl_3nf.bl_3nf_ce_stores s ON s.store_src_id = tab.store_id AND
                                               UPPER(s.source_system) = UPPER(tab.source_system) AND
                                               UPPER(s.source_entity) = UPPER(tab.source_entity)
        LEFT JOIN bl_3nf.bl_3nf_ce_cities c ON UPPER(c.city_title) = UPPER(tab.employee_city) AND -- there's no city_id in datasets
                                               UPPER(c.source_system) = UPPER(tab.source_system) AND
                                               UPPER(c.source_entity) = UPPER(tab.source_entity)
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_employees AS e
                          WHERE e.employee_src_id = tab.store_manager_id AND
                                UPPER(e.source_system) = UPPER(tab.source_system) AND
                                UPPER(e.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter_insert = ROW_COUNT;
        CALL bl_cl.insert_data_load_log('insert_update_store_manager', counter_insert, CONCAT('Inserted rows ', CAST(counter_insert AS VARCHAR)));
        -- update store_manager_id for the corresponding employees
        UPDATE bl_3nf.bl_3nf_ce_stores
        SET store_manager_id = subquery.employee_id
        FROM (
            	SELECT e.employee_id, tab.store_manager_id, tab.source_entity, s.store_id
           		FROM (
                		SELECT store_manager_id,
                       		   store_id,
                       		   'src_coffee_shop_card' AS source_entity,
                       		   'sa_coffee_shop_sales' AS source_system
                		FROM sa_coffee_shop_card_sales.src_coffee_shop_card src
        
                		UNION ALL
                
                		SELECT store_manager_id,
                       		   store_id,
                       		   'src_coffee_shop_cash' AS source_entity,
                       		   'sa_coffee_shop_sales' AS source_system     
                		FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
            		) AS tab
          		LEFT JOIN bl_3nf.bl_3nf_ce_employees e ON e.employee_src_id = tab.store_manager_id AND
                                                      	  UPPER(e.source_system) = UPPER(tab.source_system) AND
                                                      	  UPPER(e.source_entity) = UPPER(tab.source_entity)
                                                      
            	LEFT JOIN bl_3nf.bl_3nf_ce_stores s ON s.store_src_id = tab.store_id AND
                                                   	   UPPER(s.source_system) = UPPER(tab.source_system) AND
                                                   	   UPPER(s.source_entity) = UPPER(tab.source_entity)
        	) AS subquery
        WHERE bl_3nf.bl_3nf_ce_stores.store_id = subquery.store_id;
        GET DIAGNOSTICS counter_update = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
        CALL bl_cl.insert_data_load_log('insert_update_store_manager', counter_update, CONCAT('Updated rows ', CAST(counter_update AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$;
