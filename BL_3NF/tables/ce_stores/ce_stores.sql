CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_stores (
store_id BIGINT PRIMARY KEY,
store_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
store_description VARCHAR(250) NOT NULL,
city_id BIGINT NOT NULL,
address VARCHAR(150) NOT NULL,
store_manager_id BIGINT NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL,
CONSTRAINT fk_city_id FOREIGN KEY (city_id) 
REFERENCES bl_3nf.bl_3nf_ce_cities (city_id)
);