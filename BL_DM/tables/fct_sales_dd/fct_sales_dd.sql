CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_fct_sales_dd (
event_dt TIMESTAMP NOT NULL,
transaction_surr_id BIGINT NOT NULL,
product_surr_id BIGINT NOT NULL,
payment_surr_id BIGINT NOT NULL,
customer_surr_id BIGINT NOT NULL,
employee_surr_id BIGINT NOT NULL,
store_surr_id BIGINT NOT NULL,
-- date_surr_id BIGINT NOT NULL,
fct_quantity_sold_unit VARCHAR(10),
fct_discount_amount_unit VARCHAR(10),
fct_sales_unit VARCHAR(10),
fct_revenue_per_quantity_sold VARCHAR(10),
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL,
CONSTRAINT fk_transaction_surr_id FOREIGN KEY (transaction_surr_id) 
REFERENCES bl_dm.bl_dm_dim_transactions (transaction_surr_id),
CONSTRAINT fk_product_surr_id FOREIGN KEY (product_surr_id) 
REFERENCES bl_dm.bl_dm_dim_products_scd (product_surr_id),
CONSTRAINT fk_payment_surr_id FOREIGN KEY (payment_surr_id) 
REFERENCES bl_dm.bl_dm_dim_payments (payment_surr_id),
CONSTRAINT fk_customer_surr_id FOREIGN KEY (customer_surr_id) 
REFERENCES bl_dm.bl_dm_dim_customers (customer_surr_id),
CONSTRAINT fk_employee_surr_id FOREIGN KEY (employee_surr_id) 
REFERENCES bl_dm.bl_dm_dim_employees (employee_surr_id),
CONSTRAINT fk_store_surr_id FOREIGN KEY (store_surr_id) 
REFERENCES bl_dm.bl_dm_dim_stores (store_surr_id),
-- CONSTRAINT fk_date_surr_id FOREIGN KEY (date_surr_id) 
-- REFERENCES bl_dm.bl_dm_dim_dates (date_surr_id)
) PARTITION BY RANGE (event_dt);