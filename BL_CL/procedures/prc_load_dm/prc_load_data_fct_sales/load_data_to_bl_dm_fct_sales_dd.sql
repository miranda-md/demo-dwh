CREATE OR REPLACE FUNCTION partitition_select(last_3nf_tr_date DATE)
  RETURNS TABLE (part_name text , part_start text, part_end text)
  LANGUAGE plpgsql AS
$$
BEGIN
   RETURN QUERY
   SELECT -- create partitions
		'bl_dm_fct_sales_dd_' || EXTRACT(YEAR FROM transaction_date)::TEXT ||
		CASE
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 1 AND 3 THEN 'm01_m03'
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 4 AND 6 THEN 'm04_m06'
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 7 AND 9 THEN 'm07_m09'
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 10 AND 12 THEN 'm10_m12'
		END as part_name,
		CASE
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 1 AND 3 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-01-01 00:00:00')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 4 AND 6 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-04-01 00:00:00')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 7 AND 9 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-07-01 00:00:00')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 10 AND 12 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-10-01 00:00:00')
		END as part_start,
		CASE
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 1 AND 3 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-03-31 23:59:59')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 4 AND 6 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-06-30 23:59:59')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 7 AND 9 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-09-30 23:59:59')
		    WHEN EXTRACT (MONTH FROM transaction_date) BETWEEN 10 AND 12 THEN CONCAT(EXTRACT(YEAR FROM transaction_date) || '-12-31 23:59:59')
		END as part_end
		FROM bl_3nf.bl_3nf_ce_transactions
		WHERE transaction_src_id <> 'n. a.' AND transaction_date >= last_3nf_tr_date -- exclude default row
		GROUP BY part_name, part_start, part_end;
END
$$;


CREATE OR REPLACE PROCEDURE bl_cl.create_partititions_for_bl_dm_fct_sales_dd()
AS $$
DECLARE
	partition_counter INT := 0;
	part_record record;
	last_transaction_date DATE;

BEGIN
	SELECT dm_trans.transaction_date FROM  bl_dm.bl_dm_fct_sales_dd s
		LEFT JOIN bl_dm.bl_dm_dim_transactions dm_trans ON dm_trans.transaction_surr_id = s.transaction_surr_id
	GROUP BY dm_trans.transaction_date
	ORDER BY dm_trans.transaction_date DESC
	LIMIT 1
	INTO last_transaction_date;

	FOR part_record IN SELECT * FROM partitition_select(COALESCE(last_transaction_date, '1990-01-01'::DATE))
	LOOP
    	IF NOT EXISTS(SELECT FROM pg_tables WHERE schemaname = 'bl_dm' AND tablename = part_record.part_name) THEN
    		partition_counter := partition_counter + 1;
    	END IF;
		EXECUTE FORMAT('CREATE TABLE IF NOT EXISTS bl_dm.%I PARTITION OF bl_dm.bl_dm_fct_sales_dd FOR VALUES FROM (%L) TO (%L)', part_record.part_name, part_record.part_start, part_record.part_end);
    END LOOP;

    CALL bl_cl.insert_data_load_log('create_partition_to_bl_dm_fct_sales_dd', partition_counter, 
                                  CONCAT('Created: ', CAST(partition_counter AS VARCHAR)));
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_fct_sales_dd()
AS $$
DECLARE
    counter INTEGER;
	part_record record;
	last_transaction_date DATE;

BEGIN
	SELECT dm_trans.transaction_date FROM  bl_dm.bl_dm_fct_sales_dd s
		LEFT JOIN bl_dm.bl_dm_dim_transactions dm_trans ON dm_trans.transaction_surr_id = s.transaction_surr_id
	GROUP BY dm_trans.transaction_date
	ORDER BY dm_trans.transaction_date DESC
	LIMIT 1
	INTO last_transaction_date;

-- 	CALL bl_cl.create_partititions_for_bl_dm_fct_sales_dd();
		-- Insert data
        INSERT INTO bl_dm.bl_dm_fct_sales_dd ( 
            event_dt, 
            transaction_surr_id,
            product_surr_id, 
            payment_surr_id, 
            customer_surr_id,
            employee_surr_id, 
            store_surr_id,
            date_surr_id,
            fct_quantity_sold_unit, 
            fct_discount_amount_unit, 
            fct_sales_unit, 
            fct_revenue_per_quantity_sold, 
            ta_insert_dt,
            ta_update_dt
        )
       SELECT	
       			dm_trans.transaction_date AS event_dt,
       			dm_trans.transaction_surr_id, 
	            dm_prod.product_surr_id,
	            dm_pay.payment_surr_id,
	            dm_cust.customer_surr_id,
	            dm_emp.employee_surr_id,
	            dm_stor.store_surr_id,
	            (SELECT dm_dt.date_surr_id 
 					FROM bl_dm.bl_dm_dim_dates dm_dt 
 					WHERE dm_dt.full_date = dm_trans.transaction_date),
	            pt.fct_quantity_sold_unit, 
	            pt.fct_discount_amount_unit, 
	            pt.fct_sales_unit, 
	            pt.fct_revenue_per_quantity_sold_unit, 
	            pt.ta_insert_dt,
	            CURRENT_TIMESTAMP AS ta_update_dt
        FROM bl_3nf.bl_3nf_ce_product_transactions pt
        
        LEFT JOIN bl_3nf.bl_3nf_ce_transactions trans ON trans.transaction_id = pt.transaction_id
        
        LEFT JOIN bl_dm.bl_dm_dim_transactions dm_trans ON dm_trans.transaction_src_id = trans.transaction_src_id AND
										   				 UPPER(dm_trans.source_system) = UPPER(trans.source_system) AND
										   				 UPPER(dm_trans.source_entity) = UPPER(trans.source_entity)
        
        LEFT JOIN bl_3nf.bl_3nf_ce_products_scd prod ON prod.product_id = pt.product_id
        
        LEFT JOIN bl_dm.bl_dm_dim_products_scd dm_prod ON dm_prod.product_src_id = prod.product_src_id AND
										   				 UPPER(dm_prod.source_system) = UPPER(prod.source_system) AND
										   				 UPPER(dm_prod.source_entity) = UPPER(prod.source_entity) AND
										   				 dm_prod.ta_is_active = true

        LEFT JOIN bl_3nf.bl_3nf_ce_payments pay ON pay.payment_id = pt.payment_id
        
        LEFT JOIN bl_dm.bl_dm_dim_payments dm_pay ON dm_pay.payment_src_id = pay.payment_src_id AND
										   				 UPPER(dm_pay.source_system) = UPPER(pay.source_system) AND
										   				 UPPER(dm_pay.source_entity) = UPPER(pay.source_entity) AND
										   				 dm_pay.bank_id = CAST(pay.bank_id AS VARCHAR)
                                                     
        LEFT JOIN bl_3nf.bl_3nf_ce_customers cust ON cust.customer_id = pt.customer_id
        
        LEFT JOIN bl_dm.bl_dm_dim_customers dm_cust ON dm_cust.customer_src_id = cust.customer_src_id AND
										   				 UPPER(dm_cust.source_system) = UPPER(cust.source_system) AND
										   				 UPPER(dm_cust.source_entity) = UPPER(cust.source_entity)
                                                     
        LEFT JOIN bl_3nf.bl_3nf_ce_employees emp ON emp.employee_id = pt.employee_id
        
        LEFT JOIN bl_dm.bl_dm_dim_employees dm_emp ON dm_emp.employee_src_id = emp.employee_src_id AND
										   				 UPPER(dm_emp.source_system) = UPPER(emp.source_system) AND
										   				 UPPER(dm_emp.source_entity) = UPPER(emp.source_entity)
                                                     
        LEFT JOIN bl_3nf.bl_3nf_ce_stores stor ON stor.store_id = pt.store_id
        
        LEFT JOIN bl_dm.bl_dm_dim_stores dm_stor ON dm_stor.store_src_id = stor.store_src_id AND
										   				 UPPER(dm_stor.source_system) = UPPER(stor.source_system) AND
										   				 UPPER(dm_stor.source_entity) = UPPER(stor.source_entity)
		

	WHERE trans.transaction_date >= COALESCE(last_transaction_date, '1990-01-01'::DATE)
	ON CONFLICT (product_surr_id, transaction_surr_id, event_dt) DO NOTHING;
    GET DIAGNOSTICS counter = ROW_COUNT;
    -- Commit transaction
	-- COMMIT;
    CALL bl_cl.insert_data_load_log('load_data_to_bl_dm_fct_sales_dd', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));

	
-- 	FOR part_record IN SELECT * FROM partitition_select(COALESCE(last_transaction_date, '1990-01-01'::DATE))
-- 	LOOP
-- 		EXECUTE FORMAT('ALTER TABLE bl_dm.bl_dm_fct_sales_dd DETACH PARTITION bl_dm.%I', part_record.part_name);
--     END LOOP;
-- 	IF part_record IS NOT NULL THEN
-- 		EXECUTE FORMAT('ALTER TABLE bl_dm.bl_dm_fct_sales_dd ATTACH PARTITION bl_dm.%I FOR VALUES FROM (%L) TO (%L)', part_record.part_name, part_record.part_start, part_record.part_end);
-- 	END IF;
	
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- CALL bl_cl.load_data_to_bl_dm_fct_sales_dd();