CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_stores()
AS $$
DECLARE
    counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_dm.bl_dm_dim_stores (store_surr_id, store_src_id, source_system, source_entity, 
                                          store_description, store_city, address, store_manager_id, ta_insert_dt, ta_update_dt)
        SELECT nextval('bl_dm.bl_dm_seq_store_surr_id'),
        		s.store_src_id,
        		s.source_system,
        		s.source_entity,
        		s.store_description,
        		c.city_title,
        		s.address,
        		s.store_manager_id,
               	s.ta_insert_dt,
               	s.ta_update_dt
        FROM bl_3nf.bl_3nf_ce_stores s
        LEFT JOIN bl_3nf.bl_3nf_ce_cities c ON c.city_id = s.city_id AND
        										  c.source_system = s.source_system AND 
        										  c.source_entity = s.source_entity
        ON CONFLICT (store_src_id, source_system, source_entity)
  		DO NOTHING;
        GET DIAGNOSTICS counter = ROW_COUNT;
        -- Commit transaction
--         COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_dim_stores', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
	            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;