CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_employees()
AS $$
DECLARE
    counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_dm.bl_dm_dim_employees (employee_surr_id, employee_src_id, source_system, source_entity, 
                                          		employee_first_name, employee_last_name, employee_passport_id, 
                                          		employee_phone_number, employee_position_id, position_title, store_id, 
                                          		store_description, store_city, address, ta_insert_dt, ta_update_dt)
        SELECT nextval('bl_dm.bl_dm_seq_employee_surr_id'),
        		e.employee_src_id,
        		e.source_system,
        		e.source_entity,
        		e.employee_first_name,
        		e.employee_last_name,
        		e.employee_passport_id,
        		e.employee_phone_number, 
               	e.employee_position_id,
               	p.position_title,
               	s.store_id,
               	s.store_description,
               	s.city_id,
               	s.address,
               	e.ta_insert_dt,
               	e.ta_update_dt
        FROM bl_3nf.bl_3nf_ce_employees e
        LEFT JOIN bl_3nf.bl_3nf_ce_positions p ON p.position_id = e.employee_position_id AND
        										  p.source_system = e.source_system AND 
        										  p.source_entity = e.source_entity
        LEFT JOIN bl_3nf.bl_3nf_ce_stores s ON s.store_id = e.store_id AND
        									   s.source_system = e.source_system AND 
        									   s.source_entity = e.source_entity
        ON CONFLICT (employee_src_id, source_system, source_entity)
  		DO NOTHING;
        GET DIAGNOSTICS counter = ROW_COUNT;
        -- Commit transaction
--         COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_dim_employees', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
	            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;