ALTER TABLE bl_dm.bl_dm_dim_products_scd
ALTER COLUMN product_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_product_surr_id'),
ALTER COLUMN product_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN product_title SET DEFAULT 'n. a.',
ALTER COLUMN product_category SET DEFAULT 'n. a.',
ALTER COLUMN product_description SET DEFAULT 'n. a.',
ALTER COLUMN product_price SET DEFAULT 'n. a.',
ALTER COLUMN product_size SET DEFAULT 'n. a.',
ALTER COLUMN ta_start_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_end_dt SET DEFAULT '9999-12-31',
ALTER COLUMN ta_is_active SET DEFAULT TRUE,
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_products_scd (product_surr_id, product_src_id, source_system, source_entity, product_title, product_category, product_description, product_price, product_size, ta_start_dt, ta_end_dt, ta_is_active, ta_insert_dt)
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;