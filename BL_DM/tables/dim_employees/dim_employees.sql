CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_employees (
employee_surr_id BIGINT PRIMARY KEY,
employee_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
employee_first_name VARCHAR(100) NOT NULL,
employee_last_name VARCHAR(100) NOT NULL,
employee_passport_id VARCHAR(100) NOT NULL,
employee_phone_number VARCHAR(50) NOT NULL,
employee_position_id VARCHAR(50) NOT NULL,
position_title VARCHAR(100) NOT NULL,
store_id VARCHAR(50) NOT NULL,
store_description VARCHAR(250) NOT NULL,
store_city VARCHAR(100) NOT NULL,
address VARCHAR(150) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);