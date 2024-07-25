ALTER TABLE bl_dm.bl_dm_dim_dates
ALTER COLUMN date_surr_id SET DEFAULT NEXTVAL('bl_dm.bl_dm_seq_date_surr_id'),
ALTER COLUMN full_date SET DEFAULT '1900-01-01',
ALTER COLUMN day_name SET DEFAULT 'n. a.',
ALTER COLUMN day_of_week SET DEFAULT -1,
ALTER COLUMN day_of_month SET DEFAULT -1,
ALTER COLUMN day_of_year SET DEFAULT -1,
ALTER COLUMN week_of_year SET DEFAULT -1,
ALTER COLUMN month_name SET DEFAULT 'n. a.',
ALTER COLUMN month_of_year SET DEFAULT -1,
ALTER COLUMN quarter SET DEFAULT -1,
ALTER COLUMN year SET DEFAULT -1;
COMMIT;

INSERT INTO bl_dm.bl_dm_dim_dates (date_surr_id, full_date, day_name, day_of_week, day_of_month, day_of_year, week_of_year, month_name, month_of_year, quarter, year)
VALUES (-1, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
COMMIT;