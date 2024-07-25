CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_products_scd (
product_surr_id BIGINT PRIMARY KEY,
product_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
product_title VARCHAR(100) NOT NULL,
product_category VARCHAR(100) NOT NULL,
product_description VARCHAR(250) NOT NULL,
product_price VARCHAR(10) NOT NULL,
product_size VARCHAR(50) NOT NULL,
ta_start_dt TIMESTAMP NOT NULL,
ta_end_dt TIMESTAMP NOT NULL,
ta_is_active BOOLEAN NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL
);