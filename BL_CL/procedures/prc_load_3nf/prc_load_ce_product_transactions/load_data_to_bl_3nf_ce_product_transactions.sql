CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_3nf_ce_product_transactions()
AS $$
DECLARE
    counter INTEGER;
BEGIN
        WITH sales_data AS ( -- data from sources
            SELECT	bank_id,
					bank_title,
					'src_coffee_shop_card' AS source_entity,
					'sa_coffee_shop_sales' AS source_system,
					transaction_id,
					transaction_date,
					transaction_time,
					quantity_sold,
					discount_amount,
					sales,
					payment_id,
					payment_method,
					product_price,
					product_size,
					product_id,
					product_title,
					product_category,
					product_description,
					store_id,
					store_description,
					store_city,
					store_address,
					store_manager_id,
					store_manager_first_name,
					store_manager_last_name,
					store_manager_passport_id,
					store_manager_city,
					store_manager_address,
					store_manager_phone_number,
					employee_id,
					employee_first_name,
					employee_last_name,
					employee_passport_id,
					employee_position,
					employee_city,
					employee_address,
					employee_phone_number,
					COALESCE(customer_id, 'n. a.') AS customer_id,
					COALESCE(customer_first_name, 'n. a.') AS customer_first_name,
					COALESCE(customer_last_name, 'n. a.') AS customer_last_name,
					COALESCE(customer_email, 'n. a.') AS customer_email,
					COALESCE(customer_phone_number, 'n. a.') AS customer_phone_number
    		FROM sa_coffee_shop_card_sales.src_coffee_shop_card

			UNION ALL
	
			SELECT  'n. a.' AS bank_id,
					'n. a.' AS bank_title,
		           	'src_coffee_shop_cash' AS source_entity,
		           	'sa_coffee_shop_sales' AS source_system,
		          	transaction_id,
					transaction_date,
					transaction_time,
					quantity_sold,
					discount_amount,
					sales,
					payment_id,
					payment_method,
					product_price,
					product_size,
					product_id,
					product_title,
					product_category,
					product_description,
					store_id,
					store_description,
					store_city,
					store_address,
					store_manager_id,
					store_manager_first_name,
					store_manager_last_name,
					store_manager_passport_id,
					store_manager_city,
					store_manager_address,
					store_manager_phone_number,
					employee_id,
					employee_first_name,
					employee_last_name,
					employee_passport_id,
					employee_position,
					employee_city,
					employee_address,
					employee_phone_number,
					COALESCE(customer_id, 'n. a.') AS customer_id,
					COALESCE(customer_first_name, 'n. a.') AS customer_first_name,
					COALESCE(customer_last_name, 'n. a.') AS customer_last_name,
					COALESCE(customer_email, 'n. a.') AS customer_email,
					COALESCE(customer_phone_number, 'n. a.') AS customer_phone_number
		    FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash), 
    
    	sales_with_customer AS ( -- data with customer, because purchase can be made by both registered and unregistered castomers in the system
						SELECT  pay.payment_id,
								p.product_id,
								p.product_price,
								tr.transaction_id,
								tr.transaction_date,
								e.employee_id,
								st.store_id,
								cust.customer_id,
								sd.sales,
								quantity_sold,
								discount_amount
						FROM sales_data sd
						LEFT JOIN bl_3nf.bl_3nf_ce_products_scd p ON p.product_src_id = sd.product_id AND
													   				 UPPER(p.source_system) = UPPER(sd.source_system) AND
													   				 UPPER(p.source_entity) = UPPER(sd.source_entity) AND
													   				 p.ta_is_active = true
						LEFT JOIN bl_3nf.bl_3nf_ce_transactions tr ON tr.transaction_src_id = sd.transaction_id AND
																	  UPPER(tr.source_system) = UPPER(sd.source_system) AND
																	  UPPER(tr.source_entity) = UPPER(sd.source_entity) 										  
						LEFT JOIN bl_3nf.bl_3nf_ce_employees e ON e.employee_src_id = sd.employee_id AND
																  UPPER(e.source_system) = UPPER(sd.source_system) AND
																  UPPER(e.source_entity) = UPPER(sd.source_entity)
						LEFT JOIN bl_3nf.bl_3nf_ce_stores st ON st.store_src_id = sd.store_id AND
																UPPER(st.source_system) = UPPER(sd.source_system) AND
																UPPER(st.source_entity) = UPPER(sd.source_entity)
						LEFT JOIN (SELECT in_b.bank_id,
										   in_pay.payment_src_id,
										   in_pay.payment_id,
										   COALESCE(in_b.bank_src_id, 'n. a.') AS bank_src_id
									FROM bl_3nf.bl_3nf_ce_payments in_pay 
									LEFT JOIN bl_3nf.bl_3nf_ce_banks in_b ON in_pay.bank_id = in_b.bank_id) pay
						ON pay.payment_src_id = sd.payment_id AND
						   UPPER(pay.bank_src_id) = UPPER(sd.bank_id)
						JOIN bl_3nf.bl_3nf_ce_customers cust ON cust.customer_src_id = sd.customer_id AND
																UPPER(cust.source_system) = UPPER(sd.source_system) AND
																UPPER(cust.source_entity) = UPPER(sd.source_entity)),
															
		sales_without_customer AS ( -- data without customer, because purchase can be made by both registered and unregistered castomers in the system

						SELECT	pay.payment_id,
								p.product_id,
								p.product_price,
								tr.transaction_id,
								tr.transaction_date,
								e.employee_id,
								st.store_id,
								-1 as customer_id,
								sd.sales,
								quantity_sold,
								discount_amount
						FROM sales_data sd
						LEFT JOIN bl_3nf.bl_3nf_ce_products_scd p ON p.product_src_id = sd.product_id AND
																	 UPPER(p.source_system) = UPPER(sd.source_system) AND
																	 UPPER(p.source_entity) = UPPER(sd.source_entity) AND
																	 p.ta_is_active = true
						LEFT JOIN bl_3nf.bl_3nf_ce_transactions tr ON tr.transaction_src_id = sd.transaction_id AND
																	  UPPER(tr.source_system) = UPPER(sd.source_system) AND
																	  UPPER(tr.source_entity) = UPPER(sd.source_entity)
						LEFT JOIN bl_3nf.bl_3nf_ce_employees e ON e.employee_passport_id = sd.employee_passport_id AND
																  UPPER(e.source_system) = UPPER(sd.source_system) AND
																  UPPER(e.source_entity) = UPPER(sd.source_entity)										  
						LEFT JOIN bl_3nf.bl_3nf_ce_stores st ON UPPER(st.store_description) = UPPER(sd.store_description) AND
																UPPER(st.source_system) = UPPER(sd.source_system) AND
																UPPER(st.source_entity) = UPPER(sd.source_entity)
						LEFT JOIN (SELECT in_b.bank_id,
										   in_pay.payment_src_id,
										   in_pay.payment_id,
										   COALESCE(in_b.bank_src_id, 'n. a.') AS bank_src_id
									FROM bl_3nf.bl_3nf_ce_payments in_pay 
									LEFT JOIN bl_3nf.bl_3nf_ce_banks in_b ON in_pay.bank_id = in_b.bank_id) pay
						ON pay.payment_src_id = sd.payment_id AND
						UPPER(pay.bank_src_id) = UPPER(sd.bank_id)
						WHERE sd.customer_id = 'n. a.')
	
INSERT INTO bl_3nf.bl_3nf_ce_product_transactions (
            product_id, 
            transaction_id, 
            employee_id, 
            store_id, 
            payment_id, 
            customer_id, 
            fct_quantity_sold_unit, 
            fct_discount_amount_unit, 
            fct_sales_unit, 
            fct_revenue_per_quantity_sold_unit, 
            ta_insert_dt, 
            ta_update_dt)
            
SELECT	product_id,
		transaction_id,
		employee_id,
		store_id, 
		payment_id,
		customer_id, 
		quantity_sold AS fct_quantity_sold_unit, 
		discount_amount AS fct_discount_amount_unit, 
		sales AS fct_sales_unit,
		fct_revenue_per_quantity_sold_unit, 
		ta_insert_dt,
		ta_update_dt 
FROM (SELECT product_id,
			 transaction_id,
			 transaction_date,
			 customer_id,
			 employee_id,
			 store_id,
			 payment_id,
			 sales,
			 quantity_sold,
			 discount_amount,
			 ROUND(CAST(sales AS NUMERIC) / CAST(quantity_sold AS INT), 2) AS fct_revenue_per_quantity_sold_unit,
			 CURRENT_TIMESTAMP AS ta_insert_dt,
			 CURRENT_TIMESTAMP AS ta_update_dt 
	  FROM sales_with_customer tab1
	
	  UNION ALL
	
	  SELECT product_id,
			 transaction_id,
			 transaction_date,
			 customer_id,
			 employee_id,
			 store_id,
			 payment_id,
			 sales,
			 quantity_sold,
			 discount_amount,
			 ROUND(CAST(sales AS NUMERIC) / CAST(quantity_sold AS INT), 2) AS fct_revenue_per_quantity_sold_unit,
			 CURRENT_TIMESTAMP AS ta_insert_dt,
			 CURRENT_TIMESTAMP AS ta_update_dt
	  FROM sales_without_customer tab2
	) AS tab
	ON CONFLICT (product_id, transaction_id) DO NOTHING;
        GET DIAGNOSTICS counter = ROW_COUNT;
        -- Commit transaction
		-- COMMIT;
        CALL bl_cl.insert_data_load_log('load_data_to_bl_3nf_ce_product_transactions', counter, 
                                  CONCAT('Inserted/Updated rows: ', CAST(counter AS VARCHAR)));
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
END;
$$ LANGUAGE plpgsql;