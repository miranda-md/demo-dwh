CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_stores (
store_surr_id BIGINT PRIMARY KEY,
store_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
store_description VARCHAR(250) NOT NULL,
store_city VARCHAR(100) NOT NULL,
address VARCHAR(150) NOT NULL,
store_manager_id VARCHAR(50) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);