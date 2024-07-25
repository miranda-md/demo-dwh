CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_customers (
customer_id BIGINT PRIMARY KEY,
customer_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
customer_first_name VARCHAR(100) NOT NULL,
customer_last_name VARCHAR(100) NOT NULL,
customer_email VARCHAR(100) NOT NULL,
customer_phone_number VARCHAR(50) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);