CREATE TABLE IF NOT EXISTS bl_3nf.bl_3nf_ce_positions (
position_id BIGINT PRIMARY KEY,
position_src_id VARCHAR(50) NOT NULL,
source_system VARCHAR(50) NOT NULL,
source_entity VARCHAR(50) NOT NULL,
position_title VARCHAR(100) NOT NULL,
ta_insert_dt TIMESTAMP NOT NULL,
ta_update_dt TIMESTAMP NOT NULL
);