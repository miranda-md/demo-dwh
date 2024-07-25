CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_transactions()
AS $$
DECLARE
    counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_dm.bl_dm_dim_transactions (transaction_surr_id, transaction_src_id, source_system, source_entity, 
                                          transaction_date, transaction_time, ta_insert_dt, ta_update_dt)
        SELECT nextval('bl_dm.bl_dm_seq_transaction_surr_id'),
        		transaction_src_id,
        		source_system,
        		source_entity,
        		transaction_date,
        		transaction_time,
               	ta_insert_dt,
               	ta_update_dt
        FROM bl_3nf.bl_3nf_ce_transactions
        ON CONFLICT (transaction_src_id, source_system, source_entity)
  		DO NOTHING;
        GET DIAGNOSTICS counter = ROW_COUNT;
        -- Commit transaction
--         COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_dim_transactions', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
	            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;

    END;
END;
$$ LANGUAGE plpgsql;