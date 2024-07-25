CREATE TABLE IF NOT EXISTS bl_dm.bl_dm_dim_dates (
    date_surr_id BIGINT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    day_of_week INT NOT NULL,
    day_of_month INT NOT NULL,
    day_of_year INT NOT NULL,
    week_of_year INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    month_of_year INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);