CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_payments (
payment_surr_id BIGINT PRIMARY KEY,
payment_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
payment_method VARCHAR(100) NOT NULL,
bank_id VARCHAR(50) NOT NULL,
bank_title VARCHAR(100) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);