ALTER TABLE bl_3nf.bl_3nf_ce_employees
ALTER COLUMN employee_id SET DEFAULT NEXTVAL('bl_3nf.bl_3nf_seq_employee_id'),
ALTER COLUMN employee_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN employee_first_name SET DEFAULT 'n. a.',
ALTER COLUMN employee_last_name SET DEFAULT 'n. a.',
ALTER COLUMN employee_passport_id SET DEFAULT 'n. a.',
ALTER COLUMN employee_phone_number SET DEFAULT 'n. a.',
ALTER COLUMN employee_position_id SET DEFAULT -1,
ALTER COLUMN store_id SET DEFAULT -1,
ALTER COLUMN city_id SET DEFAULT -1,
ALTER COLUMN address SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_3nf.bl_3nf_ce_employees (employee_id, employee_src_id, source_system, source_entity, employee_first_name, employee_last_name, employee_passport_id, employee_phone_number, employee_position_id, store_id, city_id, address, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, -1, -1, -1, DEFAULT, DEFAULT, DEFAULT);
COMMIT;