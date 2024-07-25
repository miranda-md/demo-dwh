CREATE OR REPLACE PROCEDURE bl_cl.load_all_data()
LANGUAGE plpgsql
AS $$
BEGIN
	-- 3nf load
    CALL bl_cl.load_data_to_bl_3nf_ce_banks();
	CALL bl_cl.load_data_to_bl_3nf_ce_cities();
	CALL bl_cl.load_data_to_bl_3nf_ce_customers();
	CALL bl_cl.load_data_to_bl_3nf_ce_payments();
	CALL bl_cl.load_data_to_bl_3nf_ce_positions();
	CALL bl_cl.load_data_to_bl_3nf_ce_product_categories();
	CALL bl_cl.load_data_to_bl_3nf_ce_stores();
	CALL bl_cl.load_data_to_bl_3nf_ce_employees();
	CALL bl_cl.insert_update_store_manager();
	CALL bl_cl.load_data_to_bl_3nf_ce_transactions();
	CALL bl_cl.load_data_to_bl_3nf_ce_products_scd();
	CALL bl_cl.load_data_to_bl_3nf_ce_product_transactions();
	-- dm load
	CALL bl_cl.load_data_to_bl_dm_dim_customers();
	CALL bl_cl.load_data_to_bl_dm_dim_employees();
	CALL bl_cl.load_data_to_bl_dm_dim_payments();
	CALL bl_cl.load_data_to_bl_dm_dim_stores();
	CALL bl_cl.load_data_to_bl_dm_dim_transactions();
	CALL bl_cl.load_data_to_bl_dm_dim_dates();
	CALL bl_cl.load_data_to_bl_dm_dim_products_scd();
	CALL bl_cl.load_data_to_bl_dm_fct_sales_dd();
	CALL bl_cl.create_partititions_for_bl_dm_fct_sales_dd();

-- 	COMMIT;

	RAISE NOTICE 'Data loaded successfully';
END;
$$;

CALL bl_cl.load_all_data();

SELECT * FROM bl_cl.data_load_logs;

SELECT * FROM bl_dm.bl_dm_dim_products_scd 
WHERE product_src_id = '42';

