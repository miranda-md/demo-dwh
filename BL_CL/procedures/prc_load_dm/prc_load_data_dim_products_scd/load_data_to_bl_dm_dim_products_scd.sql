CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_products_scd()
AS $$
DECLARE
    counter INTEGER := 0;
	updated BOOLEAN;
	product_cursor CURSOR
    	FOR SELECT p.product_src_id,
        			p.source_system,
        			p.source_entity,
        			p.product_title,
        			pc.product_category_title as product_category,
        			p.product_description,
        			p.product_price,
        			p.product_size,
        			p.ta_is_active
        	FROM bl_3nf.bl_3nf_ce_products_scd p
        	LEFT JOIN bl_3nf.bl_3nf_ce_product_categories pc ON pc.product_category_id = p.product_category_id AND
	        										  			pc.source_system = p.source_system AND 
	        										  			pc.source_entity = p.source_entity
  			WHERE p.ta_is_active = true;
	product_record RECORD;
	temp_record RECORD;
BEGIN
    BEGIN
		OPEN product_cursor;

        LOOP
	        FETCH NEXT FROM product_cursor INTO product_record;
	        EXIT WHEN NOT FOUND;
	
			SELECT * FROM bl_dm.bl_dm_dim_products_scd
			WHERE ta_is_active = true 
				AND product_src_id = product_record.product_src_id
				AND source_system = product_record.source_system
				AND source_entity = product_record.source_entity
			LIMIT 1
			INTO temp_record;

			IF temp_record IS NULL
			THEN 
				EXECUTE format('INSERT INTO bl_dm.bl_dm_dim_products_scd (product_surr_id, product_src_id, source_system, source_entity, product_title, product_category, product_description, product_price, product_size, ta_insert_dt) VALUES(nextval(''bl_dm.bl_dm_seq_product_surr_id''), $1, $2, $3, $4, $5, $6, $7, $8, $9)')
				USING product_record.product_src_id,
					product_record.source_system,
					product_record.source_entity,
					product_record.product_title,
					product_record.product_category,
					product_record.product_description,
					product_record.product_price,
					product_record.product_size,
					CURRENT_TIMESTAMP;
				counter := counter + 1;
				CONTINUE;
			END IF;
			
			IF temp_record.product_title != product_record.product_title OR
				temp_record.product_category != product_record.product_category OR
				temp_record.product_description != product_record.product_description OR
				temp_record.product_price != product_record.product_price OR
				temp_record.product_size != product_record.product_size
			THEN
				UPDATE bl_dm.bl_dm_dim_products_scd 
				SET ta_end_dt = CURRENT_TIMESTAMP,
  					ta_is_active = false
				WHERE product_surr_id = temp_record.product_surr_id;

				EXECUTE format('INSERT INTO bl_dm.bl_dm_dim_products_scd (product_surr_id, product_src_id, source_system, source_entity, product_title, product_category, product_description, product_price, product_size, ta_start_dt, ta_insert_dt) VALUES(nextval(''bl_dm.bl_dm_seq_product_surr_id''), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10)')
				USING product_record.product_src_id,
					product_record.source_system,
					product_record.source_entity,
					product_record.product_title,
					product_record.product_category,
					product_record.product_description,
					product_record.product_price,
					product_record.product_size,
					CURRENT_TIMESTAMP,
					CURRENT_TIMESTAMP;
					counter := counter + 1;
			END IF;
	    END LOOP;

        -- Commit transaction
--         COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_dim_products_scd', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
	            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;

    END;
END;
$$ LANGUAGE plpgsql;