CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_employees()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INTEGER := 0;
    employee_record RECORD;
BEGIN
    BEGIN
        -- LOOP through unique employee records from the two data sources
        FOR employee_record IN
            SELECT DISTINCT employee_id AS employee_src_id,
                            tab.source_system,
                            tab.source_entity,
                            COALESCE(employee_first_name, 'n. a.') AS employee_first_name,  
                            COALESCE(employee_last_name, 'n. a.') AS employee_last_name, 
                            COALESCE(employee_passport_id, 'n. a.') AS employee_passport_id,
                            COALESCE(employee_phone_number, 'n. a.') AS employee_phone_number,
                            COALESCE(p.position_id, -1) AS employee_position_id,
                            s.store_id,
                            c.city_id,
                            CURRENT_TIMESTAMP AS ta_insert_dt
            FROM (
                	SELECT employee_id, 
                           employee_first_name, 
                           employee_last_name, 
                           employee_passport_id,
                           employee_position,
                           employee_phone_number,
                           'src_coffee_shop_card' AS source_entity,
                           'sa_coffee_shop_sales' AS source_system,
                           store_description,
                           employee_city,
                           store_id
                	FROM sa_coffee_shop_card_sales.src_coffee_shop_card src

                	UNION ALL

                	SELECT employee_id, 
                           employee_first_name, 
                           employee_last_name, 
                           employee_passport_id,
                           employee_position,
                           employee_phone_number,
                           'src_coffee_shop_cash' AS source_entity,
                           'sa_coffee_shop_sales' AS source_system,
                           store_description,
                           employee_city,
                           store_id
                	FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash src2
            	) AS tab
            LEFT JOIN bl_3nf.bl_3nf_ce_positions p ON UPPER(p.position_title) = UPPER(tab.employee_position) AND
                                                      UPPER(p.source_system) = UPPER(tab.source_system) AND
                                                      UPPER(p.source_entity) = UPPER(tab.source_entity) 
            LEFT JOIN bl_3nf.bl_3nf_ce_stores s ON s.store_src_id = tab.store_id AND
                                                   UPPER(s.source_system) = UPPER(tab.source_system) AND
                                                   UPPER(s.source_entity) = UPPER(tab.source_entity)
            LEFT JOIN bl_3nf.bl_3nf_ce_cities c ON UPPER(c.city_title) = UPPER(tab.employee_city) AND
                                                   UPPER(c.source_system) = UPPER(tab.source_system) AND
                                                   UPPER(c.source_entity) = UPPER(tab.source_entity)
            WHERE NOT EXISTS (SELECT 1 
                              FROM bl_3nf.bl_3nf_ce_employees AS e
                              WHERE e.employee_src_id = tab.employee_id AND
                                    UPPER(e.source_system) = UPPER(tab.source_system) AND
                                    UPPER(e.source_entity) = UPPER(tab.source_entity))
			-- attempt to insert employee data (if record is unique, it is inserted into table and the counter is incremented)
            LOOP
                BEGIN
                    INSERT INTO bl_3nf.bl_3nf_ce_employees (employee_src_id, source_system, source_entity, employee_first_name, employee_last_name, employee_passport_id, employee_phone_number, employee_position_id, store_id, city_id, ta_insert_dt)
                    VALUES (employee_record.employee_src_id, employee_record.source_system, employee_record.source_entity, employee_record.employee_first_name, employee_record.employee_last_name, employee_record.employee_passport_id, employee_record.employee_phone_number, employee_record.employee_position_id, employee_record.store_id, employee_record.city_id, employee_record.ta_insert_dt);
                    
                    counter := counter + 1;

                	EXCEPTION WHEN unique_violation THEN -- if a uniqueness error (unique_violation) occurs, the insertion operation is not performed and the loop moves on to the next record
                    CONTINUE;
                END;
            END LOOP;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
        CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_employees', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;   
    END;
END;
$$;
