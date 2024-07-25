CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_cities (
city_id BIGINT PRIMARY KEY,
city_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
city_title VARCHAR(100) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);