CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_payments (
payment_id BIGINT PRIMARY KEY,
payment_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
payment_method VARCHAR(100) NOT NULL,
bank_id BIGINT NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL,
CONSTRAINT fk_bank_id FOREIGN KEY (bank_id) 
REFERENCES bl_3nf.bl_3nf_ce_banks (bank_id)
);