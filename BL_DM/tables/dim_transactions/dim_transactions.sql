CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_transactions (
transaction_surr_id BIGINT PRIMARY KEY,
transaction_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
transaction_date DATE NOT NULL,
transaction_time TIME NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);