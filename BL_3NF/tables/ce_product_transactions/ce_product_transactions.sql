CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_product_transactions (
product_id BIGINT NOT NULL,
transaction_id BIGINT NOT NULL,
employee_id BIGINT NOT NULL,
store_id BIGINT NOT NULL,
payment_id BIGINT NOT NULL,
customer_id BIGINT NOT NULL,
fct_quantity_sold_unit VARCHAR(10),
fct_discount_amount_unit VARCHAR(10),
fct_sales_unit VARCHAR(10),
fct_revenue_per_quantity_sold_unit VARCHAR(10),
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL,
CONSTRAINT fk_product_id FOREIGN KEY (product_id) 
REFERENCES bl_3nf.bl_3nf_ce_products_scd (product_id),
CONSTRAINT fk_transaction_id FOREIGN KEY (transaction_id) 
REFERENCES bl_3nf.bl_3nf_ce_transactions (transaction_id),
CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) 
REFERENCES bl_3nf.bl_3nf_ce_employees (employee_id),
CONSTRAINT fk_store_id FOREIGN KEY (store_id) 
REFERENCES bl_3nf.bl_3nf_ce_stores (store_id),
CONSTRAINT fk_payment_id FOREIGN KEY (payment_id) 
REFERENCES bl_3nf.bl_3nf_ce_payments (payment_id),
CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) 
REFERENCES bl_3nf.bl_3nf_ce_customers (customer_id)      
);