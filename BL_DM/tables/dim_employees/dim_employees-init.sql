ALTER TABLE bl_dm.bl_dm_dim_employees
ALTER COLUMN employee_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_employee_surr_id'),
ALTER COLUMN employee_src_id SET DEFAULT 'n. a.',
ALTER COLUMN source_system SET DEFAULT 'MANUAL',
ALTER COLUMN source_entity SET DEFAULT 'MANUAL',
ALTER COLUMN employee_first_name SET DEFAULT 'n. a.',
ALTER COLUMN employee_last_name SET DEFAULT 'n. a.',
ALTER COLUMN employee_passport_id SET DEFAULT 'n. a.',
ALTER COLUMN employee_phone_number SET DEFAULT 'n. a.', 
ALTER COLUMN employee_position_id SET DEFAULT 'n. a.',
ALTER COLUMN position_title SET DEFAULT 'n. a.',
ALTER COLUMN store_id SET DEFAULT 'n. a.',
ALTER COLUMN store_description SET DEFAULT 'n. a.',
ALTER COLUMN store_city SET DEFAULT 'n. a.',
ALTER COLUMN address SET DEFAULT 'n. a.',
ALTER COLUMN ta_insert_dt SET DEFAULT '1900-01-01',
ALTER COLUMN ta_update_dt SET DEFAULT '1900-01-01';
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_employees (employee_surr_id, employee_src_id, source_system, source_entity, employee_first_name, employee_last_name, employee_passport_id, employee_phone_number, employee_position_id, position_title, store_id, store_description, store_city, address, ta_insert_dt, ta_update_dt) 
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;