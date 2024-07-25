CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_employees (
employee_id BIGINT PRIMARY KEY,
employee_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
employee_first_name VARCHAR(100) NOT NULL,
employee_last_name VARCHAR(100) NOT NULL,
employee_passport_id VARCHAR(100) NOT NULL,
employee_phone_number VARCHAR(50) NOT NULL,
employee_position_id BIGINT NOT NULL,
store_id BIGINT NOT NULL,
city_id BIGINT NOT NULL,
address VARCHAR(150) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL,
CONSTRAINT fk_employee_position_id FOREIGN KEY (employee_position_id) 
REFERENCES bl_3nf.bl_3nf_ce_positions (position_id),
CONSTRAINT fk_store_id FOREIGN KEY (store_id) 
REFERENCES bl_3nf.bl_3nf_ce_stores (store_id),
CONSTRAINT fk_city_id FOREIGN KEY (city_id) 
REFERENCES bl_3nf.bl_3nf_ce_cities (city_id)   
);