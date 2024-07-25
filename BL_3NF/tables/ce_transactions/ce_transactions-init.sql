ALTER TABLE bl_3nf.bl_3nf_ce_transactions
ALTER COLUMN transaction_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_transaction_id'),
ALTER COLUMN transaction_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN transaction_date SET DEFAULT '1900-01-01',
ALTER COLUMN transaction_time SET DEFAULT '00:00:00',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_transactions (transaction_id, transaction_src_id, source_system, source_entity, transaction_date, transaction_time, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;