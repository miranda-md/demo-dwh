CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_product_transactions 
ON bl_3nf.bl_3nf_ce_product_transactions (product_id, transaction_id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_customers
ON bl_dm.bl_dm_dim_customers (customer_src_id, source_system, source_entity);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_employees
ON bl_dm.bl_dm_dim_employees (employee_src_id, source_system, source_entity);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_payments 
ON bl_dm.bl_dm_dim_payments (payment_src_id, source_system, source_entity, bank_id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_stores
ON bl_dm.bl_dm_dim_stores (store_src_id, source_system, source_entity);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_transactions 
ON bl_dm.bl_dm_dim_transactions (transaction_src_id, source_system, source_entity);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_product_transactions_dm 
ON bl_dm.bl_dm_fct_sales_dd (product_surr_id, transaction_surr_id, event_dt);

-- CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_dates 
-- ON bl_dm.bl_dm_dim_dates (date_surr_id);