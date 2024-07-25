ALTER TABLE bl_dm.bl_dm_dim_payments
ALTER COLUMN payment_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_payment_surr_id'),
ALTER COLUMN payment_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN payment_method SET DEFAULT 'n. a.',
ALTER COLUMN bank_id SET DEFAULT 'n. a.',
ALTER COLUMN bank_title SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_payments (payment_surr_id, payment_src_id, source_system, source_entity, payment_method, bank_id, bank_title, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;