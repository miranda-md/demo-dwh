CREATE TABLE IF NOT EXISTS bl_cl.data_load_logs (
    log_id SERIAL PRIMARY KEY,
    log_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    procedure_name VARCHAR(255),
    rows_affected INTEGER,
    log_message TEXT
);