CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_banks (
bank_id BIGINT PRIMARY KEY,
bank_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
bank_title VARCHAR(100) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);