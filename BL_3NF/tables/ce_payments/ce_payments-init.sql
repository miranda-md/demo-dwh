ALTER TABLE bl_3nf.bl_3nf_ce_payments
ALTER COLUMN payment_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_payment_id'),
ALTER COLUMN payment_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN payment_method SET DEFAULT 'n. a.',
ALTER COLUMN bank_id SET DEFAULT -1,
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_payments (payment_id, payment_src_id, source_system, source_entity, payment_method, bank_id, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, -1, DEFAULT, DEFAULT);
COMMIT;