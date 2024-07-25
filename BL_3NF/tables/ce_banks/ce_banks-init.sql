ALTER TABLE bl_3nf.bl_3nf_ce_banks
ALTER COLUMN bank_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_bank_id'),
ALTER COLUMN bank_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN bank_title SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_banks (bank_id, bank_src_id, source_system, source_entity, bank_title, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;