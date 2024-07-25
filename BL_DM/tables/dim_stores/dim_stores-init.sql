ALTER TABLE bl_dm.bl_dm_dim_stores
ALTER COLUMN store_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_store_surr_id'),
ALTER COLUMN store_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN store_description SET DEFAULT 'n. a.',
ALTER COLUMN store_city SET DEFAULT 'n. a.',
ALTER COLUMN address SET DEFAULT 'n. a.',
ALTER COLUMN store_manager_id SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_stores (store_surr_id, store_src_id, source_system, source_entity, store_description, store_city, address, store_manager_id, ta_insert_dt, ta_update_dt)
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;