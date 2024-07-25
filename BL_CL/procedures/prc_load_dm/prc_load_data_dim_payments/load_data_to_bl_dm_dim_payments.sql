CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_payments()
AS $$
DECLARE
    counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_dm.bl_dm_dim_payments (payment_surr_id, payment_src_id, source_system, source_entity, 
                                          		payment_method, bank_id, bank_title, ta_insert_dt, ta_update_dt)
        SELECT nextval('bl_dm.bl_dm_seq_payment_surr_id'),
        		p.payment_src_id,
        		p.source_system,
        		p.source_entity,
        		p.payment_method,
        		COALESCE(b.bank_id, -1) AS bank_id,
        		COALESCE(b.bank_title, 'n. a.') AS bank_title,
               	p.ta_insert_dt,
               	p.ta_update_dt
        FROM bl_3nf.bl_3nf_ce_payments p
        LEFT JOIN bl_3nf.bl_3nf_ce_banks b ON b.bank_id = p.bank_id AND
        									  b.source_system = p.source_system AND 
        									  b.source_entity = p.source_entity
	    WHERE p.payment_src_id <> 'n. a.'
        ON CONFLICT (payment_src_id, source_system, source_entity, bank_id)
  		DO NOTHING;
        GET DIAGNOSTICS counter = ROW_COUNT;
        -- Commit transaction
--         COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_dim_payments', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
	            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;