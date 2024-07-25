ALTER TABLE bl_dm.bl_dm_dim_customers
ALTER COLUMN customer_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_customer_surr_id'),
ALTER COLUMN customer_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN customer_first_name SET DEFAULT 'n. a.',
ALTER COLUMN customer_last_name SET DEFAULT 'n. a.',
ALTER COLUMN customer_email SET DEFAULT 'n. a.',
ALTER COLUMN customer_phone_number SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_customers (customer_surr_id, customer_src_id, source_system, source_entity, customer_first_name, customer_last_name, customer_email, customer_phone_number, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;