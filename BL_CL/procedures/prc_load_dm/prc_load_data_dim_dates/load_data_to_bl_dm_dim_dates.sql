CREATE OR REPLACE PROCEDURE bl_cl.load_data_to_bl_dm_dim_dates()
AS $$
BEGIN
    INSERT INTO bl_dm.bl_dm_dim_dates (
        date_surr_id,
        full_date,
        day_name,
        day_of_week,
        day_of_month,
        day_of_year,
        week_of_year,
        month_name,
        month_of_year,
        quarter,
        year
    )
    SELECT
        EXTRACT(EPOCH FROM full_date)::BIGINT as date_surr_id,
        full_date,
        TO_CHAR(full_date, 'Day') as day_name,
        EXTRACT(ISODOW FROM full_date) as day_of_week,
        EXTRACT(DAY FROM full_date) as day_of_month,
        EXTRACT(DOY FROM full_date) as day_of_year,
        EXTRACT(WEEK FROM full_date) as week_of_year,
        TO_CHAR(full_date, 'Month') as month_name,
        EXTRACT(MONTH FROM full_date) as month_of_year,
        EXTRACT(QUARTER FROM full_date) as quarter,
        EXTRACT(YEAR FROM full_date) as year
    FROM generate_series(
        '2020-01-01'::DATE,
        '2025-12-31'::DATE,
        '1 day'::INTERVAL
    ) AS full_date
    WHERE NOT EXISTS (
        SELECT 1
        FROM bl_dm.bl_dm_dim_dates d
        WHERE d.date_surr_id = EXTRACT(EPOCH FROM full_date)::BIGINT
    );
    -- COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE NOTICE 'Error: transaction was rolled back due to %', SQLERRM;
END;
$$ LANGUAGE plpgsql;