MERGE INTO sa_coffee_shop_card_sales.src_coffee_shop_card src
	
USING sa_coffee_shop_card_sales.ext_coffee_shop_card ext
ON ext.transaction_id = src.transaction_id AND ext.product_id = src.product_id

WHEN NOT MATCHED THEN
	INSERT VALUES(  transaction_id,
					transaction_date,
					transaction_time,
					quantity_sold,
					discount_amount,
					sales,
					payment_id,
					payment_method,
					bank_id,
					bank_title,
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
					customer_id,
					customer_first_name,
					customer_last_name,
					customer_email,
					customer_phone_namber)
WHEN MATCHED THEN
    UPDATE 
	SET	    product_price = ext.product_price,
			product_size = ext.product_size,
			product_title = ext.product_title,
			product_category = ext.product_category,
			product_description = ext.product_description;


MERGE INTO sa_coffee_shop_cash_sales.src_coffee_shop_cash src
	
USING sa_coffee_shop_cash_sales.ext_coffee_shop_cash ext
ON ext.transaction_id = src.transaction_id AND ext.product_id = src.product_id

WHEN NOT MATCHED THEN
	INSERT VALUES(  transaction_id,
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
					customer_id,
					customer_first_name,
					customer_last_name,
					customer_email,
					customer_phone_namber)
WHEN MATCHED THEN
    UPDATE 
	SET	    product_price = ext.product_price,
			product_size = ext.product_size,
			product_title = ext.product_title,
			product_category = ext.product_category,
			product_description = ext.product_description;