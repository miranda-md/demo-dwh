CREATE OR REPLACE PROCEDURE bl_cl.insert_data_load_log(
    IN p_procedure_name VARCHAR(255),
    IN p_rows_affected INTEGER,
    IN p_log_message TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO bl_cl.data_load_logs (procedure_name, rows_affected, log_message)
    VALUES (p_procedure_name, p_rows_affected, p_log_message);
EXCEPTION
    WHEN others THEN
        ROLLBACK;
        RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
END;
$$;