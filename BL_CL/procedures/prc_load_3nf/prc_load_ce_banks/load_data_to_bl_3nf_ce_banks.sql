CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_banks()
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER;
BEGIN
    BEGIN
        INSERT INTO bl_3nf.bl_3nf_ce_banks (bank_src_id, source_system, source_entity, bank_title, ta_insert_dt)
        SELECT DISTINCT src.bank_id AS bank_src_id, 
                		'sa_coffee_shop_sales' AS source_system,
                		'src_coffee_shop_card' AS source_entity, -- the banks are only in one dataset
                		src.bank_title,
                		CURRENT_TIMESTAMP AS ta_insert_dt
        FROM sa_coffee_shop_card_sales.src_coffee_shop_card src
        WHERE NOT EXISTS (SELECT 1 
                          FROM bl_3nf.bl_3nf_ce_banks AS b
                          WHERE b.bank_src_id = src.bank_id AND
                                UPPER(b.source_system) = UPPER(source_system) AND
                                UPPER(b.source_entity) = UPPER(source_entity));

       GET DIAGNOSTICS counter = ROW_COUNT;
-- commit the transaction if successful
-- 		COMMIT; -- it doesn't work
		CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_banks', counter, CONCAT('Inserted rows ', CAST(counter AS VARCHAR)));  
    EXCEPTION
        WHEN others THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
    END;
END;
$$;