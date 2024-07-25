ALTER TABLE bl_3nf.bl_3nf_ce_stores
ALTER COLUMN store_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_store_id'),
ALTER COLUMN store_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN store_description SET DEFAULT 'n. a.',
ALTER COLUMN city_id SET DEFAULT -1,
ALTER COLUMN address SET DEFAULT 'n. a.',
ALTER COLUMN store_manager_id SET DEFAULT -1,
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_stores (store_id, store_src_id, source_system, source_entity, store_description, city_id, address, store_manager_id, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, -1, DEFAULT, -1, DEFAULT, DEFAULT);
COMMIT;