CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_positions()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        -- insert new position Manager if it doesn't exist (store manager)
        INSERT INTO bl_3nf.bl_3nf_ce_positions (position_src_id, source_system, source_entity, position_title, ta_insert_dt)
        SELECT 'n. a.' AS position_src_id,
               'sa_coffee_shop_sales' AS source_system,
               'src_coffee_shop_card' AS source_entity,
               'Manager' AS position_title,
               CURRENT_TIMESTAMP AS ta_insert_dt
        WHERE NOT EXISTS (SELECT 1 
            			  FROM bl_3nf.bl_3nf_ce_positions AS p
            			  WHERE UPPER(p.position_title) = UPPER('Manager') AND
                  				UPPER(p.source_system) = UPPER('sa_coffee_shop_sales') AND
                  				UPPER(p.source_entity) = UPPER('src_coffee_shop_card')
        					);

        INSERT INTO bl_3nf.bl_3nf_ce_positions (position_src_id, source_system, source_entity, position_title, ta_insert_dt)
        SELECT 'n. a.' AS position_src_id,
               'sa_coffee_shop_sales' AS source_system,
               'src_coffee_shop_cash' AS source_entity,
               'Manager' AS position_title,
               CURRENT_TIMESTAMP AS ta_insert_dt
        WHERE NOT EXISTS (SELECT 1 
            			  FROM bl_3nf.bl_3nf_ce_positions AS p
            			  WHERE UPPER(p.position_title) = UPPER('Manager') AND
                  				UPPER(p.source_system) = UPPER('sa_coffee_shop_sales') AND
                  				UPPER(p.source_entity) = UPPER('src_coffee_shop_cash')
        					);
        -- insert positions from source data
        INSERT INTO bl_3nf.bl_3nf_ce_positions (position_src_id, source_system, source_entity, position_title, ta_insert_dt)
        SELECT 'n. a.' AS position_src_id,
                'sa_coffee_shop_sales' AS source_system,
                source_entity,
                position_title,
                CURRENT_TIMESTAMP AS ta_insert_dt
        FROM (
            	SELECT DISTINCT src.employee_position AS position_title,
                    			'src_coffee_shop_card' AS source_entity
            	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

            	UNION ALL

            	SELECT DISTINCT src2.employee_position AS position_title,
                    			'src_coffee_shop_cash' AS source_entity
            	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
			) AS tab
        WHERE NOT EXISTS (SELECT 1
                          FROM bl_3nf.bl_3nf_ce_positions AS p
                          WHERE UPPER(p.position_title) = UPPER(tab.position_title) AND -- there is no position_id in the datasets
                                UPPER(p.source_system) = UPPER(source_system) AND
                                UPPER(p.source_entity) = UPPER(tab.source_entity));
        GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_positions', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;	
    END;
END;
$$;