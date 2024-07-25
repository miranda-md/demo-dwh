ALTER TABLE bl_3nf.bl_3nf_ce_product_categories
ALTER COLUMN product_category_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_product_category_id'),
ALTER COLUMN product_categories_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN product_category_title SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_product_categories (product_category_id, product_categories_src_id, source_system, source_entity, product_category_title, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;